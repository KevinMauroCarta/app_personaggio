// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personaggio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Personaggio _$PersonaggioFromJson(Map<String, dynamic> json) => Personaggio(
  nome: json['nome'] as String,
  anni: (json['anni'] as num).toInt(),
  genere: $enumDecode(_$GenereEnumMap, json['genere']),
  razza: Razza.fromJson(json['razza'] as Map<String, dynamic>),
  sistemaDiOrigine: Sistema.fromJson(
    json['sistemaDiOrigine'] as Map<String, dynamic>,
  ),
  pianetaDiOrigine: Pianeta.fromJson(
    json['pianetaDiOrigine'] as Map<String, dynamic>,
  ),
  background: Background.fromJson(json['background'] as Map<String, dynamic>),
  caratteristiche:
      (json['caratteristiche'] as List<dynamic>?)
          ?.map(
            (e) =>
                CaratteristicaPersonaggio.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  abilita:
      (json['abilita'] as List<dynamic>?)
          ?.map((e) => AbilitaPersonaggio.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  talenti:
      (json['talenti'] as List<dynamic>?)
          ?.map((e) => Talento.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  capacita:
      (json['capacita'] as List<dynamic>?)
          ?.map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lesioniMemorabili:
      (json['lesioniMemorabili'] as List<dynamic>?)
          ?.map((e) => LesioneMemorabile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lesioniTraumatiche:
      (json['lesioniTraumatiche'] as List<dynamic>?)
          ?.map((e) => LesioneTraumatica.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mutazioni:
      (json['mutazioni'] as List<dynamic>?)
          ?.map((e) => Mutazione.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  corruzione: (json['corruzione'] as num?)?.toInt() ?? 0,
  poteriPsionici:
      (json['poteriPsionici'] as List<dynamic>?)
          ?.map((e) => PoterePsionico.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tag:
      (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  pxDisponibili: (json['pxDisponibili'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PersonaggioToJson(
  Personaggio instance,
) => <String, dynamic>{
  'nome': instance.nome,
  'anni': instance.anni,
  'genere': _$GenereEnumMap[instance.genere]!,
  'razza': instance.razza.toJson(),
  'sistemaDiOrigine': instance.sistemaDiOrigine.toJson(),
  'pianetaDiOrigine': instance.pianetaDiOrigine.toJson(),
  'background': instance.background.toJson(),
  'caratteristiche': instance.caratteristiche.map((e) => e.toJson()).toList(),
  'abilita': instance.abilita.map((e) => e.toJson()).toList(),
  'talenti': instance.talenti.map((e) => e.toJson()).toList(),
  'capacita': instance.capacita.map((e) => e.toJson()).toList(),
  'lesioniMemorabili': instance.lesioniMemorabili
      .map((e) => e.toJson())
      .toList(),
  'lesioniTraumatiche': instance.lesioniTraumatiche
      .map((e) => e.toJson())
      .toList(),
  'mutazioni': instance.mutazioni.map((e) => e.toJson()).toList(),
  'corruzione': instance.corruzione,
  'poteriPsionici': instance.poteriPsionici.map((e) => e.toJson()).toList(),
  'tag': instance.tag,
  'pxDisponibili': instance.pxDisponibili,
};

const _$GenereEnumMap = {
  Genere.maschio: 'maschio',
  Genere.femmina: 'femmina',
  Genere.nonDefinito: 'nonDefinito',
};
