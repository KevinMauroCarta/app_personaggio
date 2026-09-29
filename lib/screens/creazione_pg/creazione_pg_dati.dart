/// -----------------------------------------------------------------------
/// DATI E COSTANTI CONDIVISE - Creazione Personaggio
/// -----------------------------------------------------------------------
/// Questo file raccoglie tutto ciò che serve alle pagine del flusso di
/// creazione del personaggio. Le opzioni dei menù a tendina sono derivate
/// direttamente dai dati di gioco canonici in lib/data, così da avere
/// un'unica fonte di verità (niente più liste duplicate o segnaposto dove
/// i dati reali sono ormai disponibili).
/// -----------------------------------------------------------------------
library;

import '../../data/lista_razze.dart';
import '../../data/lista_background.dart';
import '../../data/lista_sistemi.dart';
import '../../data/lista_caratteristiche.dart';
import '../../data/lista_abilita.dart';
import '../../data/lista_talenti.dart';
import '../../data/lista_capacita.dart';
import '../../data/lista_poteri_psionici.dart';
import '../../enums/tipo_capacita.dart';
import '../../enums/genere.dart';
import '../../models/abilita.dart';
import '../../models/background.dart';
import '../../models/pianeta.dart';
import '../../models/razza.dart';
import '../../models/sistema.dart';
import '../../models/talento.dart';
import '../../models/capacita.dart';
import '../../models/potere_psionico.dart';

/// Lookup per nome -> oggetto, costruiti una sola volta al caricamento del
/// modulo. Le pagine di creazione richiamano le funzioni sotto (es.
/// [descrizioneAbilita], [abilitaDaNome], [descrizioneCapacita]) una volta
/// per ogni riga/opzione mostrata a ogni rebuild: con liste anche solo di
/// qualche decina di elementi una scansione lineare per chiamata non pesa,
/// ma una Map evita comunque il lavoro ripetuto ed è la scelta corretta.
final Map<String, Abilita> _abilitaPerNome = {
  for (final a in listaAbilita) a.nome: a,
};
final Map<String, Capacita> _capacitaPerNome = {
  for (final c in listaCapacita) c.nome: c,
};

/// Punti esperienza totali a disposizione all'inizio della creazione.
/// NOTA: valore segnaposto, da confermare con il regolamento.
const int pxIniziali = 100;

/// Testo segnaposto usato come descrizione per le voci che non hanno
/// ancora un documento di regolamento reale (al momento: Capacità di
/// Razza, in attesa di Regolamento/Razze).
String descrizionePlaceholder(String nome) =>
    'Descrizione di "$nome" da definire (in attesa del regolamento).';

// ---------------------------------------------------------------------
// Pagina 1 - Info Generali
// ---------------------------------------------------------------------

/// Fonte: Lista/Razze (data/lista_razze.dart)
final List<String> razzeOptions = listaRazze.map((r) => r.nome).toList();

/// Fonte: enum Genere
final List<String> genereOptions = Genere.values.map((g) => g.label).toList();

/// Fonte: Lista/Background (data/lista_background.dart)
final List<String> backgroundOptions = listaBackground
    .map((b) => b.nome)
    .toList();

/// Fonte: Lista/Sistemi (data/lista_sistemi.dart)
final List<String> sistemiOptions = listaSistemi.map((s) => s.nome).toList();

/// Pianeti disponibili in base al sistema di origine selezionato.
/// Fonte: Lista/Pianeti + Regolamento/Pianeti/Sistema_* (data/lista_sistemi.dart).
/// NOTA: a differenza della versione precedente, ora tutti e 13 i sistemi
/// hanno i loro pianeti documentati (non più solo Solare, Ariete e Toro).
final Map<String, List<String>> pianetiPerSistema = {
  for (final sistema in listaSistemi)
    sistema.nome: sistema.pianeti.map((p) => p.nome).toList(),
};

