import 'abilita.dart';

/// Modello/AbilitàPersonaggio
///
/// Valore Totale = Valore Base + Valore Caratteristica + Valore Bonus
/// (vedi Utilizzo/Abilità). Il Valore Caratteristica non è memorizzato qui:
/// va recuperato dal CaratteristicaPersonaggio associato del personaggio e
/// passato a [valoreTotale].
class AbilitaPersonaggio {
  final Abilita abilita;
  final int valoreBase;
  final int valoreBonus;

  const AbilitaPersonaggio({
    required this.abilita,
    required this.valoreBase,
    this.valoreBonus = 0,
  });

  int valoreTotale(int valoreCaratteristica) =>
      valoreBase + valoreCaratteristica + valoreBonus;

  factory AbilitaPersonaggio.fromJson(Map<String, dynamic> json) {
    return AbilitaPersonaggio(
      abilita: Abilita.fromJson(json['abilita'] as Map<String, dynamic>),
      valoreBase: json['valoreBase'] as int,
      valoreBonus: json['valoreBonus'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'abilita': abilita.toJson(),
    'valoreBase': valoreBase,
    'valoreBonus': valoreBonus,
  };
}
