import 'package:json_annotation/json_annotation.dart';

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
  @JsonKey(readValue: Arma.abilitaDaJson)
  final AbilitaArma abilitaAssociata;

  final int danno;

  /// Se il danno è fisico o energetico: dipende da cosa colpisce, non da
  /// quanto (vedi [TipoDanno]).
  ///
  /// Le armi salvate prima di questo campo erano tutte segnaposto:
  /// fisico è il caso di gran lunga più comune.
  @JsonKey(defaultValue: TipoDanno.fisico)
  final TipoDanno tipoDanno;

  final int dadiExtra;
  final int valorePenetrazione;
  final List<Tratto> tratti;

  /// Tag dell'arma, presi da Lista/Tag.
  final List<String> tag;

  /// Quanto vale l'arma, per comprarla e venderla.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
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
    return _vecchiaADistanza(json)
        ? ArmaDistanza.fromJson(json)
        : ArmaMischia.fromJson(json);
  }

  Map<String, dynamic> toJson();

  /// Legge [abilitaAssociata]. Le armi salvate prima che il campo
  /// esistesse ricadono sulla scelta più probabile: Mira se l'arma
  /// spara, Mischia Leggera se no.
  static Object? abilitaDaJson(Map<dynamic, dynamic> json, String chiave) =>
      json[chiave] ??
      (_vecchiaADistanza(json) ? AbilitaArma.mira : AbilitaArma.mischiaLeggera)
          .name;
}

/// True se [json] è un'arma salvata prima della divisione in due tipi,
/// con la vecchia gittata a oggetto e la distanza corta valorizzata.
bool _vecchiaADistanza(Map<dynamic, dynamic> json) {
  final gittata = json['gittata'];
  return gittata is Map && gittata['corta'] != null;
}
