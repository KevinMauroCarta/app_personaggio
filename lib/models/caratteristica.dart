/// Modello/Caratteristica
class Caratteristica {
  final String nome;
  final String descrizione;

  const Caratteristica({required this.nome, required this.descrizione});

  factory Caratteristica.fromJson(Map<String, dynamic> json) {
    return Caratteristica(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'nome': nome, 'descrizione': descrizione};
}
