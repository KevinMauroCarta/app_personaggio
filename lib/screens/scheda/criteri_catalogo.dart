import 'scheda_dati.dart';

/// Un campo delle voci di catalogo (armi, armature, oggetti) per cui la
/// modale di scelta ([DialogSceltaCatalogo]) può cercare e ordinare.
///
/// Ogni ricerca guarda un campo solo, scelto dal giocatore: cercare "3"
/// per Danno non tira fuori anche le armi con "3" nel nome. Più ricerche
/// salvate ([FiltroCatalogo]) si sommano: Nome "Ascia" E Danno 7.
///
/// Per aggiungere un campo basta un criterio nuovo - un [CriterioTesto]
/// o un [CriterioNumero] - messo nell'elenco del catalogo che lo ha
/// ([criteriArmi], [criteriArmature], [criteriOggetti]). La modale non
/// cambia.
abstract class CriterioCatalogo {
  final String etichetta;

  const CriterioCatalogo(this.etichetta);

  /// Se il campo si cerca per numero: la modale mostra la tastiera
  /// numerica e accetta solo cifre.
  bool get numerico;

  /// Se il campo ha un elenco chiuso di valori (il Tipo, la Rarità, i
  /// Tratti): la modale mostra una tendina con [valoriPossibili] invece
  /// del campo di testo, e il valore scelto deve combaciare per intero.
  bool get aScelta => false;

  /// I valori da offrire nella tendina, presi dalle voci [opzioni]:
  /// solo quelli che qualche voce ha davvero, perché sceglierne uno che
  /// nessuno ha darebbe sempre un elenco vuoto.
  List<String> valoriPossibili(List<String> opzioni) => const [];

  /// Se si può ordinare per questo campo. I Tratti e i Tag no: sono
  /// elenchi, e non hanno un "prima" e un "dopo".
  bool get ordinabile;

  /// Se la voce [nome] ha questo campo. Un oggetto generico non ha
  /// Danno né PA: cercando per Danno non compare, e ordinando per Danno
  /// finisce in fondo.
  bool haValore(String nome);

  /// Se la voce [nome] va mostrata cercando [cercato] in questo campo.
  /// [cercato] non è mai vuoto: a campo di ricerca vuoto si mostra
  /// tutto senza chiedere al criterio.
  bool corrisponde(String nome, String cercato);

  /// Confronta due voci che hanno entrambe il campo, dal valore più
  /// basso al più alto.
  int confronta(String a, String b);

  /// Il valore del campo come va scritto accanto al nome nella modale,
  /// o null se la voce non ce l'ha.
  String? testoValore(String nome);
}

/// Campo di testo, anche con più valori (i Tratti di un'arma): la voce
/// corrisponde se uno dei valori contiene il testo cercato, senza
/// badare a maiuscole e minuscole.
///
/// Si ordina in ordine alfabetico, oppure con [ordine] se il campo ha
/// una scala sua (la Rarità: "Comune" viene prima di "Rara" anche se
/// l'alfabeto dice il contrario).
class CriterioTesto extends CriterioCatalogo {
  /// I valori del campo, o null se la voce non ce l'ha.
  final List<String>? Function(String nome) valori;

  /// La posizione della voce sulla scala del campo, se ne ha una.
  final int Function(String nome)? ordine;

  @override
  final bool ordinabile;

  @override
  final bool aScelta;

  const CriterioTesto(
    super.etichetta,
    this.valori, {
    this.ordinabile = true,
    this.ordine,
    this.aScelta = false,
  });

  @override
  bool get numerico => false;

  @override
  bool haValore(String nome) => valori(nome)?.isNotEmpty ?? false;

  /// Un campo libero cerca il testo dentro il valore ("asc" trova
  /// "Ascia"); un campo a scelta vuole il valore intero, altrimenti
  /// "Rara" troverebbe anche "Molto Rara".
  @override
  bool corrisponde(String nome, String cercato) {
    final testo = cercato.trim().toLowerCase();
    return (valori(nome) ?? const []).any(
      (v) =>
          aScelta ? v.toLowerCase() == testo : v.toLowerCase().contains(testo),
    );
  }

