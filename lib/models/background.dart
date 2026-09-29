import 'capacita.dart';
import 'modificatore.dart';

/// Modello/Background
class Background {
  final String nome;
  final String descrizione;

  /// La Capacità di Background legata a questo background: ogni
  /// background ne ha una e una sola.
  final Capacita capacitaDiBackground;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;
  final String tag;

  const Background({
    required this.nome,
    required this.descrizione,
    required this.capacitaDiBackground,
    this.modificatoreCaratteristica,
    this.modificatoreAbilita,
    required this.tag,
  });

  factory Background.fromJson(Map<String, dynamic> json) {
    return Background(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      capacitaDiBackground: Capacita.fromJson(
        json['capacitaDiBackground'] as Map<String, dynamic>,
      ),
      modificatoreCaratteristica: json['modificatoreCaratteristica'] == null
          ? null
          : Modificatore.fromJson(
              json['modificatoreCaratteristica'] as Map<String, dynamic>,
            ),
      modificatoreAbilita: json['modificatoreAbilita'] == null
          ? null
          : Modificatore.fromJson(
              json['modificatoreAbilita'] as Map<String, dynamic>,
            ),
      tag: json['tag'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'capacitaDiBackground': capacitaDiBackground.toJson(),
    'modificatoreCaratteristica': modificatoreCaratteristica?.toJson(),
    'modificatoreAbilita': modificatoreAbilita?.toJson(),
    'tag': tag,
  };
}
