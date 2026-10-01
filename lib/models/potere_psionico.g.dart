// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potere_psionico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoterePsionico _$PoterePsionicoFromJson(
  Map<String, dynamic> json,
) => PoterePsionico(
  nome: json['nome'] as String,
  scuola: $enumDecode(_$ScuolaPsionicaEnumMap, json['scuola']),
  descrizione: json['descrizione'] as String,
  effetto: json['effetto'] as String,
  cd: (json['cd'] as num).toInt(),
  attivazione: $enumDecode(_$TipoAzioneEnumMap, json['attivazione']),
  durata: Durata.fromJson(json['durata'] as Map<String, dynamic>),
  gittata: (json['gittata'] as num).toInt(),
  multiBersaglio: json['multiBersaglio'] as bool,
  costo: (json['costo'] as num).toInt(),
  potenziamento1: json['potenziamento1'] == null
      ? null
      : Potenziamento.fromJson(json['potenziamento1'] as Map<String, dynamic>),
  potenziamento2: json['potenziamento2'] == null
      ? null
      : Potenziamento.fromJson(json['potenziamento2'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PoterePsionicoToJson(PoterePsionico instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'scuola': _$ScuolaPsionicaEnumMap[instance.scuola]!,
      'descrizione': instance.descrizione,
      'effetto': instance.effetto,
      'potenziamento1': instance.potenziamento1?.toJson(),
      'potenziamento2': instance.potenziamento2?.toJson(),
      'cd': instance.cd,
      'attivazione': _$TipoAzioneEnumMap[instance.attivazione]!,
      'durata': instance.durata.toJson(),
      'gittata': instance.gittata,
      'multiBersaglio': instance.multiBersaglio,
      'costo': instance.costo,
    };

const _$ScuolaPsionicaEnumMap = {
  ScuolaPsionica.telepatia: 'telepatia',
  ScuolaPsionica.divinazione: 'divinazione',
  ScuolaPsionica.distruzione: 'distruzione',
  ScuolaPsionica.dominazione: 'dominazione',
  ScuolaPsionica.illusione: 'illusione',
};

const _$TipoAzioneEnumMap = {
  TipoAzione.completa: 'completa',
  TipoAzione.standard: 'standard',
  TipoAzione.movimento: 'movimento',
  TipoAzione.veloce: 'veloce',
  TipoAzione.gratuita: 'gratuita',
};
