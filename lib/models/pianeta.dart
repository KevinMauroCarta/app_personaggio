import 'package:json_annotation/json_annotation.dart';

import '../enums/grandezza_pianeta.dart';
import '../enums/tipologia_pianeta.dart';
import '../enums/densita_popolativa.dart';
import 'capacita.dart';

part 'pianeta.g.dart';

/// Modello/Pianeta
@JsonSerializable()
class Pianeta {
  final String nome;
  final GrandezzaPianeta grandezza;
  final TipologiaPianeta tipologia;
  @JsonKey(defaultValue: false)
  final bool luna;
  final List<Pianeta> lune;
  final String capitale;
  final DensitaPopolativa densitaPopolativa;

  /// Le Capacità del Pianeta fra cui sceglie chi ci nasce: la prima è
  /// quella della [tipologia], uguale per tutti i pianeti di quel tipo, le
  /// altre due si apprendono su questo pianeta.
  final List<Capacita> capacitaDelPianeta;
  final List<String> tag;

  const Pianeta({
    required this.nome,
    required this.grandezza,
    required this.tipologia,
    required this.luna,
    this.lune = const [],
    required this.capitale,
    required this.densitaPopolativa,
    this.capacitaDelPianeta = const [],
    required this.tag,
  });

  factory Pianeta.fromJson(Map<String, dynamic> json) =>
      _$PianetaFromJson(json);

  Map<String, dynamic> toJson() => _$PianetaToJson(this);
}
