import '../../data/armi/catalogo_armi.dart';
import '../../data/lista_armature.dart';
import '../../data/lista_chip_neurali.dart';
import '../../data/lista_oggetti.dart';
import '../../data/lista_protesi.dart';
import '../../enums/abilita_arma.dart';
import '../../enums/parte_corpo.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../../enums/tipo_protesi.dart';
import '../../models/armi/arma.dart';
import '../../models/armi/arma_distanza.dart';
import '../../models/armatura.dart';
import '../../models/chip_neurale.dart';
import '../../models/modificatore.dart';
import '../../models/protesi.dart';
import '../../models/tratto.dart';

/// Dati di supporto alla Scheda: opzioni e lookup per i campi che si
/// scelgono da un catalogo (Armi e Armatura della sezione
/// Equipaggiamento), sullo stesso schema di creazione_pg_dati.dart.

final List<String> armiOptions = listaArmi.map((a) => a.nome).toList();

final List<String> armatureOptions = listaArmature.map((a) => a.nome).toList();

final Map<String, Arma> _armiPerNome = {for (final a in listaArmi) a.nome: a};

final Map<String, Armatura> _armaturePerNome = {
  for (final a in listaArmature) a.nome: a,
};

/// Le [Arma] corrispondenti ai [nomi] indicati, nell'ordine dei nomi:
/// l'ordine in cui il giocatore le ha scelte è quello in cui compaiono
/// in scheda.
List<Arma> armiDaNomi(List<String> nomi) => [
  for (final nome in nomi)
    if (_armiPerNome[nome] != null) _armiPerNome[nome]!,
];

Armatura? armaturaDaNome(String? nome) =>
    nome == null ? null : _armaturePerNome[nome];

List<Armatura> armatureDaNomi(List<String> nomi) => [
  for (final nome in nomi)
    if (_armaturePerNome[nome] != null) _armaturePerNome[nome]!,
];

// Impianti (pagina "Punk"): Chip Neurali e Protesi.

final List<String> chipNeuraliOptions = listaChipNeurali
    .map((c) => c.nome)
    .toList();

final List<String> protesiOptions = listaProtesi.map((p) => p.nome).toList();

final Map<String, ChipNeurale> _chipPerNome = {
  for (final c in listaChipNeurali) c.nome: c,
};

final Map<String, Protesi> _protesiPerNome = {
  for (final p in listaProtesi) p.nome: p,
};

ChipNeurale? chipNeuraleDaNome(String nome) => _chipPerNome[nome];

Protesi? protesiDaNome(String nome) => _protesiPerNome[nome];

/// Riassunto di un'arma per il campo "descrizioni" del dropdown, usato
/// quando il Pulsante Info non è disponibile.
String descrizioneArma(String nome) {
  final arma = _armiPerNome[nome];
  if (arma == null) return nome;
  return '${arma.descrizioneTipo} · Danno ${arma.danno} · '
      'Gittata ${arma.etichettaGittata}';
}

String descrizioneArmatura(String nome) {
  final armatura = _armaturePerNome[nome];
  if (armatura == null) return nome;
  return 'PA ${armatura.pa} · PA Energia ${armatura.paEnergia}';
}

/// Tutto quello che si può portare addosso: gli oggetti di
/// Lista/Oggetti, più armi e armature, che oggetti lo sono anche loro.
///
/// Un'arma elencata qui è la stessa che si sceglie nella sezione Armi:
/// metterla fra gli Oggetti serve a chi la trasporta senza impugnarla
/// (una pistola di scorta nello zaino), e non le dà una riga nella
/// tabella delle Armi.
///
/// Lo stesso per Chip Neurali e Protesi: fra gli Oggetti sono impianti
/// posseduti ma non installati, e non danno né Modificatori né
/// Capacità finché non si installano (pagina Punk, Modello/Impianti).
///
/// In ordine alfabetico: l'elenco mette insieme cataloghi diversi e
/// senza ordinamento uscirebbe a blocchi, con l'oggetto cercato in un
/// punto che dipende da quale lo contiene.
final List<String> oggettiOptions = [
  ...listaOggetti.map((o) => o.nome),
  ...armiOptions,
  ...armatureOptions,
  ...chipNeuraliOptions,
  ...protesiOptions,
]..sort(confrontaNomi);

/// True se [nome] è un impianto (Chip Neurale o Protesi) e quindi, se
/// sta fra gli Oggetti, si può installare.
bool eImpianto(String nome) =>
    _chipPerNome.containsKey(nome) || _protesiPerNome.containsKey(nome);

Arma? armaDaNome(String nome) => _armiPerNome[nome];

/// I Tratti di [nome], se è un'arma o un'armatura; null per un oggetto
/// generico, che di Tratti non ne ha.
List<Tratto>? trattiDi(String nome) =>
    _armiPerNome[nome]?.tratti ?? _armaturePerNome[nome]?.tratti;

/// I Tag di [nome], come per [trattiDi].
List<String>? tagDi(String nome) =>
    _armiPerNome[nome]?.tag ?? _armaturePerNome[nome]?.tag;

