// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_neurale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChipNeurale _$ChipNeuraleFromJson(Map<String, dynamic> json) => ChipNeurale(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String? ?? '',
  effetto: json['effetto'] as String? ?? '',
  modificatori:
      (leggiModificatori(json, 'modificatori') as List<dynamic>?)
          ?.map((e) => Modificatore.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  capacita: json['capacita'] == null
      ? null
      : Capacita.fromJson(json['capacita'] as Map<String, dynamic>),
  carico: (json['carico'] as num?)?.toInt() ?? 1,
  valore: (json['valore'] as num?)?.toInt() ?? 0,
  rarita: $enumDecodeNullable(_$RaritaEnumMap, json['rarita']) ?? Rarita.comune,
);

Map<String, dynamic> _$ChipNeuraleToJson(ChipNeurale instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'descrizione': instance.descrizione,
      'effetto': instance.effetto,
      'modificatori': instance.modificatori.map((e) => e.toJson()).toList(),
      'capacita': instance.capacita?.toJson(),
      'carico': instance.carico,
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
