/// I due tipi di Protesi (Modello/Protesi.tipo).
///
/// - Sostitutivo: prende il posto di un arto o di un organo che manca.
/// - Esoscheletro: si monta su una parte del corpo che c'è già, per
///   potenziarla.
enum TipoProtesi { sostitutivo, esoscheletro }

extension TipoProtesiLabel on TipoProtesi {
  String get label {
    switch (this) {
      case TipoProtesi.sostitutivo:
        return 'Sostitutivo';
      case TipoProtesi.esoscheletro:
        return 'Esoscheletro';
    }
  }
}
