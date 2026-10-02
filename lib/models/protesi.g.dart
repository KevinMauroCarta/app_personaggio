// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protesi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Protesi _$ProtesiFromJson(Map<String, dynamic> json) => Protesi(
  nome: json['nome'] as String,
  tipo: $enumDecode(_$TipoProtesiEnumMap, json['tipo']),
  parte: $enumDecode(_$ParteCorpoEnumMap, json['parte']),
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

Map<String, dynamic> _$ProtesiToJson(Protesi instance) => <String, dynamic>{
  'nome': instance.nome,
  'tipo': _$TipoProtesiEnumMap[instance.tipo]!,
  'parte': _$ParteCorpoEnumMap[instance.parte]!,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'modificatori': instance.modificatori.map((e) => e.toJson()).toList(),
  'capacita': instance.capacita?.toJson(),
  'carico': instance.carico,
  'valore': instance.valore,
  'rarita': _$RaritaEnumMap[instance.rarita]!,
};

const _$TipoProtesiEnumMap = {
  TipoProtesi.sostitutivo: 'sostitutivo',
  TipoProtesi.esoscheletro: 'esoscheletro',
};

const _$ParteCorpoEnumMap = {
  ParteCorpo.occhio: 'occhio',
  ParteCorpo.orecchio: 'orecchio',
  ParteCorpo.braccio: 'braccio',
  ParteCorpo.mano: 'mano',
  ParteCorpo.gamba: 'gamba',
  ParteCorpo.cuore: 'cuore',
  ParteCorpo.polmoni: 'polmoni',
  ParteCorpo.colonnaVertebrale: 'colonnaVertebrale',
  ParteCorpo.corpo: 'corpo',
};

const _$RaritaEnumMap = {
  Rarita.comune: 'comune',
  Rarita.nonComune: 'nonComune',
  Rarita.rara: 'rara',
  Rarita.moltoRara: 'moltoRara',
  Rarita.unica: 'unica',
};
