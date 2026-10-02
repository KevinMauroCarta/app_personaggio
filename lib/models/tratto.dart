import 'package:json_annotation/json_annotation.dart';

import '../enums/ambito_tratto.dart';
import 'modificatore.dart';

part 'tratto.g.dart';

/// Modello/Tratto
///
/// Tratto di un'Arma o di un'Armatura. È un modello unico per entrambe,
/// con [ambiti] a dire dove si applica: stesso schema di
/// Modello/Capacità, che con TipoCapacita distingue capacità di tipi
/// diversi senza duplicare il modello.
///
/// Il motivo è che alcuni tratti valgono sia per le armi sia per le
/// armature: tenerli separati significherebbe scriverne il testo due
/// volte, con il rischio che le due copie divergano.
///
/// Alcuni tratti prendono un valore fra parentesi: "Scudo (X)", "Infligge
/// (Condizione)". [segnaposto] dice cosa prende (es. "X"), [valore] quanto
/// vale su quell'arma o armatura (es. "2", che si legge "Scudo (2)").
@JsonSerializable()
class Tratto {
  final String nome;
  final String descrizione;
  final String effetto;

  /// Dove si applica il tratto. Contiene entrambi i valori se il tratto
  /// vale sia per le armi sia per le armature.
  @JsonKey(defaultValue: <AmbitoTratto>[])
  final List<AmbitoTratto> ambiti;

  /// Cosa va fra parentesi dopo il nome ("X", "Condizione"), o null se il
  /// tratto non prende valori.
  final String? segnaposto;

  /// Il valore del tratto su questa arma o armatura, al posto del
  /// [segnaposto]; null nel catalogo, dove il valore non è ancora deciso.
  final String? valore;

  /// I Modificatori che il tratto dà a chi usa l'arma o indossa l'armatura
  /// (Modello/Modificatore). Solo per gli effetti senza condizioni: un
  /// "+1 Difesa contro gli attacchi in mischia" resta nel testo.
  ///
  /// Per un tratto con segnaposto "X" valgono per ogni punto di X: quelli
  /// che contano davvero sono [modificatoriEffettivi].
  @JsonKey(defaultValue: <Modificatore>[])
  final List<Modificatore> modificatori;

  const Tratto({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    required this.ambiti,
    this.segnaposto,
    this.valore,
    this.modificatori = const [],
  });

  bool get valePerArmi => ambiti.contains(AmbitoTratto.arma);
  bool get valePerArmature => ambiti.contains(AmbitoTratto.armatura);

  /// Il nome come si legge sull'arma: "Scudo (2)", "Infligge (In
  /// Fiamme)", o "Scudo (X)" nel catalogo, dove il valore manca.
  String get etichetta =>
      segnaposto == null ? nome : '$nome (${valore ?? segnaposto})';

  /// I [modificatori] moltiplicati per X, se il tratto prende un numero:
  /// Scudo (2) dà Difesa +2. Senza un valore numerico non danno niente.
  List<Modificatore> get modificatoriEffettivi {
    if (segnaposto != 'X') return modificatori;
    final x = int.tryParse(valore ?? '') ?? 0;
    return [
      for (final m in modificatori)
        Modificatore(bersaglio: m.bersaglio, valore: m.valore * x),
    ];
  }

  /// Questo tratto con [valore] fra parentesi, per metterlo su un'arma o
  /// un'armatura.
  Tratto conValore(String valore) => Tratto(
    nome: nome,
    descrizione: descrizione,
    effetto: effetto,
    ambiti: ambiti,
    segnaposto: segnaposto,
    valore: valore,
    modificatori: modificatori,
  );

  factory Tratto.fromJson(Map<String, dynamic> json) => _$TrattoFromJson(json);

  Map<String, dynamic> toJson() => _$TrattoToJson(this);
}
