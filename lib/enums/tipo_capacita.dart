/// Tipologia di una Capacità (vedi Modello/Capacità).
///
/// Le Capacità da [impianto] non si scelgono né si comprano: le concede
/// un Impianto (Modello/ChipNeurale, Modello/Protesi) finché è
/// installato, e con lui se ne vanno.
enum TipoCapacita { generica, razza, sistema, background, impianto }

extension TipoCapacitaLabel on TipoCapacita {
  String get label {
    switch (this) {
      case TipoCapacita.generica:
        return 'Generica';
      case TipoCapacita.razza:
        return 'Razza';
      case TipoCapacita.sistema:
        return 'Sistema';
      case TipoCapacita.background:
        return 'Background';
      case TipoCapacita.impianto:
        return 'Impianto';
    }
  }
}
