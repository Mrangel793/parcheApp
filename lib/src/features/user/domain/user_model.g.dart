// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserModelImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  nombre: json['nombre'] as String,
  edad: (json['edad'] as num).toInt(),
  ciudad: json['ciudad'] as String,
  foto: json['foto'] as String,
  fotosAdicionales:
      (json['fotosAdicionales'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  intereses:
      (json['intereses'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  nivelEnergia:
      $enumDecodeNullable(_$EnergyLevelEnumMap, json['nivelEnergia']) ??
      EnergyLevel.media,
  rol: $enumDecodeNullable(_$UserRoleEnumMap, json['rol']) ?? UserRole.usuario,
  fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
  ultimaConexion: DateTime.parse(json['ultimaConexion'] as String),
  verificado: json['verificado'] as bool? ?? false,
  reputacion: (json['reputacion'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nombre': instance.nombre,
      'edad': instance.edad,
      'ciudad': instance.ciudad,
      'foto': instance.foto,
      'fotosAdicionales': instance.fotosAdicionales,
      'intereses': instance.intereses,
      'nivelEnergia': _$EnergyLevelEnumMap[instance.nivelEnergia]!,
      'rol': _$UserRoleEnumMap[instance.rol]!,
      'fechaCreacion': instance.fechaCreacion.toIso8601String(),
      'ultimaConexion': instance.ultimaConexion.toIso8601String(),
      'verificado': instance.verificado,
      'reputacion': instance.reputacion,
    };

const _$EnergyLevelEnumMap = {
  EnergyLevel.baja: 'baja',
  EnergyLevel.media: 'media',
  EnergyLevel.alta: 'alta',
};

const _$UserRoleEnumMap = {
  UserRole.usuario: 'usuario',
  UserRole.coordinador: 'coordinador',
  UserRole.negocio: 'negocio',
  UserRole.admin: 'admin',
};
