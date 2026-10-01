// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tratto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tratto _$TrattoFromJson(Map<String, dynamic> json) => Tratto(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  ambiti:
      (json['ambiti'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AmbitoTrattoEnumMap, e))
          .toList() ??
      [],
);

Map<String, dynamic> _$TrattoToJson(Tratto instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'ambiti': instance.ambiti.map((e) => _$AmbitoTrattoEnumMap[e]!).toList(),
};

const _$AmbitoTrattoEnumMap = {
  AmbitoTratto.arma: 'arma',
  AmbitoTratto.armatura: 'armatura',
};
