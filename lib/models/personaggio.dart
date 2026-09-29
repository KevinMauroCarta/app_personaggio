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

/// Modello/Personaggio
///
/// Nota: [genere] non è elencato esplicitamente in Modello/Personaggio ma è
/// richiesto in APP/Pagina/Creazione-PG/Pagina_1: aggiunto qui per coerenza
/// con la pagina di creazione.
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

  factory Personaggio.fromJson(Map<String, dynamic> json) {
    return Personaggio(
      nome: json['nome'] as String,
      anni: json['anni'] as int,
      genere: Genere.values.byName(json['genere'] as String),
      razza: Razza.fromJson(json['razza'] as Map<String, dynamic>),
      sistemaDiOrigine: Sistema.fromJson(
        json['sistemaDiOrigine'] as Map<String, dynamic>,
      ),
      pianetaDiOrigine: Pianeta.fromJson(
        json['pianetaDiOrigine'] as Map<String, dynamic>,
      ),
      background: Background.fromJson(
        json['background'] as Map<String, dynamic>,
      ),
      caratteristiche: (json['caratteristiche'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                CaratteristicaPersonaggio.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      abilita: (json['abilita'] as List<dynamic>? ?? [])
          .map((e) => AbilitaPersonaggio.fromJson(e as Map<String, dynamic>))
          .toList(),
      talenti: (json['talenti'] as List<dynamic>? ?? [])
          .map((e) => Talento.fromJson(e as Map<String, dynamic>))
          .toList(),
      capacita: (json['capacita'] as List<dynamic>? ?? [])
          .map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList(),
      lesioniMemorabili: (json['lesioniMemorabili'] as List<dynamic>? ?? [])
          .map((e) => LesioneMemorabile.fromJson(e as Map<String, dynamic>))
          .toList(),
      lesioniTraumatiche: (json['lesioniTraumatiche'] as List<dynamic>? ?? [])
          .map((e) => LesioneTraumatica.fromJson(e as Map<String, dynamic>))
          .toList(),
      mutazioni: (json['mutazioni'] as List<dynamic>? ?? [])
          .map((e) => Mutazione.fromJson(e as Map<String, dynamic>))
          .toList(),
      corruzione: json['corruzione'] as int? ?? 0,
      poteriPsionici: (json['poteriPsionici'] as List<dynamic>? ?? [])
          .map((e) => PoterePsionico.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: (json['tag'] as List<dynamic>? ?? []).cast<String>(),
      pxDisponibili: json['pxDisponibili'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'anni': anni,
    'genere': genere.name,
    'razza': razza.toJson(),
    'sistemaDiOrigine': sistemaDiOrigine.toJson(),
    'pianetaDiOrigine': pianetaDiOrigine.toJson(),
    'background': background.toJson(),
    'caratteristiche': caratteristiche.map((c) => c.toJson()).toList(),
    'abilita': abilita.map((a) => a.toJson()).toList(),
    'talenti': talenti.map((t) => t.toJson()).toList(),
    'capacita': capacita.map((c) => c.toJson()).toList(),
    'lesioniMemorabili': lesioniMemorabili.map((l) => l.toJson()).toList(),
    'lesioniTraumatiche': lesioniTraumatiche.map((l) => l.toJson()).toList(),
    'mutazioni': mutazioni.map((m) => m.toJson()).toList(),
    'corruzione': corruzione,
    'poteriPsionici': poteriPsionici.map((p) => p.toJson()).toList(),
    'tag': tag,
    'pxDisponibili': pxDisponibili,
  };
}
