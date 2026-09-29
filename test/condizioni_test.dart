// APP/Pagina/Scheda: le Condizioni sono i malus e i bonus che il
// personaggio si porta dietro adesso.
//
// Non si scrivono in scheda: si ricavano da come sta messo. "Ferito"
// compare quando il Grado Ferita supera lo zero, "Corrotto" quando lo
// supera il Grado di Corruzione, e ognuna porta come numero il grado
// stesso. È la stessa scelta fatta per il Valore Bonus: un dato
// calcolato non può restare indietro rispetto a ciò che lo genera.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/grado_ferita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/ferite.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

Scheda _scheda({GradoFerita grado = GradoFerita.zero, int corruzione = 0}) {
  final sistema = listaSistemi.first;
  return Scheda(
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
            (c) => CaratteristicaPersonaggio(caratteristica: c, valoreBase: 3),
          )
          .toList(),
      abilita: listaAbilita
          .map((a) => AbilitaPersonaggio(abilita: a, valoreBase: 2))
          .toList(),
      corruzione: corruzione,
    ),
    ferite: Ferite(gradoFerita: grado),
  );
}

/// Apre la Scheda e raccoglie le schede salvate.
Future<List<Scheda>> _apri(
  WidgetTester tester, {
  GradoFerita grado = GradoFerita.zero,
  int corruzione = 0,
}) async {
  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(grado: grado, corruzione: corruzione),
        onModificata: salvate.add,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return salvate;
}

/// Il comando della riga [etichetta]: le righe di Sopravvivenza hanno
/// tutte gli stessi bottoni, va preso quello giusto.
Finder _comando(String etichetta, IconData icona) => find.descendant(
  of: find.ancestor(of: find.text(etichetta), matching: find.byType(Row)).first,
  matching: find.byIcon(icona),
);

/// Il bottone che contiene [icona]: find.byIcon trova l'icona, e
/// l'icona non sa se è accesa o spenta - lo sa l'IconButton attorno.
Finder _bottoneDi(Finder icona) =>
    find.ancestor(of: icona, matching: find.byType(IconButton)).first;

Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Ferite, Shock e Grado Ferita stanno nella pagina Stato.
Future<void> _vaiAStato(WidgetTester tester) async {
  await vaiAllaPagina(tester, 'Stato');
}

