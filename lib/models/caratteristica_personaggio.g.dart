// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caratteristica_personaggio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaratteristicaPersonaggio _$CaratteristicaPersonaggioFromJson(
  Map<String, dynamic> json,
) => CaratteristicaPersonaggio(
  caratteristica: Caratteristica.fromJson(
    json['caratteristica'] as Map<String, dynamic>,
  ),
  valoreBase: (json['valoreBase'] as num).toInt(),
  valoreBonus: (json['valoreBonus'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CaratteristicaPersonaggioToJson(
  CaratteristicaPersonaggio instance,
) => <String, dynamic>{
  'caratteristica': instance.caratteristica.toJson(),
  'valoreBase': instance.valoreBase,
  'valoreBonus': instance.valoreBonus,
};
