// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ferite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ferite _$FeriteFromJson(Map<String, dynamic> json) => Ferite(
  attuali: (json['attuali'] as num?)?.toInt() ?? 0,
  gradoFerita:
      $enumDecodeNullable(_$GradoFeritaEnumMap, json['gradoFerita']) ??
      GradoFerita.zero,
);

Map<String, dynamic> _$FeriteToJson(Ferite instance) => <String, dynamic>{
  'attuali': instance.attuali,
  'gradoFerita': _$GradoFeritaEnumMap[instance.gradoFerita]!,
};

const _$GradoFeritaEnumMap = {
  GradoFerita.zero: 'zero',
  GradoFerita.uno: 'uno',
  GradoFerita.due: 'due',
  GradoFerita.tre: 'tre',
};
