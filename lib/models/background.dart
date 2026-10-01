import 'package:json_annotation/json_annotation.dart';

import 'capacita.dart';
import 'modificatore.dart';

part 'background.g.dart';

/// Modello/Background
@JsonSerializable()
class Background {
  final String nome;
  final String descrizione;

  /// La Capacità di Background legata a questo background: ogni
  /// background ne ha una e una sola.
  final Capacita capacitaDiBackground;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;
  final String tag;

  const Background({
    required this.nome,
    required this.descrizione,
    required this.capacitaDiBackground,
    this.modificatoreCaratteristica,
    this.modificatoreAbilita,
    required this.tag,
  });

  factory Background.fromJson(Map<String, dynamic> json) =>
      _$BackgroundFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundToJson(this);
}
