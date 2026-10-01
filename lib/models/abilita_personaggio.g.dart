// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abilita_personaggio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbilitaPersonaggio _$AbilitaPersonaggioFromJson(Map<String, dynamic> json) =>
    AbilitaPersonaggio(
      abilita: Abilita.fromJson(json['abilita'] as Map<String, dynamic>),
      valoreBase: (json['valoreBase'] as num).toInt(),
      valoreBonus: (json['valoreBonus'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AbilitaPersonaggioToJson(AbilitaPersonaggio instance) =>
    <String, dynamic>{
      'abilita': instance.abilita.toJson(),
      'valoreBase': instance.valoreBase,
      'valoreBonus': instance.valoreBonus,
    };