void main() {
  test('a Grado Ferita 0 non c è nessuna condizione', () {
    expect(_scheda().condizioni, isEmpty);
  });

  test('sopra lo zero arriva Ferito col numero del grado', () {
    expect(
      _scheda(grado: GradoFerita.due).condizioni.single.etichetta,
      ['Ferito 2'].single,
    );
    expect(_scheda(grado: GradoFerita.tre).condizioni.single.valore, 3);
  });

  test('il Grado di Corruzione sale ogni cinque punti', () {
    expect(_scheda(corruzione: 0).gradoCorruzione, 0);
    expect(_scheda(corruzione: 4).gradoCorruzione, 0);
    expect(_scheda(corruzione: 5).gradoCorruzione, 1);
    expect(_scheda(corruzione: 9).gradoCorruzione, 1);
    expect(_scheda(corruzione: 10).gradoCorruzione, 2);
  });

  test('i punti arrivano a 25 e il grado a 5', () {
    expect(Scheda.corruzioneMassima, 25);
    expect(_scheda(corruzione: 25).gradoCorruzione, 5);
    expect(
      _scheda(corruzione: 40).gradoCorruzione,
      Scheda.gradoCorruzioneMassimo,
      reason: 'una scheda vecchia con troppi punti non sfonda il tetto',
    );
  });

  test('dal primo grado in poi arriva Corrotto col numero del grado', () {
    expect(_scheda(corruzione: 4).condizioni, isEmpty);
    expect(_scheda(corruzione: 5).condizioni.single.etichetta, 'Corrotto 1');
    expect(_scheda(corruzione: 12).condizioni.single.valore, 2);
  });

  test('Ferito e Corrotto convivono', () {
    final condizioni = _scheda(
      grado: GradoFerita.due,
      corruzione: 5,
    ).condizioni.map((c) => c.etichetta).toList();
    expect(condizioni, ['Ferito 2', 'Corrotto 1']);
  });

  testWidgets('Punti e Grado di Corruzione sono due righe distinte', (
    tester,
  ) async {
    await _apri(tester, corruzione: 7);

    expect(find.text('Punti Corruzione'), findsOneWidget);
    expect(find.text('Grado Corruzione'), findsOneWidget);
    expect(find.text('Corrotto 1'), findsOneWidget);
  });

  testWidgets('il Grado non si tocca a mano', (tester) async {
    await _apri(tester, corruzione: 7);

    // Sul Grado non ci sono bottoni: viene dai punti e basta.
    expect(
      _comando('Grado Corruzione', Icons.add_circle_outline),
      findsNothing,
    );
    expect(
      _comando('Grado Corruzione', Icons.remove_circle_outline),
      findsNothing,
    );
  });

  testWidgets('i punti non salgono oltre il massimo', (tester) async {
    await _apri(tester, corruzione: Scheda.corruzioneMassima);

    final piu = _bottoneDi(
      _comando('Punti Corruzione', Icons.add_circle_outline),
    );
    expect(tester.widget<IconButton>(piu).onPressed, isNull);
  });

  testWidgets('se il Grado non cambia i punti si tolgono senza domande', (
    tester,
  ) async {
    // Da 7 a 6 si resta a Grado 1: non c'è niente da confermare.
    final salvate = await _apri(tester, corruzione: 7);

    await _tocca(
      tester,
      _comando('Punti Corruzione', Icons.remove_circle_outline),
    );

    expect(find.byType(AlertDialog), findsNothing);
    expect(salvate.last.personaggio.corruzione, 6);
    expect(salvate.last.gradoCorruzione, 1);
  });

  testWidgets('anche sotto al primo grado non si chiede niente', (
    tester,
  ) async {
    final salvate = await _apri(tester, corruzione: 3);

    await _tocca(
      tester,
      _comando('Punti Corruzione', Icons.remove_circle_outline),
    );

    expect(find.byType(AlertDialog), findsNothing);
    expect(salvate.last.personaggio.corruzione, 2);
  });

  testWidgets('scendere di Grado chiede conferma', (tester) async {
    // Da 5 a 4 il Grado passa da 1 a 0: è il caso che va confermato.
    final salvate = await _apri(tester, corruzione: 5);

    await _tocca(
      tester,
      _comando('Punti Corruzione', Icons.remove_circle_outline),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Scendere di Grado di Corruzione?'), findsOneWidget);

    // Annulla: i punti restano quelli.
    await _tocca(tester, find.text('Annulla'));
    expect(find.byType(AlertDialog), findsNothing);
    expect(salvate, isEmpty, reason: 'niente è cambiato, niente da salvare');
    expect(find.text('Corrotto 1'), findsOneWidget);
  });

  testWidgets('confermando, il punto viene tolto davvero', (tester) async {
    final salvate = await _apri(tester, corruzione: 5);

    await _tocca(
      tester,
      _comando('Punti Corruzione', Icons.remove_circle_outline),
    );
    await _tocca(tester, find.text('Togli'));

    expect(salvate.last.personaggio.corruzione, 4);
    // Sceso sotto ai cinque punti, il grado e la condizione se ne vanno.
    expect(salvate.last.gradoCorruzione, 0);
    expect(salvate.last.condizioni, isEmpty);
    expect(find.text('Corrotto 1'), findsNothing);
  });

  testWidgets('senza condizioni la sezione lo dice', (tester) async {
    await _apri(tester);

    expect(find.text('Condizioni'), findsOneWidget);
    expect(find.text('Nessuna condizione attiva.'), findsOneWidget);
  });

  testWidgets('alzando il Grado Ferita compare la condizione Ferito', (
    tester,
  ) async {
    final salvate = await _apri(tester);
    await _vaiAStato(tester);

    await _tocca(tester, _comando('Grado Ferita', Icons.add_circle_outline));

    expect(salvate.last.ferite.gradoFerita, GradoFerita.uno);
    expect(salvate.last.condizioni.single.etichetta, 'Ferito 1');

    // E la condizione si vede nella pagina Info, senza aggiungerla.
    await vaiAllaPagina(tester, 'Info');
    expect(find.text('Ferito 1'), findsOneWidget);
  });

  testWidgets('il Grado Ferita non va sotto 0 né sopra 3', (tester) async {
    await _apri(tester);
    await _vaiAStato(tester);

    // A 0 il "-" è spento.
    final meno = _comando('Grado Ferita', Icons.remove_circle_outline);
    await tester.ensureVisible(meno);
    await tester.pumpAndSettle();
    expect(tester.widget<IconButton>(_bottoneDi(meno)).onPressed, isNull);

    // Tre volte "+" e si arriva al massimo: il "+" si spegne.
    final piu = _comando('Grado Ferita', Icons.add_circle_outline);
    for (var i = 0; i < 3; i++) {
      await _tocca(tester, piu);
    }
    expect(tester.widget<IconButton>(_bottoneDi(piu)).onPressed, isNull);
  });

  testWidgets('tornando a 0 la condizione sparisce da sola', (tester) async {
    final salvate = await _apri(tester, grado: GradoFerita.uno);
    await _vaiAStato(tester);

    await _tocca(tester, _comando('Grado Ferita', Icons.remove_circle_outline));

    expect(salvate.last.condizioni, isEmpty);

    await vaiAllaPagina(tester, 'Info');
    expect(find.text('Nessuna condizione attiva.'), findsOneWidget);
  });

  testWidgets('Ferite e Shock non si scrivono a mano da nessuna parte', (
    tester,
  ) async {
    await _apri(tester);
    await _vaiAStato(tester);

    // Sono due barre, non due campi: si segnano toccandole.
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Ferite'), findsOneWidget);
    expect(find.text('Shock'), findsOneWidget);
  });
}
