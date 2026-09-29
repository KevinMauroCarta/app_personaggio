import 'caratteristica.dart';

/// Modello/CaratteristicaPersonaggio
///
/// Valore Totale = Valore Base + Valore Bonus (vedi Utilizzo/Caratteristiche).
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

  factory CaratteristicaPersonaggio.fromJson(Map<String, dynamic> json) {
    return CaratteristicaPersonaggio(
      caratteristica: Caratteristica.fromJson(
        json['caratteristica'] as Map<String, dynamic>,
      ),
      valoreBase: json['valoreBase'] as int,
      valoreBonus: json['valoreBonus'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'caratteristica': caratteristica.toJson(),
    'valoreBase': valoreBase,
    'valoreBonus': valoreBonus,
  };
}
