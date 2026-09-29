import 'condizione.dart';
import 'personaggio.dart';
import 'ferite.dart';
import '../enums/taglia.dart';
import 'armi/arma.dart';
import 'equipaggiamento.dart';
import '../enums/abilita_arma.dart';

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
/// davvero liberi/manuali (es. Ferite.attuali, Ferite.bonus,
/// velocitaBonus). Le formule non ancora note (es. i bonus a Resilienza,
/// Furtività Passiva) restano campi manuali in attesa del regolamento.
class Scheda {
  final Personaggio personaggio;

  final List<String> keyword;

  /// Punti Ira attuali. Un personaggio parte con [iraIniziale] e da lì in
  /// poi vale sempre l'ultimo valore segnato sulla scheda.
  final int iraAttuale;

  static const int iraIniziale = 2;

  /// Bonus a Velocità (es. da Talenti/Capacità): Velocità Totale = 6 +
  /// [velocitaBonus].
  final int velocitaBonus;

  final Ferite ferite;

  final Equipaggiamento equipaggiamento;

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
  final List<String> note;

  const Scheda({
    required this.personaggio,
    this.keyword = const [],
    this.iraAttuale = iraIniziale,
    this.velocitaBonus = 0,
    this.ferite = const Ferite(),
    this.equipaggiamento = const Equipaggiamento(),
    this.furtivitaPassiva = 0,
    this.shockAttuale = 0,
    this.peGuadagnati = 0,
    this.note = const [],
  });

  int _valoreCaratteristica(String nome) => personaggio.caratteristiche
      .firstWhere((c) => c.caratteristica.nome == nome)
      .valoreTotale;

  /// Difesa Base = Iniziativa - 1.
  int get difesaBase => _valoreCaratteristica('Iniziativa') - 1;

  /// Resilienza Base = Resistenza + 1.
  int get resilienzaBase => _valoreCaratteristica('Resistenza') + 1;

  /// Resilienza Fisica = PA dell'armatura equipaggiata + Resilienza Base.
  int get resilienzaFisica =>
      (equipaggiamento.armatura?.pa ?? 0) + resilienzaBase;

  /// Resilienza Energetica = PA Energia dell'armatura equipaggiata +
  /// Resilienza Base.
  int get resilienzaEnergetica =>
      (equipaggiamento.armatura?.paEnergia ?? 0) + resilienzaBase;

  int get feriteBase => ferite.base(_valoreCaratteristica('Resistenza'));

  int get feriteMassime => ferite.massime(_valoreCaratteristica('Resistenza'));

  /// Shock Massimo = Volontà + Resistenza.
  int get shockMassimo =>
      _valoreCaratteristica('Volontà') + _valoreCaratteristica('Resistenza');

  /// Grinta = Resistenza.
  int get grinta => _valoreCaratteristica('Resistenza');

  /// Fermezza = Volontà.
  int get fermezza => _valoreCaratteristica('Volontà');

  /// Risolutezza = Volontà - 1.
  int get risolutezza => _valoreCaratteristica('Volontà') - 1;

  /// Influenza = Socialità: quanto peso ha il personaggio quando
  /// chiede qualcosa. È derivata come Grinta e Fermezza, così segue
  /// la Caratteristica invece di restare ferma a un numero scritto a
  /// mano e dimenticato lì.
  int get influenza => _valoreCaratteristica('Socialità');

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

  /// Velocità Totale = 6 + [velocitaBonus].
  int get velocitaTotale => 6 + velocitaBonus;

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
    return (percezione.valoreBase + percezione.valoreBonus) ~/ 2;
  }

  Scheda copyWith({
    Personaggio? personaggio,
    List<String>? keyword,
    int? iraAttuale,
    int? velocitaBonus,
    Ferite? ferite,
    Equipaggiamento? equipaggiamento,
    int? furtivitaPassiva,
    int? shockAttuale,
    int? peGuadagnati,
    List<String>? note,
  }) {
    return Scheda(
      personaggio: personaggio ?? this.personaggio,
      keyword: keyword ?? this.keyword,
      iraAttuale: iraAttuale ?? this.iraAttuale,
      velocitaBonus: velocitaBonus ?? this.velocitaBonus,
      ferite: ferite ?? this.ferite,
      equipaggiamento: equipaggiamento ?? this.equipaggiamento,
      furtivitaPassiva: furtivitaPassiva ?? this.furtivitaPassiva,
      shockAttuale: shockAttuale ?? this.shockAttuale,
      peGuadagnati: peGuadagnati ?? this.peGuadagnati,
      note: note ?? this.note,
    );
  }

  factory Scheda.fromJson(Map<String, dynamic> json) {
    return Scheda(
      personaggio: Personaggio.fromJson(
        json['personaggio'] as Map<String, dynamic>,
      ),
      keyword: (json['keyword'] as List<dynamic>? ?? []).cast<String>(),
      iraAttuale: json['iraAttuale'] as int? ?? iraIniziale,
      velocitaBonus: json['velocitaBonus'] as int? ?? 0,
      ferite: json['ferite'] == null
          ? const Ferite()
          : Ferite.fromJson(json['ferite'] as Map<String, dynamic>),
      equipaggiamento: json['equipaggiamento'] == null
          ? const Equipaggiamento()
          : Equipaggiamento.fromJson(
              json['equipaggiamento'] as Map<String, dynamic>,
            ),
      furtivitaPassiva: json['furtivitaPassiva'] as int? ?? 0,
      shockAttuale: json['shockAttuale'] as int? ?? 0,
      peGuadagnati: json['peGuadagnati'] as int? ?? 0,
      // Le schede salvate prima che le note fossero un elenco hanno qui
      // un testo unico: diventa la prima nota, invece di sparire.
      note: switch (json['note']) {
        final List<dynamic> elenco => elenco.cast<String>(),
        final String testo when testo.trim().isNotEmpty => [testo],
        _ => const <String>[],
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'personaggio': personaggio.toJson(),
    'keyword': keyword,
    'iraAttuale': iraAttuale,
    'velocitaBonus': velocitaBonus,
    'ferite': ferite.toJson(),
    'equipaggiamento': equipaggiamento.toJson(),
    'furtivitaPassiva': furtivitaPassiva,
    'shockAttuale': shockAttuale,
    'peGuadagnati': peGuadagnati,
    'note': note,
  };
}
