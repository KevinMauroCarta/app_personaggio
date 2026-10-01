import 'package:json_annotation/json_annotation.dart';

part 'condizione.g.dart';

/// Modello/Condizione
///
/// Uno stato in cui il personaggio si trova e che gli dà un malus o un
/// bonus: "Ferito 2", per esempio.
///
/// Alcune condizioni portano un numero che ne dice l'intensità
/// ([valore]); altre ci sono o non ci sono, e il numero resta null.
///
/// Le Condizioni non si scrivono in scheda: si ricavano da com'è messo
/// il personaggio (Scheda.condizioni). È la stessa scelta fatta per il
/// Valore Bonus dei Modificatori: un dato calcolato non può restare
/// indietro rispetto a ciò che lo genera.
@JsonSerializable()
class Condizione {
  final String nome;
  final int? valore;

  /// Cosa comporta in gioco. Vuota finché il regolamento non la
  /// definisce: la condizione si vede lo stesso, con il solo nome.
  final String effetto;

  const Condizione({required this.nome, this.valore, this.effetto = ''});

  /// Come va scritta in scheda: "Ferito 2", oppure il solo nome se la
  /// condizione non ha un'intensità.
  String get etichetta => valore == null ? nome : '$nome $valore';

  factory Condizione.fromJson(Map<String, dynamic> json) =>
      _$CondizioneFromJson(json);

  Map<String, dynamic> toJson() => _$CondizioneToJson(this);
}
