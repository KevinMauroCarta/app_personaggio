import '../enums/parte_corpo.dart';
import '../enums/rarita.dart';
import '../enums/tipo_protesi.dart';
import 'capacita.dart';
import 'modificatore.dart';

/// Modello/Protesi
///
/// Una parte artificiale montata sul corpo, su una [parte] precisa. Di
/// due tipi ([TipoProtesi]):
/// - Sostitutivo: rimpiazza un arto o un organo mancante. Riporta il
///   personaggio a funzionare, e di rado lo rende più forte di prima;
/// - Esoscheletro: si monta su una parte che c'è già, per potenziarla,
///   e di solito porta un Modificatore.
///
/// È un modello unico con [tipo] a distinguerli, come Modello/Capacità
/// fa con TipoCapacita: i due tipi hanno esattamente gli stessi campi,
/// e due classi separate li duplicherebbero.
///
/// Come per Modello/ChipNeurale, i Modificatori entrano nel Valore Bonus
/// del personaggio finché la protesi è montata.
class Protesi {
  final String nome;
  final TipoProtesi tipo;
  final ParteCorpo parte;
  final String descrizione;
  final String effetto;
  final Modificatore? modificatoreCaratteristica;
  final Modificatore? modificatoreAbilita;

  /// La Capacità da Impianto che la protesi dà finché è montata.
  final Capacita? capacita;

  /// Quanto costa procurarsela, sulla stessa scala di Modello/Armi/Arma.
  final int valore;

  final Rarita rarita;

  const Protesi({
    required this.nome,
    required this.tipo,
    required this.parte,
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

  factory Protesi.fromJson(Map<String, dynamic> json) {
    return Protesi(
      nome: json['nome'] as String,
      tipo: TipoProtesi.values.byName(json['tipo'] as String),
      parte: ParteCorpo.values.byName(json['parte'] as String),
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
    'tipo': tipo.name,
    'parte': parte.name,
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
