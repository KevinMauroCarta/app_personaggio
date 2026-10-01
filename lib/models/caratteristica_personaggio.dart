import 'package:json_annotation/json_annotation.dart';

import 'caratteristica.dart';

part 'caratteristica_personaggio.g.dart';

/// Modello/CaratteristicaPersonaggio
///
/// Valore Totale = Valore Base + Valore Bonus (vedi Utilizzo/Caratteristiche).
@JsonSerializable()
class CaratteristicaPersonaggio {
  final Caratteristica caratteristica;
  final int valoreBase;
  final int valoreBonus;

  const CaratteristicaPersonaggio({
    required this.caratteristica,
    required this.valoreBase,
    this.valoreBonus = 0,
  });

  int get valoreTotale => valoreBase + valoreBonus;

  factory CaratteristicaPersonaggio.fromJson(Map<String, dynamic> json) =>
      _$CaratteristicaPersonaggioFromJson(json);

  Map<String, dynamic> toJson() => _$CaratteristicaPersonaggioToJson(this);
}
