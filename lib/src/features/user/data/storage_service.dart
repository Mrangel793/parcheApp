import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Servicio para manejar la subida y gestión de archivos en Firebase Storage
class StorageService {
  final FirebaseStorage _storage;
  final Uuid _uuid = const Uuid();

  StorageService(this._storage);

  /// Sube una foto de perfil a Firebase Storage
  /// Comprime la imagen antes de subir (max 1MB, 1024x1024px)
  /// Returns: URL de descarga de la imagen
  Future<String> uploadProfilePhoto(File imageFile, String userId) async {
    try {
      // Comprimir imagen antes de subir
      final compressedFile = await _compressImage(imageFile);

      // Generar nombre único para la imagen
      final fileName = 'photo_${_uuid.v4()}.jpg';
      final path = 'users/$userId/profile/$fileName';

      // Subir archivo
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(
        compressedFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Obtener URL de descarga
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw StorageException(
        'Error al subir la foto de perfil: ${e.toString()}',
      );
    }
  }

  /// Elimina una foto de perfil del Storage
  /// [photoUrl] debe ser una URL completa de Firebase Storage
  Future<void> deleteProfilePhoto(String photoUrl) async {
    try {
      // Extraer el path de la URL
      final ref = _storage.refFromURL(photoUrl);
      await ref.delete();
    } catch (e) {
      // No lanzar error si la foto no existe
      // Esto puede pasar si se intenta borrar una foto que ya fue eliminada
      print('Warning: No se pudo eliminar la foto: ${e.toString()}');
    }
  }

  /// Sube múltiples fotos adicionales al perfil
  /// Returns: Lista de URLs de descarga
  Future<List<String>> uploadAdditionalPhotos(
    List<File> images,
    String userId,
  ) async {
    final urls = <String>[];

    for (final image in images) {
      try {
        // Comprimir imagen
        final compressedFile = await _compressImage(image);

        // Generar nombre único
        final fileName = 'additional_${_uuid.v4()}.jpg';
        final path = 'users/$userId/profile/$fileName';

        // Subir archivo
        final ref = _storage.ref().child(path);
        final uploadTask = await ref.putFile(
          compressedFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        // Obtener URL
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        urls.add(downloadUrl);
      } catch (e) {
        print('Error al subir foto adicional: ${e.toString()}');
        // Continuar con las demás fotos
      }
    }

    return urls;
  }

  /// Comprime una imagen para reducir su tamaño
  /// Target: max 1MB, dimensiones 1024x1024px
  Future<File> _compressImage(File imageFile) async {
    try {
      final filePath = imageFile.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw StorageException('No se pudo comprimir la imagen');
      }

      return File(result.path);
    } catch (e) {
      // Si falla la compresión, usar la imagen original
      print('Warning: No se pudo comprimir la imagen, usando original');
      return imageFile;
    }
  }

  /// Obtiene la referencia a la carpeta de perfil del usuario
  Reference getUserProfileRef(String userId) {
    return _storage.ref().child('users/$userId/profile');
  }
}

/// Excepción personalizada para errores de Storage
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => message;
}

/// Provider del FirebaseStorage
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

/// Provider del StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(firebaseStorageProvider));
});
