/// La parte del corpo su cui va una Protesi (Modello/Protesi.parte): la
/// parte che un Sostitutivo rimpiazza, o quella che un Esoscheletro
/// potenzia. [corpo] è per gli esoscheletri che vestono tutto il corpo.
enum ParteCorpo {
  occhio,
  orecchio,
  braccio,
  mano,
  gamba,
  cuore,
  polmoni,
  colonnaVertebrale,
  corpo,
}

extension ParteCorpoLabel on ParteCorpo {
  String get label {
    switch (this) {
      case ParteCorpo.occhio:
        return 'Occhio';
      case ParteCorpo.orecchio:
        return 'Orecchio';
      case ParteCorpo.braccio:
        return 'Braccio';
      case ParteCorpo.mano:
        return 'Mano';
      case ParteCorpo.gamba:
        return 'Gamba';
      case ParteCorpo.cuore:
        return 'Cuore';
      case ParteCorpo.polmoni:
        return 'Polmoni';
      case ParteCorpo.colonnaVertebrale:
        return 'Colonna Vertebrale';
      case ParteCorpo.corpo:
        return 'Corpo Intero';
    }
  }
}
