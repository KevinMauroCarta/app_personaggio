// APP/Pagina/Modifica-PG: aprendo un personaggio salvato, ogni Capacità
// torna nel campo di Pagina 2 da cui era stata presa.
//
// Il tipo della capacità non basta a capirlo: le due Capacità di Razza
// hanno lo stesso tipo, e alcuni sistemi offrono una Capacità Generica.
// Conta l'ordine in cui la Creazione le salva, campo per campo.
//
// I personaggi salvati prima che esistessero la seconda Capacità di Razza
// e quella del Pianeta si aprono lo stesso: quei campi restano vuoti, e
// vanno compilati prima di salvare.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/sistema.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show capacitaRazzaDaScegliere, ripartisciCapacita;
import 'package:app_personaggio/screens/modifica_pg/modifica_pg_page.dart';

final _razza = listaRazze.first;
final _sistema = listaSistemi.first;
final _pianeta = _sistema.pianeti.first;
final _background = listaBackground.first;
final _generica = listaCapacita.firstWhere(
  (c) => c.tipo == TipoCapacita.generica,
);

/// Le opzioni dei campi a scelta singola di Pagina 2, nell'ordine in cui
/// la Creazione li salva.
List<List<String>> _campi({Sistema? sistema}) {
  final s = sistema ?? _sistema;
  List<String> nomi(List<Capacita> capacita) =>
      capacita.map((c) => c.nome).toList();
  return [
    for (var i = 0; i < capacitaRazzaDaScegliere; i++) nomi(_razza.capacita),
    nomi(s.capacitaDelSistema),
    nomi(s.pianeti.first.capacitaDelPianeta),
    [_background.capacitaDiBackground.nome],
  ];
}

Personaggio _personaggio(List<Capacita> capacita) => Personaggio(
  nome: 'Kaleb',
  anni: 30,
  genere: Genere.maschio,
  razza: _razza,
  sistemaDiOrigine: _sistema,
  pianetaDiOrigine: _pianeta,
  background: _background,
  caratteristiche: [
    for (final c in listaCaratteristiche)
      CaratteristicaPersonaggio(caratteristica: c, valoreBase: 1),
  ],
  abilita: [
    for (final a in listaAbilita) AbilitaPersonaggio(abilita: a, valoreBase: 0),
  ],
  talenti: [listaTalenti.first],
  capacita: capacita,
  pxDisponibili: 40,
);

