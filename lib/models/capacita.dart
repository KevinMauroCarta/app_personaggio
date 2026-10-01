import 'package:json_annotation/json_annotation.dart';

import '../enums/tipo_capacita.dart';
import 'modificatore.dart';

part 'capacita.g.dart';

/// Modello/Capacità
@JsonSerializable()
class Capacita {
  final String nome;
  final TipoCapacita tipo;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;
  final int costo;
  final List<String> tag;

  const Capacita({
    required this.nome,
    required this.tipo,
    required this.descrizione,
    required this.effetto,
    this.modificatoreCaratteristica,
    this.modificatoreAbilita,
    required this.costo,
    required this.tag,
  });

  factory Capacita.fromJson(Map<String, dynamic> json) =>
      _$CapacitaFromJson(json);

  Map<String, dynamic> toJson() => _$CapacitaToJson(this);
}
