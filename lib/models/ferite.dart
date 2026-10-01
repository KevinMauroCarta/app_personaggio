import 'package:json_annotation/json_annotation.dart';

import '../enums/grado_ferita.dart';

part 'ferite.g.dart';

/// Modello/Ferite
///
/// Ferite Base e Ferite Massime dipendono dal Valore Totale di Resistenza
/// del personaggio: non è memorizzato qui, va passato a [base]/[massime]
/// (stesso pattern di AbilitaPersonaggio.valoreTotale).
@JsonSerializable()
class Ferite {
  final int attuali;
  final int bonus;
  final GradoFerita gradoFerita;

  const Ferite({
    this.attuali = 0,
    this.bonus = 0,
    this.gradoFerita = GradoFerita.zero,
  });

  int base(int valoreResistenza) => valoreResistenza;

  int massime(int valoreResistenza) => base(valoreResistenza) + bonus;

  factory Ferite.fromJson(Map<String, dynamic> json) => _$FeriteFromJson(json);

  Map<String, dynamic> toJson() => _$FeriteToJson(this);
}
