import 'package:json_annotation/json_annotation.dart';

import '../enums/rarita.dart';
import 'tratto.dart';

part 'armatura.g.dart';

/// Modello/Armatura
///
/// Riga Armatura della sezione Equipaggiamento della scheda: nome, PA
/// (Punti Armatura fisici) e PA Energia (Punti Armatura contro danni
/// energetici), entrambi numerici perché entrano nel calcolo di
/// Scheda.resilienzaFisica/resilienzaEnergetica (e [pa] anche in
/// Scheda.difesaArmatura), e Tratti.
@JsonSerializable()
class Armatura {
  final String nome;
  final int pa;
  final int paEnergia;
  final List<Tratto> tratti;

  /// Tag dell'armatura, presi da Lista/Tag (come per le Armi).
  final List<String> tag;

  /// Quanto costa procurarsela, sulla stessa scala di
  /// Modello/Armi/Arma.valore.
  ///
  /// Le armature salvate prima che esistessero valore e rarità non li
  /// hanno: valgono zero e Comune finché non si riscelgono.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
  final Rarita rarita;

  const Armatura({
    required this.nome,
    required this.pa,
    required this.paEnergia,
    this.tratti = const [],
    this.tag = const [],
    required this.valore,
    required this.rarita,
  });

  factory Armatura.fromJson(Map<String, dynamic> json) =>
      _$ArmaturaFromJson(json);

  Map<String, dynamic> toJson() => _$ArmaturaToJson(this);
}
