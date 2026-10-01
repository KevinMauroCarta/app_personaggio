import 'package:json_annotation/json_annotation.dart';

part 'durata.g.dart';

/// Unità di misura di una [Durata].
enum UnitaDurata { round, minuti, ore }

/// Modello/Durata
///
/// Quanto dura un effetto, es. un Potere Psionico. Sono due casi soli:
/// - **istantanea**: l'effetto si esaurisce subito e in scheda si scrive
///   "-" ([Durata.istantanea]);
/// - **a tempo**: una quantità più un'unità, es. "3 round", "2 minuti",
///   "1 ora" ([Durata.per]).
///
/// È un modello a sé e non una stringa libera perché la quantità serve
/// come numero (per contare i round che passano), e non solo da leggere.
@JsonSerializable(constructor: '_')
class Durata {
  /// null quando la durata è istantanea.
  final int? quantita;
  final UnitaDurata? unita;

  const Durata._({this.quantita, this.unita});

  const Durata.istantanea() : quantita = null, unita = null;

  const Durata.per(this.quantita, this.unita);

  bool get istantanea => unita == null;

  /// Come la durata compare in scheda: "-" se istantanea, altrimenti
  /// quantità e unità concordate al singolare o al plurale.
  String get etichetta {
    if (istantanea) return '-';
    return '$quantita ${_unitaAlPlurale(unita!, quantita!)}';
  }

  static String _unitaAlPlurale(UnitaDurata unita, int quantita) {
    final singolare = quantita == 1;
    switch (unita) {
      case UnitaDurata.round:
        // "round" è invariabile anche al plurale.
        return 'round';
      case UnitaDurata.minuti:
        return singolare ? 'minuto' : 'minuti';
      case UnitaDurata.ore:
        return singolare ? 'ora' : 'ore';
    }
  }

  /// Senza unità la durata è istantanea, qualunque quantità ci sia.
  factory Durata.fromJson(Map<String, dynamic> json) => json['unita'] == null
      ? const Durata.istantanea()
      : _$DurataFromJson(json);

  Map<String, dynamic> toJson() => _$DurataToJson(this);
}
