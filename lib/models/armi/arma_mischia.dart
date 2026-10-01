import 'package:json_annotation/json_annotation.dart';

import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../tratto.dart';
import 'arma.dart';

part 'arma_mischia.g.dart';

/// Modello/Armi/ArmaMischia
///
/// Un'arma che colpisce da vicino: alla base aggiunge solo la [gittata],
/// cioè fin dove arriva il colpo (1 per le armi corte, 2 per quelle più
/// lunghe).
@JsonSerializable()
class ArmaMischia extends Arma {
  /// Chiave con cui l'arma si riconosce nel JSON salvato.
  static const String tipo = 'mischia';

  @JsonKey(readValue: _gittataDaJson)
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

  factory ArmaMischia.fromJson(Map<String, dynamic> json) =>
      _$ArmaMischiaFromJson(json);

  @override
  Map<String, dynamic> toJson() => {..._$ArmaMischiaToJson(this), 'tipo': tipo};
}

/// La gittata salvata. Le armi scritte prima della divisione in due tipi
/// avevano un oggetto Gittata con dentro la portata in mischia.
Object? _gittataDaJson(Map<dynamic, dynamic> json, String chiave) =>
    switch (json[chiave]) {
      final int gittata => gittata,
      final Map<dynamic, dynamic> vecchia => vecchia['mischia'] ?? 1,
      _ => 1,
    };
