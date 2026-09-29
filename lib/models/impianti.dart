import '../enums/tipo_protesi.dart';
import 'capacita.dart';
import 'chip_neurale.dart';
import 'protesi.dart';

/// Modello/Impianti
///
/// Quello che il personaggio ha installato addosso e dentro: i Chip
/// Neurali e le Protesi. In Scheda ha una pagina sua (la linguetta
/// "Punk", nome provvisorio).
///
/// Sta a parte dall'Equipaggiamento perché non si indossa né si porta
/// nello zaino: un braccio meccanico non si toglie per cambiarlo con una
/// pistola.
///
/// Chip e protesi si salvano per intero, come le Armi
/// (Modello/Equipaggiamento): la scheda resta leggibile anche se il
/// catalogo cambia.
///
/// Quello che sta qui è installato, e conta: Modificatori e Capacità da
/// Impianto valgono solo per gli impianti di questo elenco. Un impianto
/// posseduto ma non installato sta fra gli Oggetti
/// (Modello/Equipaggiamento.oggetti), come un'arma di scorta nello zaino.
class Impianti {
  final List<ChipNeurale> chipNeurali;
  final List<Protesi> protesi;

  /// Quanti impianti, fra chip e protesi, si possono avere installati
  /// insieme. Valore provvisorio, in attesa del regolamento.
  static const int massimo = 5;

  const Impianti({this.chipNeurali = const [], this.protesi = const []});

  /// Quanti impianti sono installati, chip e protesi insieme.
  int get totale => chipNeurali.length + protesi.length;

  /// True se non c'è posto per un altro impianto.
  bool get pieno => totale >= massimo;

  /// Le Capacità da Impianto concesse dagli impianti installati, una per
  /// impianto che ne dà una. Due impianti con la stessa capacità la danno
  /// una volta sola: una capacità si ha o non si ha.
  List<Capacita> get capacita {
    final concesse = <Capacita>[];
    for (final c in [
      for (final chip in chipNeurali) chip.capacita,
      for (final p in protesi) p.capacita,
    ]) {
      if (c != null && !concesse.any((g) => g.nome == c.nome)) {
        concesse.add(c);
      }
    }
    return concesse;
  }

  /// Le Protesi che rimpiazzano una parte mancante.
  List<Protesi> get sostitutivi =>
      protesi.where((p) => p.tipo == TipoProtesi.sostitutivo).toList();

  /// Le Protesi che potenziano una parte che c'è già.
  List<Protesi> get esoscheletri =>
      protesi.where((p) => p.tipo == TipoProtesi.esoscheletro).toList();

  factory Impianti.fromJson(Map<String, dynamic> json) {
    return Impianti(
      chipNeurali: (json['chipNeurali'] as List<dynamic>? ?? [])
          .map((e) => ChipNeurale.fromJson(e as Map<String, dynamic>))
          .toList(),
      protesi: (json['protesi'] as List<dynamic>? ?? [])
          .map((e) => Protesi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'chipNeurali': chipNeurali.map((c) => c.toJson()).toList(),
    'protesi': protesi.map((p) => p.toJson()).toList(),
  };
}
