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
  modificatoreCaratteristica: json['modificatoreCaratteristica'] == null
      ? null
      : Modificatore.fromJson(
          json['modificatoreCaratteristica'] as Map<String, dynamic>,
        ),
  modificatoreAbilita: json['modificatoreAbilita'] == null
      ? null
      : Modificatore.fromJson(
          json['modificatoreAbilita'] as Map<String, dynamic>,
        ),
  tag: json['tag'] as String,
);

Map<String, dynamic> _$BackgroundToJson(
  Background instance,
) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'capacitaDiBackground': instance.capacitaDiBackground.toJson(),
  'modificatoreCaratteristica': instance.modificatoreCaratteristica?.toJson(),
  'modificatoreAbilita': instance.modificatoreAbilita?.toJson(),
  'tag': instance.tag,
};
