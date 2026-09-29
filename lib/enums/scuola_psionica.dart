/// Scuola di un Potere Psionico (Modello/Potere_Psionico.scuola).
enum ScuolaPsionica {
  telepatia,
  divinazione,
  distruzione,
  dominazione,
  illusione,
}

extension ScuolaPsionicaLabel on ScuolaPsionica {
  String get label {
    switch (this) {
      case ScuolaPsionica.telepatia:
        return 'Telepatia';
      case ScuolaPsionica.divinazione:
        return 'Divinazione';
      case ScuolaPsionica.distruzione:
        return 'Distruzione';
      case ScuolaPsionica.dominazione:
        return 'Dominazione';
      case ScuolaPsionica.illusione:
        return 'Illusione';
    }
  }
}
