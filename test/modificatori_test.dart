// Tutto ciò che porta un Modificatore deve finire nel Valore Bonus della
// Caratteristica o dell'Abilità indicata: le Capacità, il Background e le
// Mutazioni. Il Valore Bonus è sempre ricalcolato da zero dall'elenco
// completo di ciò che il personaggio ha, così togliere una di queste cose
// ne toglie anche il bonus.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_mutazioni.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';
import 'package:app_personaggio/models/background.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/models/modificatore.dart';
import 'package:app_personaggio/models/mutazione.dart';
import 'package:app_personaggio/services/effetti_personaggio.dart';

import 'linguette_scheda.dart';

Capacita _capacita({
  String nome = 'Capacità',
  Modificatore? caratteristica,
  Modificatore? abilita,
}) => Capacita(
  nome: nome,
  tipo: TipoCapacita.generica,
  descrizione: '',
  effetto: '',
  modificatoreCaratteristica: caratteristica,
  modificatoreAbilita: abilita,
  costo: 2,
  tag: const [],
);

Background _background({Modificatore? caratteristica, Modificatore? abilita}) =>
    Background(
      nome: 'Background',
      descrizione: '',
      capacitaDiBackground: _capacita(nome: 'Capacità di Background'),
      modificatoreCaratteristica: caratteristica,
      modificatoreAbilita: abilita,
      tag: 'Militare',
    );

Mutazione _mutazione(Modificatore? caratteristica) => Mutazione(
  nome: 'Mutazione',
  descrizione: '',
  effetto: '',
  modificatoreCaratteristica: caratteristica,
);

void main() {
  test('i modificatori delle Capacità alimentano il Valore Bonus', () {
    final capacita = [
      _capacita(
        nome: 'Impeto',
        caratteristica: const Modificatore(nome: 'Forza', valore: 1),
      ),
      _capacita(
        nome: 'Vista Acuta',
        caratteristica: const Modificatore(nome: 'Forza', valore: 2),
        abilita: const Modificatore(nome: 'Percezione', valore: 1),
      ),
    ];

    expect(bonusCaratteristica('Forza', capacita: capacita), 3);
    expect(bonusAbilita('Percezione', capacita: capacita), 1);
  });

  test('anche i modificatori del Background contano', () {
    final background = _background(
      caratteristica: const Modificatore(nome: 'Socialità', valore: 1),
      abilita: const Modificatore(nome: 'Persuasione', valore: 2),
    );

    expect(
      bonusCaratteristica(
        'Socialità',
        capacita: const [],
        background: background,
      ),
      1,
    );
    expect(
      bonusAbilita('Persuasione', capacita: const [], background: background),
      2,
    );
  });

  test('anche i modificatori delle Mutazioni contano', () {
    final mutazioni = [
      _mutazione(const Modificatore(nome: 'Forza', valore: 1)),
      _mutazione(const Modificatore(nome: 'Forza', valore: 2)),
      _mutazione(null),
    ];

    expect(
      bonusCaratteristica('Forza', capacita: const [], mutazioni: mutazioni),
      3,
    );
  });

  test('i bonus delle diverse sorgenti si sommano', () {
    final bonus = bonusCaratteristica(
      'Forza',
      capacita: [
        _capacita(caratteristica: const Modificatore(nome: 'Forza', valore: 1)),
      ],
      background: _background(
        caratteristica: const Modificatore(nome: 'Forza', valore: 2),
      ),
      mutazioni: [_mutazione(const Modificatore(nome: 'Forza', valore: 4))],
    );

    expect(bonus, 7);
  });

  test('una caratteristica non toccata resta a 0', () {
    expect(
      bonusCaratteristica(
        'Volontà',
        capacita: [
          _capacita(
            caratteristica: const Modificatore(nome: 'Forza', valore: 3),
          ),
        ],
        background: _background(),
        mutazioni: [_mutazione(const Modificatore(nome: 'Agilità', valore: 2))],
      ),
      0,
    );
  });

  test('i modificatori negativi sottraggono', () {
    expect(
      bonusCaratteristica(
        'Agilità',
        capacita: const [],
        mutazioni: [
          _mutazione(const Modificatore(nome: 'Agilità', valore: -2)),
        ],
      ),
      -2,
    );
  });

  test('senza sorgenti il bonus è zero', () {
    expect(bonusCaratteristica('Forza', capacita: const []), 0);
    expect(bonusAbilita('Percezione', capacita: const []), 0);
  });

  testWidgets('in Scheda il bonus della Mutazione arriva alla Caratteristica', (
    tester,
  ) async {
    // Le Mutazioni si prendono dalla Scheda, quindi è lì che il loro
    // Modificatore deve farsi vedere.
    final mutazione = listaMutazioni.firstWhere(
      (m) => m.modificatoreCaratteristica != null,
    );
    final nomeCaratteristica = mutazione.modificatoreCaratteristica!.nome;
    final valore = mutazione.modificatoreCaratteristica!.valore;

    final sistema = listaSistemi.first;
    final scheda = Scheda(
      personaggio: Personaggio(
        nome: 'Kaleb',
        anni: 30,
        genere: Genere.maschio,
        razza: listaRazze.first,
        sistemaDiOrigine: sistema,
        pianetaDiOrigine: sistema.pianeti.first,
        background: listaBackground.first,
        caratteristiche: listaCaratteristiche
            .map(
              (c) =>
                  CaratteristicaPersonaggio(caratteristica: c, valoreBase: 3),
            )
            .toList(),
        // Tutte le abilità: la Scheda calcola la Percezione Passiva e si
        // aspetta di trovarle.
        abilita: listaAbilita
            .map((a) => AbilitaPersonaggio(abilita: a, valoreBase: 1))
            .toList(),
        mutazioni: [mutazione],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: scheda, onModificata: (_) {}),
      ),
    );
    await vaiAllaPagina(tester, 'Abilità');

    // La riga della Caratteristica toccata: Totale, Base, Bonus.
    final riga = find
        .ancestor(of: find.text(nomeCaratteristica), matching: find.byType(Row))
        .first;
    expect(
      find.descendant(of: riga, matching: find.text('${3 + valore}')),
      findsOneWidget,
      reason: 'il Valore Totale deve comprendere il bonus della Mutazione',
    );
    expect(
      find.descendant(of: riga, matching: find.text('$valore')),
      findsWidgets,
      reason: 'il Valore Bonus deve valere quanto il Modificatore',
    );
  });
}
