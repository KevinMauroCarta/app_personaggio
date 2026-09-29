import 'caratteristica.dart';

/// Modello/Abilità
///
/// Se [addestramento] è true, l'abilità corrisponde a quelle marcate con
/// asterisco (*) in Lista/Abilità: non possono essere effettuate a meno
/// che non si abbia almeno un 1 in Valore Base (Regolamento/Abilità*).
class Abilita {
  final String nome;
  final String descrizione;
  final Caratteristica caratteristica;
  final bool addestramento;

  const Abilita({
    required this.nome,
    required this.descrizione,
    required this.caratteristica,
    required this.addestramento,
  });

  factory Abilita.fromJson(Map<String, dynamic> json) {
    return Abilita(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      caratteristica: Caratteristica.fromJson(
        json['caratteristica'] as Map<String, dynamic>,
      ),
      addestramento: json['addestramento'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'caratteristica': caratteristica.toJson(),
    'addestramento': addestramento,
  };
}
