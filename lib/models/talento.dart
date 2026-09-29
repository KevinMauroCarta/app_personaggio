/// Modello/Talento
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

  factory Talento.fromJson(Map<String, dynamic> json) {
    return Talento(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
      tag: json['tag'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'effetto': effetto,
    'tag': tag,
  };
}
