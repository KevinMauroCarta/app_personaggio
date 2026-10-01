import 'package:json_annotation/json_annotation.dart';

part 'potenziamento.g.dart';

/// Modello/Potenziamento
@JsonSerializable()
class Potenziamento {
  final String nome;
  final int costo;
  final bool replicabile;
  final String effetto;

  const Potenziamento({
    required this.nome,
    required this.costo,
    required this.replicabile,
    required this.effetto,
  });

  factory Potenziamento.fromJson(Map<String, dynamic> json) =>
      _$PotenziamentoFromJson(json);

  Map<String, dynamic> toJson() => _$PotenziamentoToJson(this);
}
