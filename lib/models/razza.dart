import '../enums/taglia.dart';
import 'capacita.dart';

/// Modello/Razza
///
/// [taglia] alimenta Scheda.taglia (Obiettivo/Taglia della scheda).
class Razza {
  final String nome;
  final String descrizione;

  /// Capacità di Razza fra cui il personaggio ne sceglie una in
  /// Creazione: sono le uniche opzioni offerte dal dropdown "Capacità di
  /// Razza" (APP/Pagina/Creazione-PG/Pagina_2).
  final List<Capacita> capacita;

  final String tag;
  final Taglia taglia;

  const Razza({
    required this.nome,
    required this.descrizione,
    required this.capacita,
    required this.tag,
    required this.taglia,
  });

  factory Razza.fromJson(Map<String, dynamic> json) {
    return Razza(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      capacita: (json['capacita'] as List<dynamic>? ?? [])
          .map((e) => Capacita.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: json['tag'] as String,
      taglia: json['taglia'] is String
          ? Taglia.values.byName(json['taglia'] as String)
          : Taglia.media,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'capacita': capacita.map((c) => c.toJson()).toList(),
    'tag': tag,
    'taglia': taglia.name,
  };
}
