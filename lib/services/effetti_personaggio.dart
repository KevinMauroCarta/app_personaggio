import '../enums/bersaglio.dart';
import '../models/abilita_personaggio.dart';
import '../models/background.dart';
import '../models/capacita.dart';
import '../models/caratteristica_personaggio.dart';
import '../models/equipaggiamento.dart';
import '../models/impianti.dart';
import '../models/modificatore.dart';
import '../models/mutazione.dart';
import '../models/personaggio.dart';
import '../models/pianeta.dart';
import '../models/razza.dart';
import '../models/sistema.dart';
import '../models/talento.dart';

/// Effetti che le scelte fatte in Creazione/Modifica/Aumento applicano
/// automaticamente al personaggio: i Modificatori delle Capacità si
/// sommano al Valore Bonus della Caratteristica/Abilità indicata, e i Tag
/// di razza, sistema, pianeta, background, capacità e talenti confluiscono
/// nei Tag del personaggio.
///
/// Sono funzioni pure, richiamate al momento di costruire il
/// [Personaggio] a partire dall'elenco completo delle scelte:
/// ricalcolare sempre da zero, invece di accumulare in modo incrementale,
/// fa sì che togliere una capacità ne rimuova anche bonus e tag senza
/// nessun lavoro aggiuntivo.

/// Tutti i Modificatori in vigore: quelli delle [capacita] possedute, del
/// [background], delle [mutazioni] e degli [impianti] installati, con le
/// Capacità da Impianto che concedono, più quelli dei Tratti
/// dell'[equipaggiamento] in uso: l'armatura indossata e le armi
/// impugnate (Modello/Tratto).
///
/// Vanno passate tutte insieme, perché i bonus si ricalcolano sempre da
/// zero: è così che togliendo una capacità (o una mutazione, o un
/// impianto) sparisce anche il suo bonus, senza doverlo scalare a mano.
///
/// ATTENZIONE: i Talenti non compaiono qui perché Modello/Talento non ha
/// Modificatori - il suo Effetto è solo testo. Un talento che dice
/// "Iniziativa +2" quindi non alza niente da solo.
List<Modificatore> modificatoriAttivi({
  required List<Capacita> capacita,
  Background? background,
  List<Mutazione> mutazioni = const [],
  Impianti impianti = const Impianti(),
  Equipaggiamento equipaggiamento = const Equipaggiamento(),
}) => [
  for (final c in capacita) ...c.modificatori,
  ...?background?.modificatori,
  for (final m in mutazioni) ...m.modificatori,
  for (final c in impianti.chipNeurali) ...c.modificatori,
  for (final p in impianti.protesi) ...p.modificatori,
  for (final c in impianti.capacita) ...c.modificatori,
  for (final t in [
    ...?equipaggiamento.armatura?.tratti,
    for (final a in equipaggiamento.armi) ...a.tratti,
  ])
    ...t.modificatoriEffettivi,
];

/// Quanto i [modificatori] cambiano [bersaglio]: la somma dei loro
/// valori, negativi compresi.
int sommaModificatori(
  Iterable<Modificatore> modificatori,
  Bersaglio bersaglio,
) {
  var totale = 0;
  for (final m in modificatori) {
    if (m.bersaglio == bersaglio) totale += m.valore;
  }
  return totale;
}

/// Il Valore Bonus della Caratteristica o dell'Abilità di nome [nome]:
/// la somma dei Modificatori che la toccano.
int _bonusPerNome(String nome, List<Modificatore> modificatori) {
  final bersaglio = Bersaglio.daLabel(nome);
  return bersaglio == null ? 0 : sommaModificatori(modificatori, bersaglio);
}

/// Valore Bonus della Caratteristica di nome [nome]. Le sorgenti sono
/// quelle di [modificatoriAttivi].
int bonusCaratteristica(
  String nome, {
  required List<Capacita> capacita,
  Background? background,
  List<Mutazione> mutazioni = const [],
  Impianti impianti = const Impianti(),
  Equipaggiamento equipaggiamento = const Equipaggiamento(),
}) => _bonusPerNome(
  nome,
  modificatoriAttivi(
    capacita: capacita,
    background: background,
    mutazioni: mutazioni,
    impianti: impianti,
    equipaggiamento: equipaggiamento,
  ),
);

/// Valore Bonus dell'Abilità di nome [nome]. Vedi [bonusCaratteristica].
int bonusAbilita(
  String nome, {
  required List<Capacita> capacita,
  Background? background,
  List<Mutazione> mutazioni = const [],
  Impianti impianti = const Impianti(),
  Equipaggiamento equipaggiamento = const Equipaggiamento(),
}) => _bonusPerNome(
  nome,
  modificatoriAttivi(
    capacita: capacita,
    background: background,
    mutazioni: mutazioni,
    impianti: impianti,
    equipaggiamento: equipaggiamento,
  ),
);