  /// In ordine alfabetico, o sulla scala del campo se ne ha una: la
  /// Rarità va da Comune a Unica, non da "Comune" a "Unica" per lettera.
  @override
  List<String> valoriPossibili(List<String> opzioni) {
    // Per ogni valore, una voce che ce l'ha: serve a [ordine], che
    // lavora sulle voci e non sui valori.
    final voce = <String, String>{};
    for (final nome in opzioni) {
      for (final valore in valori(nome) ?? const <String>[]) {
        voce.putIfAbsent(valore, () => nome);
      }
    }
    final ordine = this.ordine;
    return voce.keys.toList()..sort(
      ordine == null
          ? confrontaNomi
          : (a, b) => ordine(voce[a]!).compareTo(ordine(voce[b]!)),
    );
  }

  @override
  int confronta(String a, String b) => ordine != null
      ? ordine!(a).compareTo(ordine!(b))
      : confrontaNomi(valori(a)!.join(', '), valori(b)!.join(', '));

  @override
  String? testoValore(String nome) =>
      haValore(nome) ? valori(nome)!.join(', ') : null;
}

/// Campo numerico: la voce corrisponde se il valore è esattamente
/// quello cercato. "Danno 3" vuol dire 3, non 13 o 30.
class CriterioNumero extends CriterioCatalogo {
  /// Il valore del campo, o null se la voce non ce l'ha.
  final int? Function(String nome) valore;

  const CriterioNumero(super.etichetta, this.valore);

  @override
  bool get numerico => true;

  @override
  bool get ordinabile => true;

  @override
  bool haValore(String nome) => valore(nome) != null;

  @override
  bool corrisponde(String nome, String cercato) {
    final numero = int.tryParse(cercato.trim());
    return numero != null && valore(nome) == numero;
  }

  @override
  int confronta(String a, String b) => valore(a)!.compareTo(valore(b)!);

  @override
  String? testoValore(String nome) => valore(nome)?.toString();
}

/// Una ricerca salvata: un campo e il valore cercato ("Danno: 7").
///
/// La modale ne tiene più d'una e mostra solo le voci che le
/// soddisfano tutte, così si restringe un passo alla volta: prima il
/// nome, poi il danno, poi il tipo.
class FiltroCatalogo {
  final CriterioCatalogo criterio;
  final String valore;

  const FiltroCatalogo(this.criterio, this.valore);

  bool corrisponde(String nome) => criterio.corrisponde(nome, valore);

  /// Come compare nel chip del filtro.
  String get etichetta => '${criterio.etichetta}: $valore';
}

// I criteri, uno per campo. Gli elenchi dei cataloghi li riusano.
//
// Si cerca per qualunque dato mostrato aprendo una voce nella modale
// (datiOggetto): ogni etichetta lì deve avere qui un criterio con lo
// stesso nome, e un test lo controlla. Aggiungendo un dato a
// datiOggetto, quel test ricorda di aggiungere anche il criterio.

/// Un dato di testo a valore singolo, letto da quelli che la modale
/// mostra (datiOggetto): così il testo cercato è esattamente quello che
/// si legge aprendo la voce.
List<String>? Function(String) _dato(String campo) => (nome) {
  final valore = datiOggetto(nome)[campo];
  return valore == null ? null : [valore];
};

