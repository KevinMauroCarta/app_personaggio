// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pianeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pianeta _$PianetaFromJson(Map<String, dynamic> json) => Pianeta(
  nome: json['nome'] as String,
  grandezza: $enumDecode(_$GrandezzaPianetaEnumMap, json['grandezza']),
  tipologia: $enumDecode(_$TipologiaPianetaEnumMap, json['tipologia']),
  luna: json['luna'] as bool? ?? false,
  lune:
      (json['lune'] as List<dynamic>?)
          ?.map((e) => Pianeta.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  capitale: json['capitale'] as String,
  densitaPopolativa: $enumDecode(
    _$DensitaPopolativaEnumMap,
    json['densitaPopolativa'],
  ),
  capacitaDelPianeta:
      (json['capacitaDelPianeta'] as List<dynamic>?)
          ?.map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tag: (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PianetaToJson(Pianeta instance) => <String, dynamic>{
  'nome': instance.nome,
  'grandezza': _$GrandezzaPianetaEnumMap[instance.grandezza]!,
  'tipologia': _$TipologiaPianetaEnumMap[instance.tipologia]!,
  'luna': instance.luna,
  'lune': instance.lune.map((e) => e.toJson()).toList(),
  'capitale': instance.capitale,
  'densitaPopolativa': _$DensitaPopolativaEnumMap[instance.densitaPopolativa]!,
  'capacitaDelPianeta': instance.capacitaDelPianeta
      .map((e) => e.toJson())
      .toList(),
  'tag': instance.tag,
};

const _$GrandezzaPianetaEnumMap = {
  GrandezzaPianeta.nano: 'nano',
  GrandezzaPianeta.piccolo: 'piccolo',
  GrandezzaPianeta.medio: 'medio',
  GrandezzaPianeta.grande: 'grande',
  GrandezzaPianeta.gigante: 'gigante',
};

const _$TipologiaPianetaEnumMap = {
  TipologiaPianeta.roccioso: 'roccioso',
  TipologiaPianeta.gassoso: 'gassoso',
  TipologiaPianeta.acquatico: 'acquatico',
};

const _$DensitaPopolativaEnumMap = {
  DensitaPopolativa.nessuna: 'nessuna',
  DensitaPopolativa.poca: 'poca',
  DensitaPopolativa.media: 'media',
  DensitaPopolativa.molta: 'molta',
  DensitaPopolativa.troppa: 'troppa',
};
