import 'package:json_annotation/json_annotation.dart';

import 'condizione.dart';
import 'personaggio.dart';
import 'ferite.dart';
import '../enums/taglia.dart';
import 'armi/arma.dart';
import 'equipaggiamento.dart';
import 'chip_neurale.dart';
import 'impianti.dart';
import 'protesi.dart';
import '../enums/abilita_arma.dart';
import '../enums/bersaglio.dart';
import '../services/effetti_personaggio.dart';
import 'modificatore.dart';

part 'scheda.g.dart';

/// Modello/Scheda
///
/// Rappresenta la scheda del personaggio così come mostrata in gioco (le
/// due pagine della scheda cartacea di riferimento): compone il
/// [Personaggio] costruito in fase di creazione con l'[Equipaggiamento] e
/// con i valori "di gioco" indipendenti che via via si aggiungeranno.
///
/// Molti valori di Sopravvivenza/Obiettivo sono derivati dalle
/// Caratteristiche del [Personaggio] tramite formule già stabilite (getter
/// qui sotto) invece di essere memorizzati: restano solo i campi che sono
/// davvero liberi/manuali (es. Ferite.attuali). Le formule non ancora
/// note (es. Furtività Passiva) restano campi manuali in attesa del
/// regolamento.
///
/// Ogni valore derivato somma alla sua formula il suo bonus: i
/// Modificatori che lo prendono come bersaglio, acquisiti da capacità,
/// background, mutazioni e impianti (vedi [bonusDaModificatori]).
@JsonSerializable()
class Scheda {
  final Personaggio personaggio;

  final List<String> keyword;

  /// Punti Ira attuali. Un personaggio parte con [iraIniziale] e da lì in
  /// poi vale sempre l'ultimo valore segnato sulla scheda.
  final int iraAttuale;

  static const int iraIniziale = 2;

  final Ferite ferite;

  final Equipaggiamento equipaggiamento;

  /// Chip Neurali e Protesi (Modello/Impianti).
  final Impianti impianti;

  /// NOTA: a differenza di Percezione Passiva (Scheda.percezionePassiva),
  /// la formula per Furtività Passiva non è ancora stabilita: resta un
  /// campo manuale.
  final int furtivitaPassiva;

  /// Shock accumulato al momento, che il giocatore segna a mano durante
  /// il gioco. Il massimo è invece derivato (vedi [shockMassimo]).
  final int shockAttuale;

  /// PE guadagnati in totale nella vita del personaggio: campo manuale,
  /// non ricavabile da [Personaggio.pxDisponibili] (che è invece quanto
  /// resta da spendere, vedi [peAttuali]).
  final int peGuadagnati;

  /// Le note che il giocatore si segna a mano durante il gioco, una per
  /// voce: sono testo libero, non hanno un catalogo dietro.
  @JsonKey(fromJson: _noteDaJson)
  final List<String> note;

  const Scheda({
    required this.personaggio,
    this.keyword = const [],
    // Con il nome della classe davanti, perché il codice generato
    // (scheda.g.dart) copia questo valore fuori dalla classe.
    this.iraAttuale = Scheda.iraIniziale,
    this.ferite = const Ferite(),
    this.equipaggiamento = const Equipaggiamento(),
    this.impianti = const Impianti(),
    this.furtivitaPassiva = 0,
    this.shockAttuale = 0,
    this.peGuadagnati = 0,
    this.note = const [],
  });

  /// I Modificatori in vigore sul personaggio: quelli di capacità,
  /// background, mutazioni e impianti installati.
  List<Modificatore> get _modificatori => modificatoriAttivi(
    capacita: personaggio.capacita,
    background: personaggio.background,
    mutazioni: personaggio.mutazioni,
    impianti: impianti,
  );

  /// Quanto i Modificatori in vigore cambiano [bersaglio]. I valori qui
  /// sotto lo sommano alla loro formula e, dove c'è, al bonus scritto a
  /// mano (es. Ferite bonus, Velocità bonus).
  int bonusDaModificatori(Bersaglio bersaglio) =>
      sommaModificatori(_modificatori, bersaglio);

  int _valoreCaratteristica(String nome) => personaggio.caratteristiche
      .firstWhere((c) => c.caratteristica.nome == nome)
      .valoreTotale;

