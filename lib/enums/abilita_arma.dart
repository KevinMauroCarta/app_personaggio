/// Abilità con cui si usa un'arma (Modello/Arma.abilitaAssociata).
///
/// Sono le sole tre Abilità di Lista/Abilità che possono valere come
/// abilità d'attacco: da questa scelta dipende la Riserva di Dadi, che
/// non è memorizzata sull'arma ma è il Valore Totale che il personaggio
/// ha in questa abilità (vedi Scheda.riservaDiDadi).
enum AbilitaArma { mira, mischiaLeggera, mischiaPesante }

extension AbilitaArmaNome on AbilitaArma {
  /// Il nome esatto dell'Abilità in Lista/Abilità, usato per ritrovarla
  /// tra le Abilità del personaggio.
  String get nomeAbilita {
    switch (this) {
      case AbilitaArma.mira:
        return 'Mira';
      case AbilitaArma.mischiaLeggera:
        return 'Mischia Leggera';
      case AbilitaArma.mischiaPesante:
        return 'Mischia Pesante';
    }
  }
}
