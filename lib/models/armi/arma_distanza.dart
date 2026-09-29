import 'arma.dart';

/// Modello/Armi/ArmaDistanza
///
/// Un'arma che colpisce da lontano. Rispetto alla base aggiunge le tre
/// gittate - [gittataCorta], [gittataMedia], [gittataLunga], tre valori
/// distinti e non un intervallo - e la [raffica], che solo le armi a
/// distanza possono avere.
class ArmaDistanza extends Arma {
  /// Chiave con cui l'arma si riconosce nel JSON salvato.
  static const String tipo = 'distanza';

  final int gittataCorta;
  final int gittataMedia;
  final int gittataLunga;

  final bool raffica;

  const ArmaDistanza({
    required super.nome,
    required super.abilitaAssociata,
    required super.danno,
    required super.tipoDanno,
    required super.valore,
    required super.rarita,
    required this.gittataCorta,
    required this.gittataMedia,
    required this.gittataLunga,
    this.raffica = false,
    super.dadiExtra,
    super.valorePenetrazione,
    super.tratti,
    super.tag,
  });

  @override
  String get etichettaGittata =>
      '$gittataCorta / $gittataMedia / $gittataLunga';

  @override
  String get descrizioneTipo => 'Distanza';

  factory ArmaDistanza.fromJson(Map<String, dynamic> json) {
    final comuni = CampiComuniArma.fromJson(json);
    // Le armi scritte prima della divisione in due tipi tenevano le tre
    // gittate dentro un oggetto Gittata.
    final vecchia = json['gittata'] is Map<String, dynamic>
        ? json['gittata'] as Map<String, dynamic>
        : const <String, dynamic>{};

    // 'gittataCorta' nel formato nuovo, 'corta' dentro la vecchia Gittata.
    int distanza(String chiave, String chiaveVecchia) =>
        json[chiave] as int? ?? vecchia[chiaveVecchia] as int? ?? 0;

    return ArmaDistanza(
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
      gittataCorta: distanza('gittataCorta', 'corta'),
      gittataMedia: distanza('gittataMedia', 'media'),
      gittataLunga: distanza('gittataLunga', 'lunga'),
      raffica: json['raffica'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...campiComuniJson(),
    'tipo': tipo,
    'gittataCorta': gittataCorta,
    'gittataMedia': gittataMedia,
    'gittataLunga': gittataLunga,
    'raffica': raffica,
  };
}
