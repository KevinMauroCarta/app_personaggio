/// Grandezza di un Pianeta (vedi Modello/Pianeta).
enum GrandezzaPianeta { nano, piccolo, medio, grande, gigante }

extension GrandezzaPianetaLabel on GrandezzaPianeta {
  String get label {
    switch (this) {
      case GrandezzaPianeta.nano:
        return 'Nano';
      case GrandezzaPianeta.piccolo:
        return 'Piccolo';
      case GrandezzaPianeta.medio:
        return 'Medio';
      case GrandezzaPianeta.grande:
        return 'Grande';
      case GrandezzaPianeta.gigante:
        return 'Gigante';
    }
  }
}
