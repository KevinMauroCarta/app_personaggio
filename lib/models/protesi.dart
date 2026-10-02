import 'package:json_annotation/json_annotation.dart';

import '../enums/parte_corpo.dart';
import '../enums/rarita.dart';
import '../enums/tipo_protesi.dart';
import 'capacita.dart';
import 'modificatore.dart';

part 'protesi.g.dart';

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
@JsonSerializable()
class Protesi {
  final String nome;
  final TipoProtesi tipo;
  final ParteCorpo parte;
  @JsonKey(defaultValue: '')
  final String descrizione;
  @JsonKey(defaultValue: '')
  final String effetto;

  /// I Modificatori che porta: su Caratteristiche, Abilità o valori della
  /// Scheda (Modello/Modificatore).
  @JsonKey(readValue: leggiModificatori)
  final List<Modificatore> modificatori;

  /// La Capacità da Impianto che la protesi dà finché è montata.
  final Capacita? capacita;

  /// Quanto pesa sul corpo: la somma dei Carichi delle protesi installate
  /// non può superare la Resistenza del personaggio (vedi Modello/Scheda).
  @JsonKey(defaultValue: 1)
  final int carico;

  /// Quanto costa procurarsela, sulla stessa scala di Modello/Armi/Arma.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
  final Rarita rarita;

  const Protesi({
    required this.nome,
    required this.tipo,
    required this.parte,
    required this.descrizione,
    required this.effetto,
    this.modificatori = const [],
    this.capacita,
    required this.carico,
    required this.valore,
    required this.rarita,
  });

  factory Protesi.fromJson(Map<String, dynamic> json) =>
      _$ProtesiFromJson(json);

  Map<String, dynamic> toJson() => _$ProtesiToJson(this);
}
