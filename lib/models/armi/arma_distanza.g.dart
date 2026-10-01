// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arma_distanza.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArmaDistanza _$ArmaDistanzaFromJson(Map<String, dynamic> json) => ArmaDistanza(
  nome: json['nome'] as String,
  abilitaAssociata: $enumDecode(
    _$AbilitaArmaEnumMap,
    Arma.abilitaDaJson(json, 'abilitaAssociata'),
  ),
  danno: (json['danno'] as num).toInt(),
  tipoDanno:
      $enumDecodeNullable(_$TipoDannoEnumMap, json['tipoDanno']) ??
      TipoDanno.fisico,
  valore: (json['valore'] as num?)?.toInt() ?? 0,
  rarita: $enumDecodeNullable(_$RaritaEnumMap, json['rarita']) ?? Rarita.comune,
  gittataCorta: (_distanzaDaJson(json, 'gittataCorta') as num).toInt(),
  gittataMedia: (_distanzaDaJson(json, 'gittataMedia') as num).toInt(),
  gittataLunga: (_distanzaDaJson(json, 'gittataLunga') as num).toInt(),
  raffica: json['raffica'] as bool? ?? false,
  dadiExtra: (json['dadiExtra'] as num?)?.toInt() ?? 0,
  valorePenetrazione: (json['valorePenetrazione'] as num?)?.toInt() ?? 0,
  tratti:
      (json['tratti'] as List<dynamic>?)
          ?.map((e) => Tratto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tag:
      (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ArmaDistanzaToJson(ArmaDistanza instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'abilitaAssociata': _$AbilitaArmaEnumMap[instance.abilitaAssociata]!,
      'danno': instance.danno,
      'tipoDanno': _$TipoDannoEnumMap[instance.tipoDanno]!,
      'dadiExtra': instance.dadiExtra,
      'valorePenetrazione': instance.valorePenetrazione,
      'tratti': instance.tratti.map((e) => e.toJson()).toList(),
      'tag': instance.tag,
      'valore': instance.valore,
      'rarita': _$RaritaEnumMap[instance.rarita]!,
      'gittataCorta': instance.gittataCorta,
      'gittataMedia': instance.gittataMedia,
      'gittataLunga': instance.gittataLunga,
      'raffica': instance.raffica,
    };

const _$AbilitaArmaEnumMap = {
  AbilitaArma.mira: 'mira',
  AbilitaArma.mischiaLeggera: 'mischiaLeggera',
  AbilitaArma.mischiaPesante: 'mischiaPesante',
};

const _$TipoDannoEnumMap = {
  TipoDanno.fisico: 'fisico',
  TipoDanno.energetico: 'energetico',
};

const _$RaritaEnumMap = {
  Rarita.comune: 'comune',
  Rarita.nonComune: 'nonComune',
  Rarita.rara: 'rara',
  Rarita.moltoRara: 'moltoRara',
  Rarita.unica: 'unica',
};
