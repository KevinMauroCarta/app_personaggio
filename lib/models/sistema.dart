import 'package:json_annotation/json_annotation.dart';

import 'pianeta.dart';
import 'capacita.dart';

part 'sistema.g.dart';

/// Modello/Sistema
///
/// Nota: il campo "Mappa" (immagine) è rappresentato come percorso opzionale
/// a un asset ([mappaAssetPath]), da valorizzare quando le mappe saranno
/// disponibili.
@JsonSerializable()
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

  factory Sistema.fromJson(Map<String, dynamic> json) =>
      _$SistemaFromJson(json);

  Map<String, dynamic> toJson() => _$SistemaToJson(this);
}
