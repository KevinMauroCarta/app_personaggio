/// Tipologia di una Capacità (vedi Modello/Capacità).
enum TipoCapacita { generica, razza, sistema, background }

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
    }
  }
}
