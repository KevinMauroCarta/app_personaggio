// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scheda _$SchedaFromJson(Map<String, dynamic> json) => Scheda(
  personaggio: Personaggio.fromJson(
    json['personaggio'] as Map<String, dynamic>,
  ),
  keyword:
      (json['keyword'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  iraAttuale: (json['iraAttuale'] as num?)?.toInt() ?? Scheda.iraIniziale,
  velocitaBonus: (json['velocitaBonus'] as num?)?.toInt() ?? 0,
  ferite: json['ferite'] == null
      ? const Ferite()
      : Ferite.fromJson(json['ferite'] as Map<String, dynamic>),
  equipaggiamento: json['equipaggiamento'] == null
      ? const Equipaggiamento()
      : Equipaggiamento.fromJson(
          json['equipaggiamento'] as Map<String, dynamic>,
        ),
  impianti: json['impianti'] == null
      ? const Impianti()
      : Impianti.fromJson(json['impianti'] as Map<String, dynamic>),
  furtivitaPassiva: (json['furtivitaPassiva'] as num?)?.toInt() ?? 0,
  shockAttuale: (json['shockAttuale'] as num?)?.toInt() ?? 0,
  peGuadagnati: (json['peGuadagnati'] as num?)?.toInt() ?? 0,
  note: json['note'] == null ? const [] : _noteDaJson(json['note']),
);

Map<String, dynamic> _$SchedaToJson(Scheda instance) => <String, dynamic>{
  'personaggio': instance.personaggio.toJson(),
  'keyword': instance.keyword,
  'iraAttuale': instance.iraAttuale,
  'velocitaBonus': instance.velocitaBonus,
  'ferite': instance.ferite.toJson(),
  'equipaggiamento': instance.equipaggiamento.toJson(),
  'impianti': instance.impianti.toJson(),
  'furtivitaPassiva': instance.furtivitaPassiva,
  'shockAttuale': instance.shockAttuale,
  'peGuadagnati': instance.peGuadagnati,
  'note': instance.note,
};
