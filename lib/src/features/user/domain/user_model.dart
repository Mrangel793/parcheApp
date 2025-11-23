
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum EnergyLevel { baja, media, alta }
enum UserRole { usuario, coordinador, negocio, admin }

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String nombre,
    required int edad,
    required String ciudad,
    required String foto,
    @Default([]) List<String> fotosAdicionales,
    @Default([]) List<String> intereses,
    @Default(EnergyLevel.media) EnergyLevel nivelEnergia,
    @Default(UserRole.usuario) UserRole rol,
    required DateTime fechaCreacion,
    required DateTime ultimaConexion,
    @Default(false) bool verificado,
    @Default(0.0) double reputacion,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
