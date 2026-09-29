import '../models/abilita_personaggio.dart';
import '../models/background.dart';
import '../models/capacita.dart';
import '../models/caratteristica_personaggio.dart';
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

/// Somma i [modificatori] che puntano a [nome], ignorando gli altri e
/// quelli assenti.
int _sommaPer(String nome, Iterable<Modificatore?> modificatori) {
  var totale = 0;
  for (final m in modificatori) {
    if (m != null && m.nome == nome) totale += m.valore;
  }
  return totale;
}

/// Valore Bonus della Caratteristica di nome [nome]: la somma di tutti i
/// Modificatori che la toccano.
///
/// Le sorgenti sono tutte quelle che in Modello/* hanno un campo
/// Modificatore: le [capacita] possedute, il [background], le
/// [mutazioni] e gli [impianti] installati, con le Capacità da Impianto
/// che concedono. Vanno passate tutte insieme, perché il bonus si
/// ricalcola sempre da zero: è così che togliendo una capacità (o una
/// mutazione, o un impianto) sparisce anche il suo bonus, senza doverlo
/// scalare a mano.
///
/// ATTENZIONE: i Talenti non compaiono qui perché Modello/Talento non ha
/// campi Modificatore - il suo Effetto è solo testo. Un talento che dice
/// "Iniziativa +2" quindi non alza niente da solo.
int bonusCaratteristica(
  String nome, {
  required List<Capacita> capacita,
  Background? background,
  List<Mutazione> mutazioni = const [],
  Impianti impianti = const Impianti(),
}) {
  return _sommaPer(nome, [
    for (final c in capacita) c.modificatoreCaratteristica,
    background?.modificatoreCaratteristica,
    for (final m in mutazioni) m.modificatoreCaratteristica,
    for (final c in impianti.chipNeurali) c.modificatoreCaratteristica,
    for (final p in impianti.protesi) p.modificatoreCaratteristica,
    for (final c in impianti.capacita) c.modificatoreCaratteristica,
  ]);
}

/// Valore Bonus dell'Abilità di nome [nome]. Vedi
/// [bonusCaratteristica]: stesse regole, ma le Mutazioni non entrano
/// perché Modello/Mutazione ha il solo Modificatore di Caratteristica.
int bonusAbilita(
  String nome, {
  required List<Capacita> capacita,
  Background? background,
  Impianti impianti = const Impianti(),
}) {
  return _sommaPer(nome, [
    for (final c in capacita) c.modificatoreAbilita,
    background?.modificatoreAbilita,
    for (final c in impianti.chipNeurali) c.modificatoreAbilita,
    for (final p in impianti.protesi) p.modificatoreAbilita,
    for (final c in impianti.capacita) c.modificatoreAbilita,
  ]);
}

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
Personaggio conEffettiRicalcolati(
  Personaggio p, {
  Impianti impianti = const Impianti(),
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
            impianti: impianti,
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
