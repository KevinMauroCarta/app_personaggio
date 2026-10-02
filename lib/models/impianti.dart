import 'package:json_annotation/json_annotation.dart';

import '../enums/tipo_protesi.dart';
import 'capacita.dart';
import 'chip_neurale.dart';
import 'protesi.dart';

part 'impianti.g.dart';

/// Modello/Impianti
///
/// Quello che il personaggio ha installato addosso e dentro: i Chip
/// Neurali e le Protesi. In Scheda ha una pagina sua, "Impianti".
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
@JsonSerializable()
class Impianti {
  final List<ChipNeurale> chipNeurali;
  final List<Protesi> protesi;

  const Impianti({this.chipNeurali = const [], this.protesi = const []});

  /// Il Carico dei chip installati, sommato: non può superare la Volontà
  /// (Scheda.limiteCaricoChip).
  int get caricoChip => chipNeurali.fold(0, (somma, c) => somma + c.carico);

  /// Il Carico delle protesi installate, sommato: non può superare la
  /// Resistenza (Scheda.limiteCaricoProtesi).
  int get caricoProtesi => protesi.fold(0, (somma, p) => somma + p.carico);

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

  factory Impianti.fromJson(Map<String, dynamic> json) =>
      _$ImpiantiFromJson(json);

  Map<String, dynamic> toJson() => _$ImpiantiToJson(this);
}
