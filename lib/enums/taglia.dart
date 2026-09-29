/// Taglia di una Razza (Modello/Razza.taglia), riportata in scheda come
/// Scheda.taglia.
enum Taglia { piccola, media }

extension TagliaLabel on Taglia {
  String get label {
    switch (this) {
      case Taglia.piccola:
        return 'Piccola';
      case Taglia.media:
        return 'Media';
    }
  }
}
