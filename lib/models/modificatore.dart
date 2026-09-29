/// Rappresenta un modificatore a una Caratteristica o un'Abilità, espresso
/// come coppia nome + valore (es. `<Caratteristica.Nome, intero>` in
/// Modello/Capacità, Modello/Background, Modello/Mutazione).
class Modificatore {
  final String nome;
  final int valore;

  const Modificatore({required this.nome, required this.valore});

  factory Modificatore.fromJson(Map<String, dynamic> json) {
    return Modificatore(
      nome: json['nome'] as String,
      valore: json['valore'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'nome': nome, 'valore': valore};
}