/// La Rarità di [nome]: come il Valore, ce l'hanno tutti i cataloghi.
Rarita? raritaDi(String nome) =>
    oggettoDaNome(nome)?.rarita ??
    _armiPerNome[nome]?.rarita ??
    _armaturePerNome[nome]?.rarita ??
    _chipPerNome[nome]?.rarita ??
    _protesiPerNome[nome]?.rarita;

/// Il Valore di [nome]: ce l'hanno tutti i cataloghi.
int? valoreDi(String nome) =>
    oggettoDaNome(nome)?.valore ??
    _armiPerNome[nome]?.valore ??
    _armaturePerNome[nome]?.valore ??
    _chipPerNome[nome]?.valore ??
    _protesiPerNome[nome]?.valore;

/// I Modificatori di [nome] come si leggono ("Forza +1"), se è un chip
/// o una protesi; null per il resto, che di Modificatori non ne ha.
List<String>? modificatoriDi(String nome) =>
    (_chipPerNome[nome]?.modificatori ?? _protesiPerNome[nome]?.modificatori)
        ?.map(testoModificatore)
        .toList();

/// Un Modificatore con il segno esplicito, come sulla scheda cartacea:
/// "Forza +1", "Mira -2".
String testoModificatore(Modificatore m) =>
    '${m.nome} ${m.valore >= 0 ? '+' : ''}${m.valore}';

/// Ordina due nomi ignorando maiuscole e minuscole, come se li
/// guardasse un lettore e non il codice dei caratteri.
int confrontaNomi(String a, String b) =>
    a.toLowerCase().compareTo(b.toLowerCase());

/// Tutti i dati dell'oggetto [nome], etichetta -> valore, come li mostra
/// la modale di scelta quando si apre la riga.
///
/// Un oggetto generico ha la sola descrizione; un'arma o un'armatura
/// hanno i loro campi, perché è lì che si decide se vale la pena
/// portarsela dietro.
///
/// Vale anche per Chip Neurali e Protesi della pagina degli Impianti,
/// che si scelgono dalla stessa modale: i nomi dei cataloghi non si
/// ripetono (lo controlla un test), quindi un nome basta a trovare la
/// voce.
///
/// Il Tipo ce l'hanno tutti, anche l'oggetto generico ("Oggetto"): nella
/// modale di scelta è con un filtro sul Tipo che si mostrano solo gli
/// oggetti, solo le armi o solo le armature.
Map<String, String> datiOggetto(String nome) {
  final generico = oggettoDaNome(nome);
  if (generico != null) {
    return {
      'Tipo': 'Oggetto',
      'Descrizione': generico.descrizione,
      'Valore': '${generico.valore}',
      'Rarità': generico.rarita.label,
    };
  }

  final arma = _armiPerNome[nome];
  if (arma != null) {
    return {
      'Tipo': 'Arma da ${arma.descrizioneTipo}',
      'Abilità': arma.abilitaAssociata.nomeAbilita,
      'Danno': '${arma.danno}',
      'Tipo Danno': arma.tipoDanno.label,
      'Dadi Extra': '${arma.dadiExtra}',
      'Valore Penetrazione': '${arma.valorePenetrazione}',
      'Gittata': arma.etichettaGittata,
      if (arma is ArmaDistanza) 'Raffica': arma.raffica ? 'Sì' : 'No',
      'Valore': '${arma.valore}',
      'Rarità': arma.rarita.label,
      'Tratti': _elenco(arma.tratti.map((t) => t.nome)),
      'Tag': _elenco(arma.tag),
    };
  }

  final armatura = _armaturePerNome[nome];
  if (armatura != null) {
    return {
      'Tipo': 'Armatura',
      'PA': '${armatura.pa}',
      'PA Energia': '${armatura.paEnergia}',
      'Valore': '${armatura.valore}',
      'Rarità': armatura.rarita.label,
      'Tratti': _elenco(armatura.tratti.map((t) => t.nome)),
      'Tag': _elenco(armatura.tag),
    };
  }

  final chip = _chipPerNome[nome];
  if (chip != null) {
    return {
      'Tipo': 'Chip Neurale',
      'Descrizione': chip.descrizione,
      'Effetto': chip.effetto,
      'Modificatori': _elenco(modificatoriDi(nome)!),
      'Capacità': chip.capacita?.nome ?? '-',
      'Valore': '${chip.valore}',
      'Rarità': chip.rarita.label,
    };
  }

  final protesi = _protesiPerNome[nome];
  if (protesi != null) {
    return {
      'Tipo': protesi.tipo.label,
      'Parte del Corpo': protesi.parte.label,
      'Descrizione': protesi.descrizione,
      'Effetto': protesi.effetto,
      'Modificatori': _elenco(modificatoriDi(nome)!),
      'Capacità': protesi.capacita?.nome ?? '-',
      'Valore': '${protesi.valore}',
      'Rarità': protesi.rarita.label,
    };
  }

  return const {};
}

String _elenco(Iterable<String> valori) =>
    valori.isEmpty ? '-' : valori.join(', ');

String descrizioneOggetto(String nome) {
  final generico = oggettoDaNome(nome);
  if (generico != null) return generico.descrizione;
  if (_armiPerNome.containsKey(nome)) return 'Arma · ${descrizioneArma(nome)}';
  if (_armaturePerNome.containsKey(nome)) {
    return 'Armatura · ${descrizioneArmatura(nome)}';
  }
  return nome;
}
