/// Dove può essere applicato un Tratto (Modello/Tratto.ambiti).
///
/// Un tratto può valere solo per le armi, solo per le armature oppure
/// per entrambe: in quest'ultimo caso resta comunque un tratto solo, con
/// un unico testo, invece di essere scritto due volte.
enum AmbitoTratto { arma, armatura }

extension AmbitoTrattoLabel on AmbitoTratto {
  String get label {
    switch (this) {
      case AmbitoTratto.arma:
        return 'Arma';
      case AmbitoTratto.armatura:
        return 'Armatura';
    }
  }
}
