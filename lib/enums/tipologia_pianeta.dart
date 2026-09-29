/// Tipologia di un Pianeta (vedi Modello/Pianeta).
enum TipologiaPianeta { roccioso, gassoso, acquatico }

extension TipologiaPianetaLabel on TipologiaPianeta {
  String get label {
    switch (this) {
      case TipologiaPianeta.roccioso:
        return 'Roccioso';
      case TipologiaPianeta.gassoso:
        return 'Gassoso';
      case TipologiaPianeta.acquatico:
        return 'Acquatico';
    }
  }
}
