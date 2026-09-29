/// Modello/Potenziamento
class Potenziamento {
  final String nome;
  final int costo;
  final bool replicabile;
  final String effetto;

  const Potenziamento({
    required this.nome,
    required this.costo,
    required this.replicabile,
    required this.effetto,
  });

  factory Potenziamento.fromJson(Map<String, dynamic> json) {
    return Potenziamento(
      nome: json['nome'] as String,
      costo: json['costo'] as int,
      replicabile: json['replicabile'] as bool,
      effetto: json['effetto'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'costo': costo,
    'replicabile': replicabile,
    'effetto': effetto,
  };
}
