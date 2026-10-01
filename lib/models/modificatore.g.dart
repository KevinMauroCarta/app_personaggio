// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modificatore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modificatore _$ModificatoreFromJson(Map<String, dynamic> json) => Modificatore(
  nome: json['nome'] as String,
  valore: (json['valore'] as num).toInt(),
);

Map<String, dynamic> _$ModificatoreToJson(Modificatore instance) =>
    <String, dynamic>{'nome': instance.nome, 'valore': instance.valore};
