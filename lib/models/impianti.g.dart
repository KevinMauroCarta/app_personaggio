// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impianti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Impianti _$ImpiantiFromJson(Map<String, dynamic> json) => Impianti(
  chipNeurali:
      (json['chipNeurali'] as List<dynamic>?)
          ?.map((e) => ChipNeurale.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  protesi:
      (json['protesi'] as List<dynamic>?)
          ?.map((e) => Protesi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ImpiantiToJson(Impianti instance) => <String, dynamic>{
  'chipNeurali': instance.chipNeurali.map((e) => e.toJson()).toList(),
  'protesi': instance.protesi.map((e) => e.toJson()).toList(),
};
