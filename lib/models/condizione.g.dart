// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condizione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condizione _$CondizioneFromJson(Map<String, dynamic> json) => Condizione(
  nome: json['nome'] as String,
  valore: (json['valore'] as num?)?.toInt(),
  effetto: json['effetto'] as String? ?? '',
);

Map<String, dynamic> _$CondizioneToJson(Condizione instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'valore': instance.valore,
      'effetto': instance.effetto,
    };
