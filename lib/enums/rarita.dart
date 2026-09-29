/// Quanto è difficile procurarsi un oggetto (Modello/Armi/Arma.rarita).
enum Rarita { comune, nonComune, rara, moltoRara, unica }

extension RaritaLabel on Rarita {
  String get label {
    switch (this) {
      case Rarita.comune:
        return 'Comune';
      case Rarita.nonComune:
        return 'Non Comune';
      case Rarita.rara:
        return 'Rara';
      case Rarita.moltoRara:
        return 'Molto Rara';
      case Rarita.unica:
        return 'Unica';
    }
  }
}
