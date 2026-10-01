import 'package:json_annotation/json_annotation.dart';

part 'caratteristica.g.dart';

/// Modello/Caratteristica
@JsonSerializable()
class Caratteristica {
  final String nome;
  final String descrizione;

  const Caratteristica({required this.nome, required this.descrizione});

  factory Caratteristica.fromJson(Map<String, dynamic> json) =>
      _$CaratteristicaFromJson(json);

  Map<String, dynamic> toJson() => _$CaratteristicaToJson(this);
}
