import 'modificatore.dart';

/// Modello/Mutazione
class Mutazione {
  final String nome;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;

  const Mutazione({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    this.modificatoreCaratteristica,
  });

  factory Mutazione.fromJson(Map<String, dynamic> json) {
    return Mutazione(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
      modificatoreCaratteristica: json['modificatoreCaratteristica'] == null
          ? null
          : Modificatore.fromJson(
              json['modificatoreCaratteristica'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'effetto': effetto,
    'modificatoreCaratteristica': modificatoreCaratteristica?.toJson(),
  };
}
