import 'pianeta.dart';
import 'capacita.dart';

/// Modello/Sistema
///
/// Nota: il campo "Mappa" (immagine) è rappresentato come percorso opzionale
/// a un asset ([mappaAssetPath]), da valorizzare quando le mappe saranno
/// disponibili.
class Sistema {
  final String nome;
  final String governo;
  final List<Pianeta> pianeti;
  final List<Capacita> capacitaDelSistema;
  final String? mappaAssetPath;
  final String tag;

  const Sistema({
    required this.nome,
    required this.governo,
    this.pianeti = const [],
    this.capacitaDelSistema = const [],
    this.mappaAssetPath,
    required this.tag,
  });

  factory Sistema.fromJson(Map<String, dynamic> json) {
    return Sistema(
      nome: json['nome'] as String,
      governo: json['governo'] as String,
      pianeti: (json['pianeti'] as List<dynamic>? ?? [])
          .map((e) => Pianeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      capacitaDelSistema: (json['capacitaDelSistema'] as List<dynamic>? ?? [])
          .map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList(),
      mappaAssetPath: json['mappaAssetPath'] as String?,
      tag: json['tag'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'governo': governo,
    'pianeti': pianeti.map((p) => p.toJson()).toList(),
    'capacitaDelSistema': capacitaDelSistema.map((c) => c.toJson()).toList(),
    'mappaAssetPath': mappaAssetPath,
    'tag': tag,
  };
}