/// Descrizioni delle Razze, usate nel Pulsante Info di Pagina 1.
/// Fonte: Lista/Razze. ATTENZIONE - dati incompleti: Regolamento/Razze non
/// è ancora disponibile, quindi ricade sul placeholder finché la
/// descrizione reale non è in data/lista_razze.dart.
final Map<String, String> razzeDescrizioni = {
  for (final r in listaRazze)
    r.nome: r.descrizione.isEmpty
        ? descrizionePlaceholder(r.nome)
        : r.descrizione,
};

/// Descrizioni dei Background, usate nel Pulsante Info di Pagina 1.
/// Fonte: Regolamento/Background.
final Map<String, String> backgroundDescrizioni = {
  for (final b in listaBackground) b.nome: b.descrizione,
};

/// Descrizioni dei Sistemi, usate nel Pulsante Info di Pagina 1.
/// Fonte: Regolamento/Sistemi. Modello/Sistema non prevede ancora un campo
/// "descrizione": il testo è composto da Governo e Tag, gli unici dati
/// narrativi al momento disponibili per sistema.
final Map<String, String> sistemiDescrizioni = {
  for (final s in listaSistemi)
    s.nome:
        'Governo: ${s.governo}'
        '${s.tag.isEmpty ? '' : '\nTag: ${s.tag}'}',
};

// ---------------------------------------------------------------------
// Pagina 2 - Gestione Esperienza
// ---------------------------------------------------------------------

/// Fonte: Lista/Caratteristiche (data/lista_caratteristiche.dart)
final List<String> caratteristicheNomi = listaCaratteristiche
    .map((c) => c.nome)
    .toList();

/// Diminutivo di ciascuna Caratteristica, mostrato accanto al nome nella
/// riga di Pagina 2 e come statistica associata di ciascuna Abilità.
final Map<String, String> caratteristicaDiminutivo = {
  'Forza': 'F',
  'Resistenza': 'R',
  'Agilità': 'A',
  'Iniziativa': 'I',
  'Volontà': 'Vol',
  'Intelletto': 'Int',
  'Socialità': 'Soc',
};

/// Fonte: Avanzamento/Caratteristiche
const int caratteristicaValoreIniziale = 1;
const int caratteristicaValoreMassimo = 12;

/// Fonte: Avanzamento/Abilità
const int abilitaValoreIniziale = 0;
const int abilitaValoreMassimo = 8;

/// Restrizione di avanzamento delle Abilità, spiegata in forma leggibile
/// per il Pulsante Info: un'abilità può superare il valore 1 solo se il
/// personaggio ha già appreso (Valore Base ≥ 1) un numero di abilità
/// diverse almeno pari al valore che si vuole raggiungere.
/// Fonte: Avanzamento/Abilità.
/// Cosa vuol dire l'asterisco a fianco del nome di un'Abilità. Sta qui
/// perché la stessa riga serve ovunque le abilità siano elencate -
/// Creazione, Riepilogo, Aumento e Scheda - e finché era scritta solo
/// in due di quei punti negli altri due l'asterisco restava un mistero.
const String legendaAsteriscoAbilita =
    'Le abilità contrassegnate con * richiedono almeno 1 in Valore Base '
    'per poter essere utilizzate (Regolamento/Abilità*).';

/// Fonte: Avanzamento/Abilità
const String restrizioneAvanzamentoAbilita =
    'Un\'abilità può essere portata a un valore x maggiore di 1 solo se il '
    'personaggio ha già appreso (Valore Base ≥ 1) almeno x abilità '
    'diverse.\n'
    'Esempio: per portare un\'abilità al valore 3, il personaggio deve '
    'aver già appreso almeno 3 abilità diverse.';

/// Indica se [nome], al valore che ha ORA, viola la restrizione di
/// Avanzamento/Abilità: un'abilità oltre 1 richiede che il personaggio
/// abbia appreso (Valore Base ≥ 1) almeno tante abilità diverse quanto il
/// suo valore, l'abilità stessa inclusa.
///
/// La restrizione non blocca più i bottoni +/-: si può sempre aumentare e
/// diminuire liberamente, e le abilità che risultano fuori regola vengono
/// semplicemente segnalate in rosso (APP/Pagina/Creazione-PG/Pagina_2).
bool abilitaViolaRestrizione(Map<String, int> valoriAbilita, String nome) {
  final valore = valoriAbilita[nome] ?? 0;
  if (valore <= 1) return false;

  final abilitaApprese = valoriAbilita.values.where((v) => v >= 1).length;
  return abilitaApprese < valore;
}

