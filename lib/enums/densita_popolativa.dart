/// Densità popolativa di un Pianeta (vedi Modello/Pianeta).
enum DensitaPopolativa { nessuna, poca, media, molta, troppa }

extension DensitaPopolativaLabel on DensitaPopolativa {
  String get label {
    switch (this) {
      case DensitaPopolativa.nessuna:
        return 'Nessuna';
      case DensitaPopolativa.poca:
        return 'Poca';
      case DensitaPopolativa.media:
        return 'Media';
      case DensitaPopolativa.molta:
        return 'Molta';
      case DensitaPopolativa.troppa:
        return 'Troppa';
    }
  }
}
