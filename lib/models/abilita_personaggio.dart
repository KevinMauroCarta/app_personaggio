import 'package:json_annotation/json_annotation.dart';

import 'abilita.dart';

part 'abilita_personaggio.g.dart';

/// Modello/AbilitàPersonaggio
///
/// Valore Totale = Valore Base + Valore Caratteristica + Valore Bonus
/// (vedi Utilizzo/Abilità). Il Valore Caratteristica non è memorizzato qui:
/// va recuperato dal CaratteristicaPersonaggio associato del personaggio e
/// passato a [valoreTotale].
@JsonSerializable()
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

  factory AbilitaPersonaggio.fromJson(Map<String, dynamic> json) =>
      _$AbilitaPersonaggioFromJson(json);

  Map<String, dynamic> toJson() => _$AbilitaPersonaggioToJson(this);
}