/// I nomi delle Abilità che violano la restrizione di
/// Avanzamento/Abilità, cioè quelle segnate in rosso.
///
/// Mentre si spendono i PE la violazione è permessa e solo segnalata -
/// serve a provare le combinazioni - ma un personaggio con abilità fuori
/// regola non si salva: vedi i controlli in Creazione/Modifica e Aumento.
List<String> abilitaFuoriRegola(Map<String, int> valoriAbilita) => [
  for (final nome in valoriAbilita.keys)
    if (abilitaViolaRestrizione(valoriAbilita, nome)) nome,
];

/// Descrizione di una singola Caratteristica, usata nel Pulsante Info
/// accanto a ciascuna riga di Pagina 2.
/// Fonte: Lista/Caratteristiche (data/lista_caratteristiche.dart).
String descrizioneCaratteristica(String nome) =>
    listaCaratteristiche.firstWhere((c) => c.nome == nome).descrizione;

/// Descrizione di una singola Abilità, usata nel Pulsante Info accanto a
/// ciascuna riga di Pagina 2.
/// Fonte: Lista/Abilità (data/lista_abilita.dart).
String descrizioneAbilita(String nome) => _abilitaPerNome[nome]!.descrizione;

/// Costo in PX per portare una Caratteristica al valore [valoreArrivo].
/// Fonte: Avanzamento/Caratteristiche:
/// - 2: costa 4
/// - 3: costa 6
/// - 4..12: costa (valoreArrivo - 2) * 5
int costoCaratteristica(int valoreArrivo) {
  switch (valoreArrivo) {
    case 2:
      return 4;
    case 3:
      return 6;
    default:
      return (valoreArrivo - 2) * 5;
  }
}

/// Costo in PX per portare un'Abilità al valore [valoreArrivo].
/// Fonte: Avanzamento/Abilità: costo = valoreArrivo * 2
int costoAbilita(int valoreArrivo) => valoreArrivo * 2;

/// PX complessivamente spesi per portare una Caratteristica dal valore di
/// partenza a [valore]: la somma dei costi di tutti i passaggi, dato che
/// [costoCaratteristica] è il costo del singolo passaggio.
int pxSpesiPerCaratteristica(int valore) {
  var totale = 0;
  for (var v = caratteristicaValoreIniziale + 1; v <= valore; v++) {
    totale += costoCaratteristica(v);
  }
  return totale;
}

/// PX complessivamente spesi per portare un'Abilità dal valore di
/// partenza a [valore]. Vedi [pxSpesiPerCaratteristica].
int pxSpesiPerAbilita(int valore) {
  var totale = 0;
  for (var v = abilitaValoreIniziale + 1; v <= valore; v++) {
    totale += costoAbilita(v);
  }
  return totale;
}

/// Totale dei PX spesi in Caratteristiche, mostrato accanto al titolo
/// della sezione nel Riepilogo.
int pxSpesiCaratteristiche(Map<String, int> valori) =>
    valori.values.fold(0, (somma, v) => somma + pxSpesiPerCaratteristica(v));

/// Totale dei PX spesi in Abilità, mostrato accanto al titolo della
/// sezione nel Riepilogo.
int pxSpesiAbilita(Map<String, int> valori) =>
    valori.values.fold(0, (somma, v) => somma + pxSpesiPerAbilita(v));

/// Totale dei PX spesi in Capacità Generiche, mostrato accanto al titolo
/// della sezione nel Riepilogo.
int pxSpesiCapacitaGeneriche(List<String> nomi) =>
    nomi.fold(0, (somma, nome) => somma + costoCapacita(nome));

