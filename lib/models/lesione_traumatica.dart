import 'package:json_annotation/json_annotation.dart';

part 'lesione_traumatica.g.dart';

/// Modello/Lesione_Traumatica
@JsonSerializable()
class LesioneTraumatica {
  final String nome;
  final String descrizione;
  final String effetto;

  const LesioneTraumatica({
    required this.nome,
    required this.descrizione,
    required this.effetto,
  });

  factory LesioneTraumatica.fromJson(Map<String, dynamic> json) =>
      _$LesioneTraumaticaFromJson(json);

  Map<String, dynamic> toJson() => _$LesioneTraumaticaToJson(this);
}
