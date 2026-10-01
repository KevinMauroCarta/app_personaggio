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
/// I Modificatori hanno la stessa forma di quelli di Modello/Capacità
/// (nome di una Caratteristica o di un'Abilità + valore), ed entrano nel
/// Valore Bonus del personaggio insieme a quelli di Capacità, Background
/// e Mutazioni (Servizio/EffettiPersonaggio): installato il chip, la
/// Caratteristica o l'Abilità sale; disinstallato, scende. Lo stesso per
/// la Capacità concessa.
@JsonSerializable()
class ChipNeurale {
  final String nome;
  @JsonKey(defaultValue: '')
  final String descrizione;
  @JsonKey(defaultValue: '')
  final String effetto;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;

  /// La Capacità da Impianto che il chip dà finché è installato.
  final Capacita? capacita;

  /// Quanto costa procurarselo, sulla stessa scala di Modello/Armi/Arma.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
  final Rarita rarita;

  const ChipNeurale({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    this.modificatoreCaratteristica,
    this.modificatoreAbilita,
    this.capacita,
    required this.valore,
    required this.rarita,
  });

  /// I Modificatori presenti, senza i null.
  List<Modificatore> get modificatori => [
    ?modificatoreCaratteristica,
    ?modificatoreAbilita,
  ];

  factory ChipNeurale.fromJson(Map<String, dynamic> json) =>
      _$ChipNeuraleFromJson(json);

  Map<String, dynamic> toJson() => _$ChipNeuraleToJson(this);
}
