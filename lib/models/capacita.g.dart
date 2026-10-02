// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capacita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Capacita _$CapacitaFromJson(Map<String, dynamic> json) => Capacita(
  nome: json['nome'] as String,
  tipo: $enumDecode(_$TipoCapacitaEnumMap, json['tipo']),
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  modificatori:
      (leggiModificatori(json, 'modificatori') as List<dynamic>?)
          ?.map((e) => Modificatore.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  costo: (json['costo'] as num).toInt(),
  tag: (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CapacitaToJson(Capacita instance) => <String, dynamic>{
  'nome': instance.nome,
  'tipo': _$TipoCapacitaEnumMap[instance.tipo]!,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'modificatori': instance.modificatori.map((e) => e.toJson()).toList(),
  'costo': instance.costo,
  'tag': instance.tag,
};

const _$TipoCapacitaEnumMap = {
  TipoCapacita.generica: 'generica',
  TipoCapacita.razza: 'razza',
  TipoCapacita.sistema: 'sistema',
  TipoCapacita.pianeta: 'pianeta',
  TipoCapacita.background: 'background',
  TipoCapacita.impianto: 'impianto',
};
