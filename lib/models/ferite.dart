import '../enums/grado_ferita.dart';

/// Modello/Ferite
///
/// Ferite Base e Ferite Massime dipendono dal Valore Totale di Resistenza
/// del personaggio: non è memorizzato qui, va passato a [base]/[massime]
/// (stesso pattern di AbilitaPersonaggio.valoreTotale).
class Ferite {
  final int attuali;
  final int bonus;
  final GradoFerita gradoFerita;

  const Ferite({
    this.attuali = 0,
    this.bonus = 0,
    this.gradoFerita = GradoFerita.zero,
  });

  int base(int valoreResistenza) => valoreResistenza;

  int massime(int valoreResistenza) => base(valoreResistenza) + bonus;

  factory Ferite.fromJson(Map<String, dynamic> json) {
    return Ferite(
      attuali: json['attuali'] as int? ?? 0,
      bonus: json['bonus'] as int? ?? 0,
      gradoFerita: GradoFerita.values.byName(
        json['gradoFerita'] as String? ?? 'zero',
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'attuali': attuali,
    'bonus': bonus,
    'gradoFerita': gradoFerita.name,
  };
}
