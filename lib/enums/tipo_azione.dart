/// Tipo di azione necessaria per attivare qualcosa, es. un Potere
/// Psionico (Modello/Potere_Psionico.attivazione).
enum TipoAzione { completa, standard, movimento, veloce, gratuita }

extension TipoAzioneLabel on TipoAzione {
  String get label {
    switch (this) {
      case TipoAzione.completa:
        return 'Completa';
      case TipoAzione.standard:
        return 'Standard';
      case TipoAzione.movimento:
        return 'Movimento';
      case TipoAzione.veloce:
        return 'Veloce';
      case TipoAzione.gratuita:
        return 'Gratuita';
    }
  }
}
