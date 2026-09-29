/// Modello/Lesione_Memorabile
class LesioneMemorabile {
  final String nome;
  final String descrizione;
  final String effetto;

  const LesioneMemorabile({
    required this.nome,
    required this.descrizione,
    required this.effetto,
  });

  factory LesioneMemorabile.fromJson(Map<String, dynamic> json) {
    return LesioneMemorabile(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'effetto': effetto,
  };
}
