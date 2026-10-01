// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potenziamento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Potenziamento _$PotenziamentoFromJson(Map<String, dynamic> json) =>
    Potenziamento(
      nome: json['nome'] as String,
      costo: (json['costo'] as num).toInt(),
      replicabile: json['replicabile'] as bool,
      effetto: json['effetto'] as String,
    );

Map<String, dynamic> _$PotenziamentoToJson(Potenziamento instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'costo': instance.costo,
      'replicabile': instance.replicabile,
      'effetto': instance.effetto,
    };
