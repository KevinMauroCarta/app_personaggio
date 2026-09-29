import '../../data/armi/catalogo_armi.dart';
import '../../data/lista_armature.dart';
import '../../data/lista_oggetti.dart';
import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../../models/armi/arma.dart';
import '../../models/armi/arma_distanza.dart';
import '../../models/armatura.dart';

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
/// In ordine alfabetico: l'elenco mette insieme tre cataloghi diversi e
/// senza ordinamento uscirebbe a blocchi, con l'oggetto cercato in un
/// punto che dipende da quale dei tre lo contiene.
final List<String> oggettiOptions = [
  ...listaOggetti.map((o) => o.nome),
  ...armiOptions,
  ...armatureOptions,
]..sort(confrontaNomi);

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
Map<String, String> datiOggetto(String nome) {
  final generico = oggettoDaNome(nome);
  if (generico != null) {
    return {
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
