// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Background _$BackgroundFromJson(Map<String, dynamic> json) => Background(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  capacitaDiBackground: Capacita.fromJson(
    json['capacitaDiBackground'] as Map<String, dynamic>,
  ),
  modificatori:
      (leggiModificatori(json, 'modificatori') as List<dynamic>?)
          ?.map((e) => Modificatore.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tag: json['tag'] as String,
);

Map<String, dynamic> _$BackgroundToJson(Background instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'descrizione': instance.descrizione,
      'capacitaDiBackground': instance.capacitaDiBackground.toJson(),
      'modificatori': instance.modificatori.map((e) => e.toJson()).toList(),
      'tag': instance.tag,
    };
