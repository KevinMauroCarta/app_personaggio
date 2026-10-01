// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesione_memorabile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LesioneMemorabile _$LesioneMemorabileFromJson(Map<String, dynamic> json) =>
    LesioneMemorabile(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
    );

Map<String, dynamic> _$LesioneMemorabileToJson(LesioneMemorabile instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'descrizione': instance.descrizione,
      'effetto': instance.effetto,
    };
