// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armatura.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Armatura _$ArmaturaFromJson(Map<String, dynamic> json) => Armatura(
  nome: json['nome'] as String,
  pa: (json['pa'] as num).toInt(),
  paEnergia: (json['paEnergia'] as num).toInt(),
  tratti:
      (json['tratti'] as List<dynamic>?)
          ?.map((e) => Tratto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tag:
      (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  valore: (json['valore'] as num?)?.toInt() ?? 0,
  rarita: $enumDecodeNullable(_$RaritaEnumMap, json['rarita']) ?? Rarita.comune,
);

Map<String, dynamic> _$ArmaturaToJson(Armatura instance) => <String, dynamic>{
  'nome': instance.nome,
  'pa': instance.pa,
  'paEnergia': instance.paEnergia,
  'tratti': instance.tratti.map((e) => e.toJson()).toList(),
  'tag': instance.tag,
  'valore': instance.valore,
  'rarita': _$RaritaEnumMap[instance.rarita]!,
};

const _$RaritaEnumMap = {
  Rarita.comune: 'comune',
  Rarita.nonComune: 'nonComune',
  Rarita.rara: 'rara',
  Rarita.moltoRara: 'moltoRara',
  Rarita.unica: 'unica',
};
