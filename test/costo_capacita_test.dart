// Prendere una Capacità scala i suoi PE, toglierla li restituisce, e
// sostituirne una con un'altra fa entrambe le cose (APP/Pagina/Creazione-PG,
// Modifica-PG e Aumento-PG usano la stessa regola).
//
// Il test lavora sulle due funzioni pubbliche che le pagine usano per
// calcolare il costo, così la regola resta verificata indipendentemente
// dalla UI.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show costoCapacita, pxSpesiCapacitaGeneriche;

void main() {
  final generica = listaCapacita.firstWhere(
    (c) => c.tipo == TipoCapacita.generica,
  );
  final altraGenerica = listaCapacita.firstWhere(
    (c) => c.tipo == TipoCapacita.generica && c.nome != generica.nome,
  );
  final diRazza = listaCapacita.firstWhere((c) => c.tipo == TipoCapacita.razza);

  test('il costo di una capacità è quello del modello', () {
    expect(costoCapacita(generica.nome), generica.costo);
    expect(costoCapacita(generica.nome), greaterThan(0));
  });

  test('una capacità di razza non costa nulla', () {
    expect(costoCapacita(diRazza.nome), 0);
  });

  test('una capacità sconosciuta non costa nulla invece di far crashare', () {
    expect(costoCapacita('Capacità che non esiste'), 0);
  });

  test('prendere e togliere una capacità lascia i PE come erano', () {
    var pe = 100;
    pe -= costoCapacita(generica.nome);
    expect(pe, 100 - generica.costo);

    pe += costoCapacita(generica.nome);
    expect(pe, 100);
  });

  test('sostituire una capacità con un altra paga solo la differenza', () {
    var pe = 100;
    pe -= costoCapacita(generica.nome);

    // Il cambio di selezione rimborsa la vecchia e addebita la nuova.
    pe += costoCapacita(generica.nome);
    pe -= costoCapacita(altraGenerica.nome);

    expect(pe, 100 - altraGenerica.costo);
  });

  test('il totale speso in capacità è la somma dei costi', () {
    final scelte = [generica.nome, altraGenerica.nome, diRazza.nome];
    expect(
      pxSpesiCapacitaGeneriche(scelte),
      generica.costo + altraGenerica.costo,
    );
  });
}
