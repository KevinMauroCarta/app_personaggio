import 'package:json_annotation/json_annotation.dart';

part 'modificatore.g.dart';

/// Rappresenta un modificatore a una Caratteristica o un'Abilità, espresso
/// come coppia nome + valore (es. `<Caratteristica.Nome, intero>` in
/// Modello/Capacità, Modello/Background, Modello/Mutazione).
@JsonSerializable()
class Modificatore {
  final String nome;
  final int valore;

  const Modificatore({required this.nome, required this.valore});

  factory Modificatore.fromJson(Map<String, dynamic> json) =>
      _$ModificatoreFromJson(json);

  Map<String, dynamic> toJson() => _$ModificatoreToJson(this);
}
