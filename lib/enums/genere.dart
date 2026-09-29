/// Genere del personaggio (vedi APP/Pagina/Creazione-PG/Pagina_1).
enum Genere { maschio, femmina, nonDefinito }

extension GenereLabel on Genere {
  String get label {
    switch (this) {
      case Genere.maschio:
        return 'Maschio';
      case Genere.femmina:
        return 'Femmina';
      case Genere.nonDefinito:
        return 'Non Definito';
    }
  }
}