/// Fonte: Lista/Abilità + Regolamento/Abilità (data/lista_abilita.dart),
/// raggruppate per Caratteristica associata.
///
/// NOTA: il vecchio dubbio sul significato dell'asterisco (*) in
/// Lista/Abilità è ora risolto: corrisponde al campo
/// [Abilita.addestramento] (vedi Regolamento/Abilità*). Non più gestito
/// qui perché non necessario per popolare i dropdown, ma disponibile
/// tramite [abilitaDaNome] per chi debba applicare la regola in futuro.
final Map<String, List<String>> abilitaPerCaratteristica = {
  for (final caratteristica in caratteristicheNomi)
    caratteristica: listaAbilita
        .where((a) => a.caratteristica.nome == caratteristica)
        .map((a) => a.nome)
        .toList(),
};

/// Elenco piatto di tutte le abilità, usato per popolare la sezione
/// Abilità nella Pagina 2.
final List<String> abilitaOptions = listaAbilita.map((a) => a.nome).toList();

/// Restituisce l'oggetto [Abilita] a partire dal nome, per recuperarne la
/// Caratteristica associata e il flag Addestramento.
Abilita abilitaDaNome(String nome) => _abilitaPerNome[nome]!;

/// Fonte: Lista/Talenti (data/lista_talenti.dart)
final List<String> talentiOptions = listaTalenti.map((t) => t.nome).toList();

/// Descrizioni dei Talenti, usate nel Pulsante Info.
/// Fonte: Regolamento/Talenti.
final Map<String, String> talentiDescrizioni = {
  for (final t in listaTalenti) t.nome: t.descrizione,
};

/// Capacità di Razza disponibili in base alla razza scelta.
///
/// ATTENZIONE - dati incompleti: Regolamento/Razze non è ancora
/// disponibile, quindi ogni razza ha al momento una lista vuota. Il
/// dropdown corrispondente si disabiliterà automaticamente finché non
/// verranno aggiunti i dati reali in data/lista_razze.dart.
final Map<String, List<String>> capacitaRazzaOptions = {
  for (final razza in listaRazze)
    razza.nome: razza.capacita.map((c) => c.nome).toList(),
};

/// Capacità di Sistema disponibili in base al sistema di origine scelto.
/// Fonte: Regolamento/Sistemi (data/lista_sistemi.dart). Non più
/// segnaposto: sono le Capacità reali associate a ciascun sistema.
final Map<String, List<String>> capacitaSistemaOptions = {
  for (final sistema in listaSistemi)
    sistema.nome: sistema.capacitaDelSistema.map((c) => c.nome).toList(),
};

/// Capacità di Background disponibili in base al background selezionato.
///
/// Ogni background ne ha una e una sola
/// (Modello/Background.capacitaDiBackground), quindi la lista contiene
/// sempre un unico elemento: resta una lista per uniformità con
/// [capacitaRazzaOptions] e [capacitaSistemaOptions], che alimentano
/// dropdown identici.
final Map<String, List<String>> capacitaBackgroundOptions = {
  for (final background in listaBackground)
    background.nome: [background.capacitaDiBackground.nome],
};

/// Capacità Generiche disponibili a tutti i personaggi.
/// Fonte: Regolamento/Capacità (data/lista_capacita.dart), filtrate per
/// Tipo = Generica. Non più segnaposto.
final List<String> capacitaGenericheOptions = listaCapacita
    .where((c) => c.tipo == TipoCapacita.generica)
    .map((c) => c.nome)
    .toList();

/// Descrizione + effetto di una Capacità (cercata nell'elenco completo di
/// Lista/Capacità), usata nel Pulsante Info per Capacità di Sistema e
/// Capacità Generiche. Se non trovata, ricade sul placeholder.
String descrizioneCapacita(String nome) {
  final capacita = _capacitaPerNome[nome];
  if (capacita == null) {
    return descrizionePlaceholder(nome);
  }
  return '${capacita.descrizione}\n\nEffetto: ${capacita.effetto}';
}

/// Costo in PX di una Capacità (Modello/Capacità.costo). 0 se la capacità
/// non è in Lista/Capacità.
int costoCapacita(String nome) => _capacitaPerNome[nome]?.costo ?? 0;

