// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutazione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mutazione _$MutazioneFromJson(Map<String, dynamic> json) => Mutazione(
  nome: json['nome'] as String,
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  modificatori:
      (leggiModificatori(json, 'modificatori') as List<dynamic>?)
          ?.map((e) => Modificatore.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MutazioneToJson(Mutazione instance) => <String, dynamic>{
  'nome': instance.nome,
  'descrizione': instance.descrizione,
  'effetto': instance.effetto,
  'modificatori': instance.modificatori.map((e) => e.toJson()).toList(),
};