/// [p] con il Valore Bonus di Caratteristiche e Abilità ricalcolato da
/// tutto quello che porta un Modificatore: Capacità, Background e
/// Mutazioni del personaggio, più gli [impianti] (Chip Neurali e
/// Protesi, Modello/Impianti) e le Capacità da Impianto che concedono.
/// Con i bonus si ricalcolano anche i Tag, che quelle Capacità portano.
///
/// Le Capacità da Impianto non finiscono in [Personaggio.capacita]: sono
/// dell'impianto, e disinstallandolo se ne vanno con lui. Se fossero fra
/// le Capacità del Personaggio, Aumento le tratterebbe come comprate.
///
/// Gli Impianti stanno nella Scheda e non nel Personaggio, quindi
/// Creazione, Modifica e Aumento - che lavorano sul solo Personaggio -
/// non li vedono, e i loro bonus li ricalcolano senza. Chi rimette un
/// Personaggio nella sua Scheda (la Home, al ritorno da Modifica e
/// Aumento) passa di qui, così gli effetti degli impianti non si perdono.
/// Lo stesso vale per l'[equipaggiamento]: i Tratti dell'armatura
/// indossata e delle armi impugnate (es. Potenziata alza la Forza).
Personaggio conEffettiRicalcolati(
  Personaggio p, {
  Impianti impianti = const Impianti(),
  Equipaggiamento equipaggiamento = const Equipaggiamento(),
}) {
  return Personaggio(
    nome: p.nome,
    anni: p.anni,
    genere: p.genere,
    razza: p.razza,
    sistemaDiOrigine: p.sistemaDiOrigine,
    pianetaDiOrigine: p.pianetaDiOrigine,
    background: p.background,
    caratteristiche: [
      for (final c in p.caratteristiche)
        CaratteristicaPersonaggio(
          caratteristica: c.caratteristica,
          valoreBase: c.valoreBase,
          valoreBonus: bonusCaratteristica(
            c.caratteristica.nome,
            capacita: p.capacita,
            background: p.background,
            mutazioni: p.mutazioni,
            impianti: impianti,
            equipaggiamento: equipaggiamento,
          ),
        ),
    ],
    abilita: [
      for (final a in p.abilita)
        AbilitaPersonaggio(
          abilita: a.abilita,
          valoreBase: a.valoreBase,
          valoreBonus: bonusAbilita(
            a.abilita.nome,
            capacita: p.capacita,
            background: p.background,
            mutazioni: p.mutazioni,
            impianti: impianti,
            equipaggiamento: equipaggiamento,
          ),
        ),
    ],
    talenti: p.talenti,
    capacita: p.capacita,
    lesioniMemorabili: p.lesioniMemorabili,
    lesioniTraumatiche: p.lesioniTraumatiche,
    mutazioni: p.mutazioni,
    corruzione: p.corruzione,
    poteriPsionici: p.poteriPsionici,
    // Anche i Tag: le Capacità da Impianto portano i loro, che ci sono
    // finché l'impianto è installato.
    tag: tagDelPersonaggio(
      razza: p.razza,
      sistema: p.sistemaDiOrigine,
      pianeta: p.pianetaDiOrigine,
      background: p.background,
      capacita: [...p.capacita, ...impianti.capacita],
      talenti: p.talenti,
    ),
    pxDisponibili: p.pxDisponibili,
  );
}

/// Il Tag che sblocca i Poteri Psionici: finché il personaggio non ce
/// l'ha fra i suoi Tag non può sceglierne nessuno. Si ottiene scegliendo
/// qualcosa che lo porta in dote - oggi la Capacità "Addestramento
/// Psichico" - e togliendo quella scelta i poteri tornano inaccessibili.
const String tagPsionico = 'Psionico';

/// True se [tag] contiene il Tag Psionico.
bool haTagPsionico(List<String> tag) => tag.contains(tagPsionico);

/// I Tag del personaggio (Modello/Personaggio.tag).
///
/// Il personaggio parte senza tag: li acquisisce da ciò che sceglie, cioè
/// dalla razza, dal sistema e dal pianeta di origine, dal background,
/// dalle capacità e dai talenti. Ogni tag compare una volta sola, e i tag
/// vuoti vengono ignorati.
List<String> tagDelPersonaggio({
  required Razza razza,
  required Sistema sistema,
  required Pianeta pianeta,
  required Background background,
  required List<Capacita> capacita,
  required List<Talento> talenti,
}) {
  final tag = <String>[];

  void aggiungi(String valore) {
    if (valore.isEmpty || tag.contains(valore)) return;
    tag.add(valore);
  }

  aggiungi(razza.tag);
  aggiungi(sistema.tag);
  pianeta.tag.forEach(aggiungi);
  aggiungi(background.tag);
  for (final c in capacita) {
    c.tag.forEach(aggiungi);
  }
  for (final t in talenti) {
    aggiungi(t.tag);
  }

  return tag;
}