/// Etichetta del costo di ogni Capacità, mostrata in fondo alla riga
/// della voce nella tendina.
final Map<String, String> capacitaCosti = {
  for (final c in listaCapacita) c.nome: 'Costo: ${c.costo}',
};

/// Le [Capacita] corrispondenti ai [nomi] indicati, per il Pulsante Info
/// (che ne mostra tutti i campi, vedi DettagliCapacita). I nomi non
/// presenti in Lista/Capacità vengono saltati: succede solo per le
/// Capacità di Razza, ancora prive di dati reali.
List<Capacita> capacitaDaNomi(List<String> nomi) => [
  for (final nome in nomi)
    if (_capacitaPerNome[nome] != null) _capacitaPerNome[nome]!,
];

// ---------------------------------------------------------------------
// Risoluzione nome -> modello, per i Pulsanti Info della Pagina 1 che
// mostrano il modello completo (vedi dettagli_modelli.dart).
// ---------------------------------------------------------------------

List<Razza> razzeDaNomi(List<String> nomi) => [
  for (final r in listaRazze)
    if (nomi.contains(r.nome)) r,
];

List<Background> backgroundDaNomi(List<String> nomi) => [
  for (final b in listaBackground)
    if (nomi.contains(b.nome)) b,
];

List<Sistema> sistemiDaNomi(List<String> nomi) => [
  for (final s in listaSistemi)
    if (nomi.contains(s.nome)) s,
];

/// I pianeti del [sistema] indicato che corrispondono a [nomi]. Il
/// sistema serve perché i pianeti non hanno un elenco globale: stanno
/// dentro il proprio sistema (Lista/Pianeti).
List<Pianeta> pianetiDaNomi(String? sistema, List<String> nomi) {
  if (sistema == null) return const [];
  final pianeti = listaSistemi
      .where((s) => s.nome == sistema)
      .expand((s) => s.pianeti);
  return [
    for (final p in pianeti)
      if (nomi.contains(p.nome)) p,
  ];
}

// ---------------------------------------------------------------------
// Poteri Psionici
// ---------------------------------------------------------------------

/// Fonte: Lista/Poteri_Psionici (data/lista_poteri_psionici.dart).
///
/// Sono scegliibili solo dai personaggi che hanno il Tag Psionico (vedi
/// services/effetti_personaggio.dart): la sezione che li offre in
/// Pagina 2 compare solo in quel caso.
final List<String> poteriPsioniciOptions = listaPoteriPsionici
    .map((p) => p.nome)
    .toList();

final Map<String, PoterePsionico> _poteriPerNome = {
  for (final p in listaPoteriPsionici) p.nome: p,
};

/// I [PoterePsionico] corrispondenti ai [nomi] indicati.
List<PoterePsionico> poteriPsioniciDaNomi(List<String> nomi) => [
  for (final nome in nomi)
    if (_poteriPerNome[nome] != null) _poteriPerNome[nome]!,
];

/// Descrizione + effetto di un Potere Psionico, per il Pulsante Info.
String descrizionePoterePsionico(String nome) {
  final potere = _poteriPerNome[nome];
  if (potere == null) return descrizionePlaceholder(nome);
  return '${potere.descrizione}\n\nEffetto: ${potere.effetto}';
}

/// Costo in PE di un Potere Psionico (Modello/Potere_Psionico.costo).
/// 0 se il potere non è in Lista/Poteri_Psionici.
int costoPoterePsionico(String nome) => _poteriPerNome[nome]?.costo ?? 0;

/// Etichetta del costo mostrata in coda a ogni voce della tendina dei
/// Poteri Psionici.
final Map<String, String> poteriPsioniciCosti = {
  for (final p in listaPoteriPsionici) p.nome: 'Costo: ${p.costo}',
};

/// I [Talento] corrispondenti ai [nomi] indicati, per il Pulsante Info
/// che ne mostra il modello completo.
List<Talento> talentiDaNomi(List<String> nomi) => [
  for (final t in listaTalenti)
    if (nomi.contains(t.nome)) t,
];
