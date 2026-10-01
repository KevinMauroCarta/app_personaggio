import 'package:json_annotation/json_annotation.dart';

import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../tratto.dart';
import 'arma.dart';

part 'arma_distanza.g.dart';

/// Modello/Armi/ArmaDistanza
///
/// Un'arma che colpisce da lontano. Rispetto alla base aggiunge le tre
/// gittate - [gittataCorta], [gittataMedia], [gittataLunga], tre valori
/// distinti e non un intervallo - e la [raffica], che solo le armi a
/// distanza possono avere.
@JsonSerializable()
class ArmaDistanza extends Arma {
  /// Chiave con cui l'arma si riconosce nel JSON salvato.
  static const String tipo = 'distanza';

  @JsonKey(readValue: _distanzaDaJson)
  final int gittataCorta;
  @JsonKey(readValue: _distanzaDaJson)
  final int gittataMedia;
  @JsonKey(readValue: _distanzaDaJson)
  final int gittataLunga;

  @JsonKey(defaultValue: false)
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

  factory ArmaDistanza.fromJson(Map<String, dynamic> json) =>
      _$ArmaDistanzaFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    ..._$ArmaDistanzaToJson(this),
    'tipo': tipo,
  };
}

/// Una delle tre gittate. Le armi scritte prima della divisione in due
/// tipi le tenevano dentro un oggetto Gittata: 'gittataCorta' nel formato
/// nuovo era 'corta' in quello vecchio.
Object? _distanzaDaJson(Map<dynamic, dynamic> json, String chiave) {
  if (json[chiave] != null) return json[chiave];
  final vecchia = json['gittata'];
  final chiaveVecchia = chiave.replaceFirst('gittata', '').toLowerCase();
  return (vecchia is Map ? vecchia[chiaveVecchia] : null) ?? 0;
}
