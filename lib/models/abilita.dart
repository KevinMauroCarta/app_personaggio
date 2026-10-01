import 'package:json_annotation/json_annotation.dart';

import 'caratteristica.dart';

part 'abilita.g.dart';

/// Modello/Abilità
///
/// Se [addestramento] è true, l'abilità corrisponde a quelle marcate con
/// asterisco (*) in Lista/Abilità: non possono essere effettuate a meno
/// che non si abbia almeno un 1 in Valore Base (Regolamento/Abilità*).
@JsonSerializable()
class Abilita {
  final String nome;
  final String descrizione;
  final Caratteristica caratteristica;
  final bool addestramento;

  const Abilita({
    required this.nome,
    required this.descrizione,
    required this.caratteristica,
    required this.addestramento,
  });

  factory Abilita.fromJson(Map<String, dynamic> json) =>
      _$AbilitaFromJson(json);

  Map<String, dynamic> toJson() => _$AbilitaToJson(this);
}