  /// Quanto Carico di Chip Neurali regge il personaggio: la sua Volontà
  /// (Valore Totale). I chip potenziano, ma una mente debole finisce sotto
  /// il loro giogo.
  ///
  /// Nessun impianto dà bonus a Volontà o Resistenza (un test lo
  /// verifica), quindi nessun impianto può allargare il proprio limite.
  int get limiteCaricoChip => _valoreCaratteristica('Volontà');

  /// Quanto Carico di Protesi regge il personaggio: la sua Resistenza
  /// (Valore Totale), perché è il corpo a dover sopportare le modifiche.
  int get limiteCaricoProtesi => _valoreCaratteristica('Resistenza');

  /// True se [chip] si può installare: il suo Carico sta in quello che
  /// resta libero. Oltre il limite non si va.
  bool entraChip(ChipNeurale chip) =>
      impianti.caricoChip + chip.carico <= limiteCaricoChip;

  /// True se [protesi] si può installare. Vedi [entraChip].
  bool entraProtesi(Protesi protesi) =>
      impianti.caricoProtesi + protesi.carico <= limiteCaricoProtesi;

  /// Difesa Base = Iniziativa - 1.
  int get difesaBase =>
      _valoreCaratteristica('Iniziativa') -
      1 +
      bonusDaModificatori(Bersaglio.difesa);

  /// Resilienza Base = Resistenza + 1.
  int get resilienzaBase =>
      _valoreCaratteristica('Resistenza') +
      1 +
      bonusDaModificatori(Bersaglio.resilienza);

  /// Resilienza Fisica = PA dell'armatura equipaggiata + Resilienza Base.
  int get resilienzaFisica =>
      (equipaggiamento.armatura?.pa ?? 0) +
      resilienzaBase +
      bonusDaModificatori(Bersaglio.resilienzaFisica);

  /// Resilienza Energetica = PA Energia dell'armatura equipaggiata +
  /// Resilienza Base.
  int get resilienzaEnergetica =>
      (equipaggiamento.armatura?.paEnergia ?? 0) +
      resilienzaBase +
      bonusDaModificatori(Bersaglio.resilienzaEnergetica);

  int get feriteBase => ferite.base(_valoreCaratteristica('Resistenza'));

  /// Ferite Massime = Ferite Base + Modificatori.
  int get feriteMassime => feriteBase + bonusDaModificatori(Bersaglio.ferite);

  /// Shock Massimo = Volontà + Resistenza.
  int get shockMassimo =>
      _valoreCaratteristica('Volontà') +
      _valoreCaratteristica('Resistenza') +
      bonusDaModificatori(Bersaglio.shock);

  /// Grinta = Resistenza.
  int get grinta =>
      _valoreCaratteristica('Resistenza') +
      bonusDaModificatori(Bersaglio.grinta);

  /// Fermezza = Volontà.
  int get fermezza =>
      _valoreCaratteristica('Volontà') +
      bonusDaModificatori(Bersaglio.fermezza);

  /// Risolutezza = Volontà - 1.
  int get risolutezza =>
      _valoreCaratteristica('Volontà') -
      1 +
      bonusDaModificatori(Bersaglio.risolutezza);

  /// Influenza = Socialità: quanto peso ha il personaggio quando
  /// chiede qualcosa. È derivata come Grinta e Fermezza, così segue
  /// la Caratteristica invece di restare ferma a un numero scritto a
  /// mano e dimenticato lì.
  int get influenza =>
      _valoreCaratteristica('Socialità') +
      bonusDaModificatori(Bersaglio.influenza);

  /// La Corruzione sono due valori: i Punti, che si segnano uno alla
  /// volta, e il Grado, che da quei punti si ricava.
  ///
  /// Quanti Punti Corruzione fanno un Grado.
  static const int puntiPerGradoCorruzione = 5;

  /// Il Grado più alto che si può raggiungere.
  static const int gradoCorruzioneMassimo = 5;

  /// Quanti Punti Corruzione si possono avere al massimo: tanti
  /// quanti ne servono per arrivare all'ultimo Grado.
  static const int corruzioneMassima =
      puntiPerGradoCorruzione * gradoCorruzioneMassimo;

  /// Grado di Corruzione: ogni cinque Punti Corruzione se ne guadagna
  /// uno, e i punti che avanzano non contano finché non arrivano a
  /// cinque.
  ///
  /// È ricavato e non memorizzato, come le Condizioni: il grado non
  /// può restare indietro rispetto ai punti che lo generano. Il clamp
  /// serve alle schede salvate prima che i punti avessero un tetto.
  int get gradoCorruzione => (personaggio.corruzione ~/ puntiPerGradoCorruzione)
      .clamp(0, gradoCorruzioneMassimo);

