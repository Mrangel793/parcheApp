// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int get edad => throw _privateConstructorUsedError;
  String get ciudad => throw _privateConstructorUsedError;
  String get foto => throw _privateConstructorUsedError;
  List<String> get fotosAdicionales => throw _privateConstructorUsedError;
  List<String> get intereses => throw _privateConstructorUsedError;
  EnergyLevel get nivelEnergia => throw _privateConstructorUsedError;
  UserRole get rol => throw _privateConstructorUsedError;
  DateTime get fechaCreacion => throw _privateConstructorUsedError;
  DateTime get ultimaConexion => throw _privateConstructorUsedError;
  bool get verificado => throw _privateConstructorUsedError;
  double get reputacion => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String email,
    String nombre,
    int edad,
    String ciudad,
    String foto,
    List<String> fotosAdicionales,
    List<String> intereses,
    EnergyLevel nivelEnergia,
    UserRole rol,
    DateTime fechaCreacion,
    DateTime ultimaConexion,
    bool verificado,
    double reputacion,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nombre = null,
    Object? edad = null,
    Object? ciudad = null,
    Object? foto = null,
    Object? fotosAdicionales = null,
    Object? intereses = null,
    Object? nivelEnergia = null,
    Object? rol = null,
    Object? fechaCreacion = null,
    Object? ultimaConexion = null,
    Object? verificado = null,
    Object? reputacion = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            edad: null == edad
                ? _value.edad
                : edad // ignore: cast_nullable_to_non_nullable
                      as int,
            ciudad: null == ciudad
                ? _value.ciudad
                : ciudad // ignore: cast_nullable_to_non_nullable
                      as String,
            foto: null == foto
                ? _value.foto
                : foto // ignore: cast_nullable_to_non_nullable
                      as String,
            fotosAdicionales: null == fotosAdicionales
                ? _value.fotosAdicionales
                : fotosAdicionales // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            intereses: null == intereses
                ? _value.intereses
                : intereses // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            nivelEnergia: null == nivelEnergia
                ? _value.nivelEnergia
                : nivelEnergia // ignore: cast_nullable_to_non_nullable
                      as EnergyLevel,
            rol: null == rol
                ? _value.rol
                : rol // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            fechaCreacion: null == fechaCreacion
                ? _value.fechaCreacion
                : fechaCreacion // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            ultimaConexion: null == ultimaConexion
                ? _value.ultimaConexion
                : ultimaConexion // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            verificado: null == verificado
                ? _value.verificado
                : verificado // ignore: cast_nullable_to_non_nullable
                      as bool,
            reputacion: null == reputacion
                ? _value.reputacion
                : reputacion // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String nombre,
    int edad,
    String ciudad,
    String foto,
    List<String> fotosAdicionales,
    List<String> intereses,
    EnergyLevel nivelEnergia,
    UserRole rol,
    DateTime fechaCreacion,
    DateTime ultimaConexion,
    bool verificado,
    double reputacion,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nombre = null,
    Object? edad = null,
    Object? ciudad = null,
    Object? foto = null,
    Object? fotosAdicionales = null,
    Object? intereses = null,
    Object? nivelEnergia = null,
    Object? rol = null,
    Object? fechaCreacion = null,
    Object? ultimaConexion = null,
    Object? verificado = null,
    Object? reputacion = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        edad: null == edad
            ? _value.edad
            : edad // ignore: cast_nullable_to_non_nullable
                  as int,
        ciudad: null == ciudad
            ? _value.ciudad
            : ciudad // ignore: cast_nullable_to_non_nullable
                  as String,
        foto: null == foto
            ? _value.foto
            : foto // ignore: cast_nullable_to_non_nullable
                  as String,
        fotosAdicionales: null == fotosAdicionales
            ? _value._fotosAdicionales
            : fotosAdicionales // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        intereses: null == intereses
            ? _value._intereses
            : intereses // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        nivelEnergia: null == nivelEnergia
            ? _value.nivelEnergia
            : nivelEnergia // ignore: cast_nullable_to_non_nullable
                  as EnergyLevel,
        rol: null == rol
            ? _value.rol
            : rol // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        fechaCreacion: null == fechaCreacion
            ? _value.fechaCreacion
            : fechaCreacion // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        ultimaConexion: null == ultimaConexion
            ? _value.ultimaConexion
            : ultimaConexion // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        verificado: null == verificado
            ? _value.verificado
            : verificado // ignore: cast_nullable_to_non_nullable
                  as bool,
        reputacion: null == reputacion
            ? _value.reputacion
            : reputacion // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl with DiagnosticableTreeMixin implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    required this.nombre,
    required this.edad,
    required this.ciudad,
    required this.foto,
    final List<String> fotosAdicionales = const [],
    final List<String> intereses = const [],
    this.nivelEnergia = EnergyLevel.media,
    this.rol = UserRole.usuario,
    required this.fechaCreacion,
    required this.ultimaConexion,
    this.verificado = false,
    this.reputacion = 0.0,
  }) : _fotosAdicionales = fotosAdicionales,
       _intereses = intereses;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String nombre;
  @override
  final int edad;
  @override
  final String ciudad;
  @override
  final String foto;
  final List<String> _fotosAdicionales;
  @override
  @JsonKey()
  List<String> get fotosAdicionales {
    if (_fotosAdicionales is EqualUnmodifiableListView)
      return _fotosAdicionales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fotosAdicionales);
  }

  final List<String> _intereses;
  @override
  @JsonKey()
  List<String> get intereses {
    if (_intereses is EqualUnmodifiableListView) return _intereses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_intereses);
  }

  @override
  @JsonKey()
  final EnergyLevel nivelEnergia;
  @override
  @JsonKey()
  final UserRole rol;
  @override
  final DateTime fechaCreacion;
  @override
  final DateTime ultimaConexion;
  @override
  @JsonKey()
  final bool verificado;
  @override
  @JsonKey()
  final double reputacion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(id: $id, email: $email, nombre: $nombre, edad: $edad, ciudad: $ciudad, foto: $foto, fotosAdicionales: $fotosAdicionales, intereses: $intereses, nivelEnergia: $nivelEnergia, rol: $rol, fechaCreacion: $fechaCreacion, ultimaConexion: $ultimaConexion, verificado: $verificado, reputacion: $reputacion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('nombre', nombre))
      ..add(DiagnosticsProperty('edad', edad))
      ..add(DiagnosticsProperty('ciudad', ciudad))
      ..add(DiagnosticsProperty('foto', foto))
      ..add(DiagnosticsProperty('fotosAdicionales', fotosAdicionales))
      ..add(DiagnosticsProperty('intereses', intereses))
      ..add(DiagnosticsProperty('nivelEnergia', nivelEnergia))
      ..add(DiagnosticsProperty('rol', rol))
      ..add(DiagnosticsProperty('fechaCreacion', fechaCreacion))
      ..add(DiagnosticsProperty('ultimaConexion', ultimaConexion))
      ..add(DiagnosticsProperty('verificado', verificado))
      ..add(DiagnosticsProperty('reputacion', reputacion));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.edad, edad) || other.edad == edad) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.foto, foto) || other.foto == foto) &&
            const DeepCollectionEquality().equals(
              other._fotosAdicionales,
              _fotosAdicionales,
            ) &&
            const DeepCollectionEquality().equals(
              other._intereses,
              _intereses,
            ) &&
            (identical(other.nivelEnergia, nivelEnergia) ||
                other.nivelEnergia == nivelEnergia) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion) &&
            (identical(other.ultimaConexion, ultimaConexion) ||
                other.ultimaConexion == ultimaConexion) &&
            (identical(other.verificado, verificado) ||
                other.verificado == verificado) &&
            (identical(other.reputacion, reputacion) ||
                other.reputacion == reputacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    nombre,
    edad,
    ciudad,
    foto,
    const DeepCollectionEquality().hash(_fotosAdicionales),
    const DeepCollectionEquality().hash(_intereses),
    nivelEnergia,
    rol,
    fechaCreacion,
    ultimaConexion,
    verificado,
    reputacion,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String email,
    required final String nombre,
    required final int edad,
    required final String ciudad,
    required final String foto,
    final List<String> fotosAdicionales,
    final List<String> intereses,
    final EnergyLevel nivelEnergia,
    final UserRole rol,
    required final DateTime fechaCreacion,
    required final DateTime ultimaConexion,
    final bool verificado,
    final double reputacion,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get nombre;
  @override
  int get edad;
  @override
  String get ciudad;
  @override
  String get foto;
  @override
  List<String> get fotosAdicionales;
  @override
  List<String> get intereses;
  @override
  EnergyLevel get nivelEnergia;
  @override
  UserRole get rol;
  @override
  DateTime get fechaCreacion;
  @override
  DateTime get ultimaConexion;
  @override
  bool get verificado;
  @override
  double get reputacion;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
