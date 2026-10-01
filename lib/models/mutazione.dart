import 'package:json_annotation/json_annotation.dart';

import 'modificatore.dart';

part 'mutazione.g.dart';

/// Modello/Mutazione
@JsonSerializable()
class Mutazione {
  final String nome;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;

  const Mutazione({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    this.modificatoreCaratteristica,
  });

  factory Mutazione.fromJson(Map<String, dynamic> json) =>
      _$MutazioneFromJson(json);

  Map<String, dynamic> toJson() => _$MutazioneToJson(this);
}
