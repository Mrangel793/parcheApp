import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

/// Widget para seleccionar y mostrar la foto de perfil
/// Permite seleccionar desde cámara o galería
/// Incluye crop circular automático
class PhotoPickerWidget extends StatefulWidget {
  final File? currentPhoto;
  final Function(File?) onPhotoSelected;
  final double size;

  const PhotoPickerWidget({
    super.key,
    this.currentPhoto,
    required this.onPhotoSelected,
    this.size = 150,
  });

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  /// Muestra el modal para seleccionar foto desde cámara o galería
  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona una foto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF4ECDC4)),
                title: const Text('Cámara'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFC06BFF)),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              if (widget.currentPhoto != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _removePhoto();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Selecciona foto desde la cámara
  Future<void> _pickFromCamera() async {
    try {
      setState(() => _isLoading = true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _cropImage(File(image.path));
      }
    } catch (e) {
      _showError('Error al tomar la foto: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Selecciona foto desde la galería
  Future<void> _pickFromGallery() async {
    try {
      setState(() => _isLoading = true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _cropImage(File(image.path));
      }
    } catch (e) {
      _showError('Error al seleccionar la foto: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Recorta la imagen en formato cuadrado (se muestra circular en UI)
  Future<void> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajustar foto',
            toolbarColor: const Color(0xFF4ECDC4),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Ajustar foto',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        widget.onPhotoSelected(File(croppedFile.path));
      }
    } catch (e) {
      _showError('Error al recortar la foto: ${e.toString()}');
    }
  }

  /// Elimina la foto actual
  void _removePhoto() {
    widget.onPhotoSelected(null);
  }

  /// Muestra un mensaje de error
  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = widget.currentPhoto != null;

    return Center(
      child: Stack(
        children: [
          // Avatar circular
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasPhoto
                  ? const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFFC06BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: hasPhoto ? null : const Color(0xFFF8F9FA),
              border: Border.all(
                color: hasPhoto ? Colors.transparent : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4ECDC4),
                            ),
                          ),
                        )
                      : hasPhoto
                          ? Image.file(
                              widget.currentPhoto!,
                              fit: BoxFit.cover,
                              width: widget.size,
                              height: widget.size,
                            )
                          : Icon(
                              Icons.person,
                              size: widget.size * 0.5,
                              color: const Color(0xFFB2BEC3),
                            ),
                ),
              ),
            ),
          ),

          // Botón de cámara flotante
          if (!_isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickPhoto,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFF55E1D5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ECDC4).withAlpha(77),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
