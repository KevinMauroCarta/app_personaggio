import 'package:json_annotation/json_annotation.dart';

import '../enums/grado_ferita.dart';

part 'ferite.g.dart';

/// Modello/Ferite
///
/// Ferite Base dipende dal Valore Totale di Resistenza del personaggio:
/// non è memorizzato qui, va passato a [base] (stesso pattern di
/// AbilitaPersonaggio.valoreTotale). Le Ferite Massime le calcola
/// Modello/Scheda, che conosce anche Modificatori e bonus a mano.
@JsonSerializable()
class Ferite {
  final int attuali;
  final GradoFerita gradoFerita;

  const Ferite({this.attuali = 0, this.gradoFerita = GradoFerita.zero});

  int base(int valoreResistenza) => valoreResistenza;

  factory Ferite.fromJson(Map<String, dynamic> json) => _$FeriteFromJson(json);

  Map<String, dynamic> toJson() => _$FeriteToJson(this);
}
