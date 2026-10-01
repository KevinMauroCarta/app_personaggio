// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sistema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sistema _$SistemaFromJson(Map<String, dynamic> json) => Sistema(
  nome: json['nome'] as String,
  governo: json['governo'] as String,
  pianeti:
      (json['pianeti'] as List<dynamic>?)
          ?.map((e) => Pianeta.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  capacitaDelSistema:
      (json['capacitaDelSistema'] as List<dynamic>?)
          ?.map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mappaAssetPath: json['mappaAssetPath'] as String?,
  tag: json['tag'] as String,
);

Map<String, dynamic> _$SistemaToJson(Sistema instance) => <String, dynamic>{
  'nome': instance.nome,
  'governo': instance.governo,
  'pianeti': instance.pianeti.map((e) => e.toJson()).toList(),
  'capacitaDelSistema': instance.capacitaDelSistema
      .map((e) => e.toJson())
      .toList(),
  'mappaAssetPath': instance.mappaAssetPath,
  'tag': instance.tag,
};
