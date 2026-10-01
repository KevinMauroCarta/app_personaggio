import 'package:json_annotation/json_annotation.dart';

part 'talento.g.dart';

/// Modello/Talento
@JsonSerializable()
class Talento {
  final String nome;
  final String descrizione;
  final String effetto;
  final String tag;

  const Talento({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    required this.tag,
  });

  factory Talento.fromJson(Map<String, dynamic> json) =>
      _$TalentoFromJson(json);

  Map<String, dynamic> toJson() => _$TalentoToJson(this);
}
