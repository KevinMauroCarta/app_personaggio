/// Che genere di danno fa un'arma (Modello/Armi/Arma.tipoDanno).
///
/// - [fisico]: proiettili, lame, impatti. È il danno che si ferma con la
///   corazza vera e propria.
/// - [energetico]: laser, plasma, fuoco, energia in qualunque forma.
///
/// La distinzione non è solo descrittiva: l'Armatura ha due valori
/// separati, PA e PA Energia (Modello/Armatura), e la Scheda calcola di
/// conseguenza Resilienza Fisica e Resilienza Energetica.
///
/// NOTA: quale dei due valori si applichi a quale danno è la regola
/// naturale, ma non essendoci ancora un Regolamento/Combattimento il
/// collegamento non è implementato: per ora [tipoDanno] è un dato
/// dell'arma che la scheda mostra.
enum TipoDanno { fisico, energetico }

extension TipoDannoLabel on TipoDanno {
  String get label {
    switch (this) {
      case TipoDanno.fisico:
        return 'Fisico';
      case TipoDanno.energetico:
        return 'Energetico';
    }
  }

  /// Come va detto quando accompagna un nome femminile: si scrive
  /// "Resilienza Fisica", non "Resilienza Fisico".
  String get labelFemminile {
    switch (this) {
      case TipoDanno.fisico:
        return 'Fisica';
      case TipoDanno.energetico:
        return 'Energetica';
    }
  }
}
