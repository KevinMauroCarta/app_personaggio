import 'package:json_annotation/json_annotation.dart';

import '../enums/taglia.dart';
import 'capacita.dart';

part 'razza.g.dart';

/// Modello/Razza
///
/// [taglia] alimenta Scheda.taglia (Obiettivo/Taglia della scheda).
@JsonSerializable()
class Razza {
  final String nome;
  final String descrizione;

  /// Capacità di Razza fra cui il personaggio ne sceglie due, diverse, in
  /// Creazione: sono le uniche opzioni offerte dai dropdown "Capacità di
  /// Razza 1" e "2" (APP/Pagina/Creazione-PG/Pagina_2).
  final List<Capacita> capacita;

  final String tag;

  /// Le razze salvate prima che esistesse la taglia sono Medie.
  @JsonKey(defaultValue: Taglia.media)
  final Taglia taglia;

  const Razza({
    required this.nome,
    required this.descrizione,
    required this.capacita,
    required this.tag,
    required this.taglia,
  });

  factory Razza.fromJson(Map<String, dynamic> json) => _$RazzaFromJson(json);

  Map<String, dynamic> toJson() => _$RazzaToJson(this);
}
