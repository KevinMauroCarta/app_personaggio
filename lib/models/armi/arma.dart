import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../tratto.dart';
import 'arma_distanza.dart';
import 'arma_mischia.dart';

/// Modello/Armi/Arma
///
/// Quello che ogni arma ha, qualunque sia. È astratta perché un'arma non
/// esiste "in generale": o è da mischia ([ArmaMischia]) o è a distanza
/// ([ArmaDistanza]), e le due si comportano in modo diverso proprio nel
/// punto che conta, la gittata. Tenerle separate evita il campo
/// valorizzato a metà - una gittata lunga su un coltello, una portata in
/// mischia su un fucile.
///
/// Chi mostra un'arma senza sapere quale sia usa [etichettaGittata] e
/// [descrizioneTipo], così non deve fare un controllo di tipo per ogni
/// riga da scrivere.
abstract class Arma {
  final String nome;

  /// Abilità con cui si usa l'arma: da qui si ricava la Riserva di Dadi
  /// (Scheda.riservaDiDadi). Sta qui e non nelle sottoclassi perché
  /// mischia leggera e mischia pesante sono entrambe da mischia: il tipo
  /// di arma non basta a dedurla.
  final AbilitaArma abilitaAssociata;

  final int danno;

  /// Se il danno è fisico o energetico: dipende da cosa colpisce, non da
  /// quanto (vedi [TipoDanno]).
  final TipoDanno tipoDanno;

  final int dadiExtra;
  final int valorePenetrazione;
  final List<Tratto> tratti;

  /// Tag dell'arma, presi da Lista/Tag.
  final List<String> tag;

  /// Quanto vale l'arma, per comprarla e venderla.
  final int valore;

  final Rarita rarita;

  const Arma({
    required this.nome,
    required this.abilitaAssociata,
    required this.danno,
    required this.tipoDanno,
    required this.valore,
    required this.rarita,
    this.dadiExtra = 0,
    this.valorePenetrazione = 0,
    this.tratti = const [],
    this.tag = const [],
  });

  /// La gittata come va scritta sulla scheda: "2" per un'arma da mischia,
  /// "3 / 6 / 9" per una a distanza.
  String get etichettaGittata;

  /// Come si chiama questo tipo di arma ("Mischia", "Distanza").
  String get descrizioneTipo;

  /// L'arma giusta a partire dal JSON.
  ///
  /// La chiave 'tipo' dice quale sottoclasse ricostruire. Le armi salvate
  /// prima che esistessero i due tipi non ce l'hanno: si riconoscono
  /// dalla vecchia gittata, che era un oggetto con le tre distanze
  /// valorizzate solo per le armi a distanza.
  factory Arma.fromJson(Map<String, dynamic> json) {
    final tipo = json['tipo'] as String?;
    if (tipo == ArmaDistanza.tipo) return ArmaDistanza.fromJson(json);
    if (tipo == ArmaMischia.tipo) return ArmaMischia.fromJson(json);

    final gittata = json['gittata'];
    final aDistanza =
        gittata is Map<String, dynamic> && gittata['corta'] != null;
    return aDistanza ? ArmaDistanza.fromJson(json) : ArmaMischia.fromJson(json);
  }

  /// I campi comuni, da unire a quelli della sottoclasse.
  Map<String, dynamic> campiComuniJson() => {
    'nome': nome,
    'abilitaAssociata': abilitaAssociata.name,
    'danno': danno,
    'tipoDanno': tipoDanno.name,
    'dadiExtra': dadiExtra,
    'valorePenetrazione': valorePenetrazione,
    'tratti': tratti.map((t) => t.toJson()).toList(),
    'tag': tag,
    'valore': valore,
    'rarita': rarita.name,
  };

  Map<String, dynamic> toJson();
}

/// I campi comuni letti dal JSON, usati dalle due sottoclassi.
///
/// Sta qui, fuori dalla classe, perché un costruttore generativo non può
/// leggere membri dell'istanza che sta creando.
class CampiComuniArma {
  final String nome;
  final AbilitaArma abilitaAssociata;
  final int danno;
  final TipoDanno tipoDanno;
  final int dadiExtra;
  final int valorePenetrazione;
  final List<Tratto> tratti;
  final List<String> tag;
  final int valore;
  final Rarita rarita;

  const CampiComuniArma({
    required this.nome,
    required this.abilitaAssociata,
    required this.danno,
    required this.tipoDanno,
    required this.dadiExtra,
    required this.valorePenetrazione,
    required this.tratti,
    required this.tag,
    required this.valore,
    required this.rarita,
  });

  factory CampiComuniArma.fromJson(Map<String, dynamic> json) {
    return CampiComuniArma(
      nome: json['nome'] as String,
      // Le armi salvate prima che il campo esistesse ricadono sulla
      // scelta più probabile: Mira se l'arma spara, Mischia Leggera se no.
      abilitaAssociata: json['abilitaAssociata'] == null
          ? (json['gittata'] is Map<String, dynamic> &&
                    (json['gittata'] as Map<String, dynamic>)['corta'] != null
                ? AbilitaArma.mira
                : AbilitaArma.mischiaLeggera)
          : AbilitaArma.values.byName(json['abilitaAssociata'] as String),
      danno: json['danno'] as int,
      // Le armi salvate prima di questo campo erano tutte segnaposto:
      // fisico è il caso di gran lunga più comune.
      tipoDanno: json['tipoDanno'] == null
          ? TipoDanno.fisico
          : TipoDanno.values.byName(json['tipoDanno'] as String),
      dadiExtra: json['dadiExtra'] as int? ?? 0,
      valorePenetrazione: json['valorePenetrazione'] as int? ?? 0,
      tratti: (json['tratti'] as List<dynamic>? ?? [])
          .map((e) => Tratto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: (json['tag'] as List<dynamic>? ?? []).cast<String>(),
      valore: json['valore'] as int? ?? 0,
      rarita: json['rarita'] == null
          ? Rarita.comune
          : Rarita.values.byName(json['rarita'] as String),
    );
  }
}
