// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_neurale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChipNeurale _$ChipNeuraleFromJson(Map<String, dynamic> json) => ChipNeurale(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String? ?? '',
  effetto: json['effetto'] as String? ?? '',
  modificatoreCaratteristica: json['modificatoreCaratteristica'] == null
      ? null
      : Modificatore.fromJson(
          json['modificatoreCaratteristica'] as Map<String, dynamic>,
        ),
  modificatoreAbilita: json['modificatoreAbilita'] == null
      ? null
      : Modificatore.fromJson(
          json['modificatoreAbilita'] as Map<String, dynamic>,
        ),
  capacita: json['capacita'] == null
      ? null
      : Capacita.fromJson(json['capacita'] as Map<String, dynamic>),
  valore: (json['valore'] as num?)?.toInt() ?? 0,
  rarita: $enumDecodeNullable(_$RaritaEnumMap, json['rarita']) ?? Rarita.comune,
);

Map<String, dynamic> _$ChipNeuraleToJson(
  ChipNeurale instance,
) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'modificatoreCaratteristica': instance.modificatoreCaratteristica?.toJson(),
  'modificatoreAbilita': instance.modificatoreAbilita?.toJson(),
  'capacita': instance.capacita?.toJson(),
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
