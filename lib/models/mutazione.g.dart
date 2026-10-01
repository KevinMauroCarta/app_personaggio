// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutazione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mutazione _$MutazioneFromJson(Map<String, dynamic> json) => Mutazione(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  modificatoreCaratteristica: json['modificatoreCaratteristica'] == null
      ? null
      : Modificatore.fromJson(
          json['modificatoreCaratteristica'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MutazioneToJson(Mutazione instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'modificatoreCaratteristica': instance.modificatoreCaratteristica?.toJson(),
};
