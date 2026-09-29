/// Modello/Lesione_Traumatica
class LesioneTraumatica {
  final String nome;
  final String descrizione;
  final String effetto;

  const LesioneTraumatica({
    required this.nome,
    required this.descrizione,
    required this.effetto,
  });

  factory LesioneTraumatica.fromJson(Map<String, dynamic> json) {
    return LesioneTraumatica(
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
