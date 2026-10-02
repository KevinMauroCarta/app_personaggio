import 'package:json_annotation/json_annotation.dart';

import '../enums/rarita.dart';
import 'capacita.dart';
import 'modificatore.dart';

part 'chip_neurale.g.dart';

/// Modello/ChipNeurale
///
/// Un chip impiantato nel cervello. Migliora quello che il personaggio
/// sa già fare - con i Modificatori - o gli dà una capacità nuova - con
/// [capacita], una Capacità da Impianto (TipoCapacita.impianto) - o
/// tutte e due le cose.
///
/// I Modificatori (Modello/Modificatore) valgono insieme a quelli di
/// Capacità, Background e Mutazioni (Servizio/EffettiPersonaggio):
/// installato il chip, il valore che toccano sale; disinstallato, scende.
/// Lo stesso per la Capacità concessa.
@JsonSerializable()
class ChipNeurale {
  final String nome;
  @JsonKey(defaultValue: '')
  final String descrizione;
  @JsonKey(defaultValue: '')
  final String effetto;

  /// I Modificatori che porta: su Caratteristiche, Abilità o valori della
  /// Scheda (Modello/Modificatore).
  @JsonKey(readValue: leggiModificatori)
  final List<Modificatore> modificatori;

  /// La Capacità da Impianto che il chip dà finché è installato.
  final Capacita? capacita;

  /// Quanto pesa sulla mente: la somma dei Carichi dei chip installati non
  /// può superare la Volontà del personaggio (vedi Modello/Scheda).
  @JsonKey(defaultValue: 1)
  final int carico;

  /// Quanto costa procurarselo, sulla stessa scala di Modello/Armi/Arma.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
  final Rarita rarita;

  const ChipNeurale({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    this.modificatori = const [],
    this.capacita,
    required this.carico,
    required this.valore,
    required this.rarita,
  });

  factory ChipNeurale.fromJson(Map<String, dynamic> json) =>
      _$ChipNeuraleFromJson(json);

  Map<String, dynamic> toJson() => _$ChipNeuraleToJson(this);
}
