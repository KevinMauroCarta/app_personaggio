import 'arma.dart';

/// Modello/Armi/ArmaMischia
///
/// Un'arma che colpisce da vicino: alla base aggiunge solo la [gittata],
/// cioè fin dove arriva il colpo (1 per le armi corte, 2 per quelle più
/// lunghe).
class ArmaMischia extends Arma {
  /// Chiave con cui l'arma si riconosce nel JSON salvato.
  static const String tipo = 'mischia';

  final int gittata;

  const ArmaMischia({
    required super.nome,
    required super.abilitaAssociata,
    required super.danno,
    required super.tipoDanno,
    required super.valore,
    required super.rarita,
    required this.gittata,
    super.dadiExtra,
    super.valorePenetrazione,
    super.tratti,
    super.tag,
  });

  @override
  String get etichettaGittata => '$gittata';

  @override
  String get descrizioneTipo => 'Mischia';

  factory ArmaMischia.fromJson(Map<String, dynamic> json) {
    final comuni = CampiComuniArma.fromJson(json);
    return ArmaMischia(
      nome: comuni.nome,
      abilitaAssociata: comuni.abilitaAssociata,
      danno: comuni.danno,
      tipoDanno: comuni.tipoDanno,
      dadiExtra: comuni.dadiExtra,
      valorePenetrazione: comuni.valorePenetrazione,
      tratti: comuni.tratti,
      tag: comuni.tag,
      valore: comuni.valore,
      rarita: comuni.rarita,
      gittata: _gittataDaJson(json),
    );
  }

  /// La gittata salvata. Le armi scritte prima della divisione in due
  /// tipi avevano un oggetto Gittata con dentro la portata in mischia.
  static int _gittataDaJson(Map<String, dynamic> json) {
    final gittata = json['gittata'];
    if (gittata is int) return gittata;
    if (gittata is Map<String, dynamic>) return gittata['mischia'] as int? ?? 1;
    return 1;
  }

  @override
  Map<String, dynamic> toJson() => {
    ...campiComuniJson(),
    'tipo': tipo,
    'gittata': gittata,
  };
}
