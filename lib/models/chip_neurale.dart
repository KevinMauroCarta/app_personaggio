import '../enums/rarita.dart';
import 'capacita.dart';
import 'modificatore.dart';

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
class ChipNeurale {
  final String nome;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;

  /// La Capacità da Impianto che il chip dà finché è installato.
  final Capacita? capacita;

  /// Quanto costa procurarselo, sulla stessa scala di Modello/Armi/Arma.
  final int valore;

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

  factory ChipNeurale.fromJson(Map<String, dynamic> json) {
    return ChipNeurale(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String? ?? '',
      effetto: json['effetto'] as String? ?? '',
      modificatoreCaratteristica: _modificatore(
        json['modificatoreCaratteristica'],
      ),
      modificatoreAbilita: _modificatore(json['modificatoreAbilita']),
      capacita: json['capacita'] == null
          ? null
          : Capacita.fromJson(json['capacita'] as Map<String, dynamic>),
      valore: json['valore'] as int? ?? 0,
      rarita: json['rarita'] == null
          ? Rarita.comune
          : Rarita.values.byName(json['rarita'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'effetto': effetto,
    'modificatoreCaratteristica': modificatoreCaratteristica?.toJson(),
    'modificatoreAbilita': modificatoreAbilita?.toJson(),
    'capacita': capacita?.toJson(),
    'valore': valore,
    'rarita': rarita.name,
  };
}

Modificatore? _modificatore(Object? json) =>
    json == null ? null : Modificatore.fromJson(json as Map<String, dynamic>);
