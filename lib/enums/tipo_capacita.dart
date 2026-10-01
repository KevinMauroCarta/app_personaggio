/// Tipologia di una Capacità (vedi Modello/Capacità).
///
/// Le Capacità del [pianeta] sono quelle che un pianeta offre a chi ci
/// nasce: una legata alla sua tipologia (Roccioso, Gassoso, Acquatico) e
/// due che si apprendono su quel pianeta.
///
/// Le Capacità da [impianto] non si scelgono né si comprano: le concede
/// un Impianto (Modello/ChipNeurale, Modello/Protesi) finché è
/// installato, e con lui se ne vanno.
enum TipoCapacita { generica, razza, sistema, pianeta, background, impianto }

extension TipoCapacitaLabel on TipoCapacita {
  String get label {
    switch (this) {
      case TipoCapacita.generica:
        return 'Generica';
      case TipoCapacita.razza:
        return 'Razza';
      case TipoCapacita.sistema:
        return 'Sistema';
      case TipoCapacita.pianeta:
        return 'Pianeta';
      case TipoCapacita.background:
        return 'Background';
      case TipoCapacita.impianto:
        return 'Impianto';
    }
  }
}