final criterioNome = CriterioTesto('Nome', (nome) => [nome]);
final criterioDescrizione = CriterioTesto('Descrizione', _dato('Descrizione'));
final criterioTipo = CriterioTesto('Tipo', _dato('Tipo'), aScelta: true);
final criterioAbilita = CriterioTesto(
  'Abilità',
  _dato('Abilità'),
  aScelta: true,
);
final criterioTipoDanno = CriterioTesto(
  'Tipo Danno',
  _dato('Tipo Danno'),
  aScelta: true,
);
final criterioGittata = CriterioTesto('Gittata', _dato('Gittata'));
final criterioEffetto = CriterioTesto('Effetto', _dato('Effetto'));
final criterioParte = CriterioTesto(
  'Parte del Corpo',
  _dato('Parte del Corpo'),
  aScelta: true,
);
// Dalla tendina si sceglie il Modificatore intero ("Forza +1"). Come
// Tratti e Tag è un elenco, quindi non ordina.
final criterioModificatori = CriterioTesto(
  'Modificatori',
  modificatoriDi,
  ordinabile: false,
  aScelta: true,
);
// La Capacità da Impianto che chip e protesi concedono: dalla tendina si
// sceglie fra quelle che qualche impianto dà davvero.
final criterioCapacita = CriterioTesto(
  'Capacità',
  _dato('Capacità'),
  aScelta: true,
);
final criterioRaffica = CriterioTesto(
  'Raffica',
  _dato('Raffica'),
  aScelta: true,
);
final criterioRarita = CriterioTesto(
  'Rarità',
  _dato('Rarità'),
  ordine: (nome) => raritaDi(nome)!.index,
  aScelta: true,
);
// Tratti e Tag non sono enum, ma i loro valori sono un elenco chiuso
// (Lista/Tratti, Lista/Tag): sceglierli da una tendina evita di dover
// ricordare come si scrivono.
final criterioTratti = CriterioTesto(
  'Tratti',
  (nome) => trattiDi(nome)?.map((t) => t.nome).toList(),
  ordinabile: false,
  aScelta: true,
);
final criterioTag = CriterioTesto(
  'Tag',
  tagDi,
  ordinabile: false,
  aScelta: true,
);
final criterioDanno = CriterioNumero('Danno', (n) => armaDaNome(n)?.danno);
final criterioDadiExtra = CriterioNumero(
  'Dadi Extra',
  (n) => armaDaNome(n)?.dadiExtra,
);
final criterioVP = CriterioNumero(
  'Valore Penetrazione',
  (n) => armaDaNome(n)?.valorePenetrazione,
);
final criterioPA = CriterioNumero('PA', (n) => armaturaDaNome(n)?.pa);
final criterioPAEnergia = CriterioNumero(
  'PA Energia',
  (n) => armaturaDaNome(n)?.paEnergia,
);
final criterioValore = CriterioNumero('Valore', valoreDi);
final criterioCarico = CriterioNumero('Carico', caricoDi);

/// I criteri della scelta delle Armi, nell'ordine in cui la modale ne
/// mostra i dati. Il primo è quello di partenza, sia per cercare sia
/// per ordinare.
final List<CriterioCatalogo> criteriArmi = [
  criterioNome,
  criterioTipo,
  criterioAbilita,
  criterioDanno,
  criterioTipoDanno,
  criterioDadiExtra,
  criterioVP,
  criterioGittata,
  criterioRaffica,
  criterioValore,
  criterioRarita,
  criterioTratti,
  criterioTag,
];

/// Niente Tipo: per un'armatura è sempre "Armatura", e cercarlo non
/// restringerebbe niente.
final List<CriterioCatalogo> criteriArmature = [
  criterioNome,
  criterioPA,
  criterioPAEnergia,
  criterioValore,
  criterioRarita,
  criterioTratti,
  criterioTag,
];

/// La modale degli Oggetti mescola i tre cataloghi, quindi ha i campi
/// di tutti: le voci che un campo non ce l'hanno, cercando per quel
/// campo, spariscono.
final List<CriterioCatalogo> criteriOggetti = [
  criterioNome,
  criterioDescrizione,
  criterioTipo,
  criterioAbilita,
  criterioDanno,
  criterioTipoDanno,
  criterioDadiExtra,
  criterioVP,
  criterioGittata,
  criterioRaffica,
  criterioPA,
  criterioPAEnergia,
  criterioParte,
  criterioEffetto,
  criterioModificatori,
  criterioCapacita,
  criterioCarico,
  criterioValore,
  criterioRarita,
  criterioTratti,
  criterioTag,
];

/// I criteri della scelta dei Chip Neurali (pagina degli Impianti).
/// Niente Tipo: per un chip è sempre "Chip Neurale".
final List<CriterioCatalogo> criteriChipNeurali = [
  criterioNome,
  criterioDescrizione,
  criterioEffetto,
  criterioModificatori,
  criterioCapacita,
  criterioCarico,
  criterioValore,
  criterioRarita,
];

/// I criteri della scelta delle Protesi (pagina degli Impianti).
final List<CriterioCatalogo> criteriProtesi = [
  criterioNome,
  criterioTipo,
  criterioParte,
  criterioDescrizione,
  criterioEffetto,
  criterioModificatori,
  criterioCapacita,
  criterioCarico,
  criterioValore,
  criterioRarita,
];
