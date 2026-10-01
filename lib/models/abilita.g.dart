// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abilita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Abilita _$AbilitaFromJson(Map<String, dynamic> json) => Abilita(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  caratteristica: Caratteristica.fromJson(
    json['caratteristica'] as Map<String, dynamic>,
  ),
  addestramento: json['addestramento'] as bool,
);

Map<String, dynamic> _$AbilitaToJson(Abilita instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'caratteristica': instance.caratteristica.toJson(),
  'addestramento': instance.addestramento,
};
