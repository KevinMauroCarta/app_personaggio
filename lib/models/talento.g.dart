// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Talento _$TalentoFromJson(Map<String, dynamic> json) => Talento(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  tag: json['tag'] as String,
);

Map<String, dynamic> _$TalentoToJson(Talento instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'tag': instance.tag,
};