  /// Il bonus a Velocità: la somma dei Modificatori.
  int get velocitaBonus => bonusDaModificatori(Bersaglio.velocita);

  /// Velocità Totale = 6 + [velocitaBonus].
  int get velocitaTotale => 6 + velocitaBonus;

  /// Riserva Furtiva = il valore scritto a mano ([furtivitaPassiva]) più
  /// i Modificatori.
  int get riservaFurtivaTotale =>
      furtivitaPassiva + bonusDaModificatori(Bersaglio.riservaFurtiva);

  /// Le Condizioni in cui si trova il personaggio: i malus e i bonus che
  /// si porta dietro in questo momento.
  ///
  /// Sono ricavate dallo stato della scheda, non memorizzate: "Ferito"
  /// compare quando il Grado Ferita supera lo zero, "Corrotto" quando
  /// lo supera il Grado di Corruzione, e ognuna porta come numero il
  /// grado stesso. Alzando o abbassando il grado la condizione si
  /// aggiorna da sé.
  List<Condizione> get condizioni {
    final ferito = ferite.gradoFerita.index;
    final corrotto = gradoCorruzione;
    return [
      if (ferito > 0) Condizione(nome: 'Ferito', valore: ferito),
      if (corrotto > 0) Condizione(nome: 'Corrotto', valore: corrotto),
    ];
  }

  /// Taglia: dipende dalla Razza del personaggio (Modello/Razza.taglia).
  Taglia get taglia => personaggio.razza.taglia;

  /// PE Attuali = i PX non ancora spesi del personaggio, tenuti
  /// aggiornati da Creazione/Modifica/Aumento.
  int get peAttuali => personaggio.pxDisponibili;

  /// Riserva di Dadi con cui si attacca usando [arma]: il Valore Totale
  /// che il personaggio ha nell'Abilità associata all'arma
  /// (Modello/Arma.abilitaAssociata). Non è un attributo dell'arma, per
  /// questo si calcola qui, dove ci sono sia l'arma sia il personaggio.
  ///
  /// Vale 0 se il personaggio non ha quell'Abilità in scheda.
  int riservaDiDadi(Arma arma) {
    final nomeAbilita = arma.abilitaAssociata.nomeAbilita;
    for (final a in personaggio.abilita) {
      if (a.abilita.nome == nomeAbilita) {
        return a.valoreTotale(
          _valoreCaratteristica(a.abilita.caratteristica.nome),
        );
      }
    }
    return 0;
  }

  /// Percezione Passiva = (Valore Base + Valore Bonus dell'abilità
  /// Percezione) / 2 (divisione intera).
  int get percezionePassiva {
    final percezione = personaggio.abilita.firstWhere(
      (a) => a.abilita.nome == 'Percezione',
    );
    return (percezione.valoreBase + percezione.valoreBonus) ~/ 2 +
        bonusDaModificatori(Bersaglio.percezionePassiva);
  }

  Scheda copyWith({
    Personaggio? personaggio,
    List<String>? keyword,
    int? iraAttuale,
    Ferite? ferite,
    Equipaggiamento? equipaggiamento,
    Impianti? impianti,
    int? furtivitaPassiva,
    int? shockAttuale,
    int? peGuadagnati,
    List<String>? note,
  }) {
    return Scheda(
      personaggio: personaggio ?? this.personaggio,
      keyword: keyword ?? this.keyword,
      iraAttuale: iraAttuale ?? this.iraAttuale,
      ferite: ferite ?? this.ferite,
      equipaggiamento: equipaggiamento ?? this.equipaggiamento,
      impianti: impianti ?? this.impianti,
      furtivitaPassiva: furtivitaPassiva ?? this.furtivitaPassiva,
      shockAttuale: shockAttuale ?? this.shockAttuale,
      peGuadagnati: peGuadagnati ?? this.peGuadagnati,
      note: note ?? this.note,
    );
  }

  factory Scheda.fromJson(Map<String, dynamic> json) => _$SchedaFromJson(json);

  Map<String, dynamic> toJson() => _$SchedaToJson(this);
}

/// Le schede salvate prima che le note fossero un elenco hanno qui un
/// testo unico: diventa la prima nota, invece di sparire.
List<String> _noteDaJson(Object? json) => switch (json) {
  final List<dynamic> elenco => elenco.cast<String>(),
  final String testo when testo.trim().isNotEmpty => [testo],
  _ => const <String>[],
};
