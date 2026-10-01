// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oggetto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Oggetto _$OggettoFromJson(Map<String, dynamic> json) => Oggetto(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String? ?? '',
  valore: (json['valore'] as num?)?.toInt() ?? 0,
  rarita: $enumDecodeNullable(_$RaritaEnumMap, json['rarita']) ?? Rarita.comune,
);

Map<String, dynamic> _$OggettoToJson(Oggetto instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
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
