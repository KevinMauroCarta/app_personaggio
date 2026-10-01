// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'durata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Durata _$DurataFromJson(Map<String, dynamic> json) => Durata._(
  quantita: (json['quantita'] as num?)?.toInt(),
  unita: $enumDecodeNullable(_$UnitaDurataEnumMap, json['unita']),
);

Map<String, dynamic> _$DurataToJson(Durata instance) => <String, dynamic>{
  'quantita': instance.quantita,
  'unita': _$UnitaDurataEnumMap[instance.unita],
};

const _$UnitaDurataEnumMap = {
  UnitaDurata.round: 'round',
  UnitaDurata.minuti: 'minuti',
  UnitaDurata.ore: 'ore',
};
