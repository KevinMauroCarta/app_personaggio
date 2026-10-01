// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String? ?? '',
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
};
