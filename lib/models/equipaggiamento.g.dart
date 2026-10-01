// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipaggiamento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipaggiamento _$EquipaggiamentoFromJson(Map<String, dynamic> json) =>
    Equipaggiamento(
      armi:
          (json['armi'] as List<dynamic>?)
              ?.map((e) => Arma.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      armatura: json['armatura'] == null
          ? null
          : Armatura.fromJson(json['armatura'] as Map<String, dynamic>),
      oggetti:
          (json['oggetti'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ricchezza: (json['ricchezza'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EquipaggiamentoToJson(Equipaggiamento instance) =>
    <String, dynamic>{
      'armi': instance.armi.map((e) => e.toJson()).toList(),
      'armatura': instance.armatura?.toJson(),
      'oggetti': instance.oggetti,
      'ricchezza': instance.ricchezza,
    };
