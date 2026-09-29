import '../enums/grandezza_pianeta.dart';
import '../enums/tipologia_pianeta.dart';
import '../enums/densita_popolativa.dart';
import 'capacita.dart';

/// Modello/Pianeta
class Pianeta {
  final String nome;
  final GrandezzaPianeta grandezza;
  final TipologiaPianeta tipologia;
  final bool luna;
  final List<Pianeta> lune;
  final String capitale;
  final DensitaPopolativa densitaPopolativa;
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

  factory Pianeta.fromJson(Map<String, dynamic> json) {
    return Pianeta(
      nome: json['nome'] as String,
      grandezza: GrandezzaPianeta.values.byName(json['grandezza'] as String),
      tipologia: TipologiaPianeta.values.byName(json['tipologia'] as String),
      luna: json['luna'] as bool? ?? false,
      lune: (json['lune'] as List<dynamic>? ?? [])
          .map((e) => Pianeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      capitale: json['capitale'] as String,
      densitaPopolativa: DensitaPopolativa.values.byName(
        json['densitaPopolativa'] as String,
      ),
      capacitaDelPianeta: (json['capacitaDelPianeta'] as List<dynamic>? ?? [])
          .map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: (json['tag'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'grandezza': grandezza.name,
    'tipologia': tipologia.name,
    'luna': luna,
    'lune': lune.map((p) => p.toJson()).toList(),
    'capitale': capitale,
    'densitaPopolativa': densitaPopolativa.name,
    'capacitaDelPianeta': capacitaDelPianeta.map((c) => c.toJson()).toList(),
    'tag': tag,
  };
}