/// Il valore mostrato dalla tendina intestata [etichetta].
String? _valoreTendina(WidgetTester tester, String etichetta) {
  final campo = find
      .ancestor(
        of: find.text(etichetta),
        matching: find.byType(DropdownButtonFormField<String>),
      )
      .first;
  return tester
      .widget<DropdownButton<String>>(
        find.descendant(
          of: campo,
          matching: find.byType(DropdownButton<String>),
        ),
      )
      .value;
}

Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('ripartisciCapacita', () {
    test('ogni capacità torna nel suo campo', () {
      // Del pianeta si prende una delle due apprese, non quella della
      // tipologia che sta in testa all'elenco.
      final delPianeta = _pianeta.capacitaDelPianeta.last;

      final ripartite = ripartisciCapacita([
        ..._razza.capacita.take(2),
        _sistema.capacitaDelSistema.last,
        delPianeta,
        _background.capacitaDiBackground,
        _generica,
      ], _campi());

      expect(ripartite.campi, [
        _razza.capacita[0].nome,
        _razza.capacita[1].nome,
        _sistema.capacitaDelSistema.last.nome,
        delPianeta.nome,
        _background.capacitaDiBackground.nome,
      ]);
      expect(ripartite.generiche, [_generica.nome]);
    });

    test('un personaggio di prima lascia vuoti i campi nuovi', () {
      // Prima c'erano una sola Capacità di Razza e nessuna del Pianeta.
      final ripartite = ripartisciCapacita([
        _razza.capacita[0],
        _sistema.capacitaDelSistema.first,
        _background.capacitaDiBackground,
        _generica,
      ], _campi());

      expect(ripartite.campi, [
        _razza.capacita[0].nome,
        null,
        _sistema.capacitaDelSistema.first.nome,
        null,
        _background.capacitaDiBackground.nome,
      ]);
      expect(ripartite.generiche, [_generica.nome]);
    });

    test('una Generica offerta dal sistema si riconosce dalla posizione', () {
      // Presa come Capacità di Sistema sta prima di quella di Background;
      // comprata come Generica, dopo.
      final sistema = listaSistemi.firstWhere(
        (s) => s.capacitaDelSistema.any((c) => c.tipo == TipoCapacita.generica),
      );
      final psichica = sistema.capacitaDelSistema.firstWhere(
        (c) => c.tipo == TipoCapacita.generica,
      );

      final ripartite = ripartisciCapacita([
        _razza.capacita[0],
        psichica,
        _background.capacitaDiBackground,
        psichica,
      ], _campi(sistema: sistema));

      expect(ripartite.campi[capacitaRazzaDaScegliere], psichica.nome);
      expect(ripartite.generiche, [psichica.nome]);
    });
  });

  testWidgets('un personaggio di prima va completato prima di salvare', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ModificaPgPage(
          personaggio: _personaggio([
            _razza.capacita[0],
            _sistema.capacitaDelSistema.first,
            _background.capacitaDiBackground,
            _generica,
          ]),
        ),
      ),
    );
    // Pagina 1 è tutta compilata, e più lunga dello schermo.
    await _tocca(tester, find.text('Avanti'));

    // Quello che c'era torna al suo posto...
    expect(_valoreTendina(tester, 'Talento'), listaTalenti.first.nome);
    expect(
      _valoreTendina(tester, 'Capacità di Razza 1'),
      _razza.capacita[0].nome,
    );
    expect(
      _valoreTendina(tester, 'Capacità di Sistema'),
      _sistema.capacitaDelSistema.first.nome,
    );
    expect(_valoreTendina(tester, 'Capacità Generica 1'), _generica.nome);
    expect(find.text(_background.capacitaDiBackground.nome), findsOneWidget);

    // ...e i campi che allora non esistevano restano da scegliere.
    expect(_valoreTendina(tester, 'Capacità di Razza 2'), isNull);
    expect(_valoreTendina(tester, 'Capacità del Pianeta'), isNull);

    await _tocca(tester, find.text('Riepilogo'));
    expect(
      find.text('Compila prima: Capacità di Razza 2, Capacità del Pianeta'),
      findsOneWidget,
    );
  });

  testWidgets('salvando senza toccare nulla le capacità restano quelle', (
    tester,
  ) async {
    final capacita = [
      ..._razza.capacita.take(2),
      _sistema.capacitaDelSistema.last,
      _pianeta.capacitaDelPianeta.first,
      _background.capacitaDiBackground,
      _generica,
    ];
    final personaggio = _personaggio(capacita);

    Personaggio? salvato;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              salvato = await Navigator.of(context).push<Personaggio>(
                MaterialPageRoute(
                  builder: (_) => ModificaPgPage(personaggio: personaggio),
                ),
              );
            },
            child: const Text('Apri'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Apri'));
    await tester.pumpAndSettle();

    await _tocca(tester, find.text('Avanti'));
    expect(
      _valoreTendina(tester, 'Capacità del Pianeta'),
      _pianeta.capacitaDelPianeta.first.nome,
    );

    await _tocca(tester, find.text('Riepilogo'));
    await _tocca(tester, find.text('SALVA'));

    expect(salvato, isNotNull, reason: 'il personaggio doveva essere salvato');
    expect(salvato!.capacita.map((c) => c.nome), capacita.map((c) => c.nome));
    // Nessuna capacità è stata ripagata o rimborsata.
    expect(salvato!.pxDisponibili, personaggio.pxDisponibili);
  });
}
