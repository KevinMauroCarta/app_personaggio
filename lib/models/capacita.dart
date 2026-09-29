import '../enums/tipo_capacita.dart';
import 'modificatore.dart';

/// Modello/Capacità
class Capacita {
  final String nome;
  final TipoCapacita tipo;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;
  final int costo;
  final List<String> tag;

  const Capacita({
    required this.nome,
    required this.tipo,
    required this.descrizione,
    required this.effetto,
    this.modificatoreCaratteristica,
    this.modificatoreAbilita,
    required this.costo,
    required this.tag,
  });

  factory Capacita.fromJson(Map<String, dynamic> json) {
    return Capacita(
      nome: json['nome'] as String,
      tipo: TipoCapacita.values.byName(json['tipo'] as String),
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
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
      costo: json['costo'] as int,
      tag: (json['tag'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'tipo': tipo.name,
    'descrizione': descrizione,
    'effetto': effetto,
    'modificatoreCaratteristica': modificatoreCaratteristica?.toJson(),
    'modificatoreAbilita': modificatoreAbilita?.toJson(),
    'costo': costo,
    'tag': tag,
  };
}
