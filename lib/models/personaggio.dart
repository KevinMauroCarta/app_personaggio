import 'package:json_annotation/json_annotation.dart';

import '../enums/genere.dart';
import 'razza.dart';
import 'sistema.dart';
import 'pianeta.dart';
import 'background.dart';
import 'caratteristica_personaggio.dart';
import 'abilita_personaggio.dart';
import 'talento.dart';
import 'capacita.dart';
import 'lesione_memorabile.dart';
import 'lesione_traumatica.dart';
import 'mutazione.dart';
import 'potere_psionico.dart';

part 'personaggio.g.dart';

/// Modello/Personaggio
///
/// Nota: [genere] non è elencato esplicitamente in Modello/Personaggio ma è
/// richiesto in APP/Pagina/Creazione-PG/Pagina_1: aggiunto qui per coerenza
/// con la pagina di creazione.
@JsonSerializable()
class Personaggio {
  final String nome;
  final int anni;
  final Genere genere;
  final Razza razza;
  final Sistema sistemaDiOrigine;
  final Pianeta pianetaDiOrigine;
  final Background background;
  final List<CaratteristicaPersonaggio> caratteristiche;
  final List<AbilitaPersonaggio> abilita;
  final List<Talento> talenti;
  final List<Capacita> capacita;
  final List<LesioneMemorabile> lesioniMemorabili;
  final List<LesioneTraumatica> lesioniTraumatiche;
  final List<Mutazione> mutazioni;
  final int corruzione;
  final List<PoterePsionico> poteriPsionici;
  final List<String> tag;

  /// PX non ancora spesi, cioè quelli rimasti al termine dell'ultima
  /// Creazione/Modifica/Aumento. È da qui che ripartono la Modifica e
  /// l'Aumento successivi, invece che da un valore ricalcolato.
  final int pxDisponibili;

  const Personaggio({
    required this.nome,
    required this.anni,
    required this.genere,
    required this.razza,
    required this.sistemaDiOrigine,
    required this.pianetaDiOrigine,
    required this.background,
    this.caratteristiche = const [],
    this.abilita = const [],
    this.talenti = const [],
    this.capacita = const [],
    this.lesioniMemorabili = const [],
    this.lesioniTraumatiche = const [],
    this.mutazioni = const [],
    this.corruzione = 0,
    this.poteriPsionici = const [],
    this.tag = const [],
    this.pxDisponibili = 0,
  });

  factory Personaggio.fromJson(Map<String, dynamic> json) =>
      _$PersonaggioFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaggioToJson(this);
}
