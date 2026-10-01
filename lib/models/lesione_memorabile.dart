import 'package:json_annotation/json_annotation.dart';

part 'lesione_memorabile.g.dart';

/// Modello/Lesione_Memorabile
@JsonSerializable()
class LesioneMemorabile {
  final String nome;
  final String descrizione;
  final String effetto;

  const LesioneMemorabile({
    required this.nome,
    required this.descrizione,
    required this.effetto,
  });

  factory LesioneMemorabile.fromJson(Map<String, dynamic> json) =>
      _$LesioneMemorabileFromJson(json);

  Map<String, dynamic> toJson() => _$LesioneMemorabileToJson(this);
}
