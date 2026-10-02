import 'package:json_annotation/json_annotation.dart';

import 'modificatore.dart';

part 'mutazione.g.dart';

/// Modello/Mutazione
@JsonSerializable()
class Mutazione {
  final String nome;
  final String descrizione;
  final String effetto;

  /// I Modificatori che porta (Modello/Modificatore).
  @JsonKey(readValue: leggiModificatori)
  final List<Modificatore> modificatori;

  const Mutazione({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    this.modificatori = const [],
  });

  factory Mutazione.fromJson(Map<String, dynamic> json) =>
      _$MutazioneFromJson(json);

  Map<String, dynamic> toJson() => _$MutazioneToJson(this);
}
