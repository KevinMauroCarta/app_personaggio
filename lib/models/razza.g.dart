// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razza.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Razza _$RazzaFromJson(Map<String, dynamic> json) => Razza(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  capacita: (json['capacita'] as List<dynamic>)
      .map((e) => Capacita.fromJson(e as Map<String, dynamic>))
      .toList(),
  tag: json['tag'] as String,
  taglia: $enumDecodeNullable(_$TagliaEnumMap, json['taglia']) ?? Taglia.media,
);

Map<String, dynamic> _$RazzaToJson(Razza instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'capacita': instance.capacita.map((e) => e.toJson()).toList(),
  'tag': instance.tag,
  'taglia': _$TagliaEnumMap[instance.taglia]!,
};

const _$TagliaEnumMap = {Taglia.piccola: 'piccola', Taglia.media: 'media'};
