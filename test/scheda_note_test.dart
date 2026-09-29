// APP/Pagina/Scheda, pagina Info - Note.
//
// Le note sono testo scritto a mano, una per riga: si aggiungono dal "+"
// a fianco del titolo e si tolgono con la "X". Non essendoci un
// catalogo dietro, l'unica regola è che una nota vuota non è una nota.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

Scheda _scheda({List<String> note = const []}) {
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
    ),
    note: note,
  );
}

/// Apre la Scheda sulla pagina Info e raccoglie le schede salvate.
Future<List<Scheda>> _apri(
  WidgetTester tester, {
  List<String> note = const [],
}) async {
  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(note: note),
        onModificata: salvate.add,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return salvate;
}

/// Porta in vista e tocca: la sezione Note è in fondo alla pagina.
Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Scrive una nota nella modale e conferma.
Future<void> _scriviNota(WidgetTester tester, String testo) async {
  await _tocca(tester, find.byTooltip('Aggiungi nota'));
  await tester.enterText(
    find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    ),
    testo,
  );
  await tester.tap(find.widgetWithText(TextButton, 'Aggiungi'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('senza note la sezione lo dice', (tester) async {
    await _apri(tester);

    expect(find.text('Nessuna nota.'), findsOneWidget);
  });

  testWidgets('una nota scritta a mano diventa una riga', (tester) async {
    final salvate = await _apri(tester);

    await _scriviNota(tester, 'Il mercante mente sul carico.');

    expect(find.text('Il mercante mente sul carico.'), findsOneWidget);
    expect(find.text('Nessuna nota.'), findsNothing);
    // Ed è già salvata: le note non aspettano l'uscita dalla pagina.
    expect(salvate.last.note, ['Il mercante mente sul carico.']);
  });

  testWidgets('ogni nota ha la sua riga, nell ordine in cui è stata scritta', (
    tester,
  ) async {
    final salvate = await _apri(tester, note: const ['Prima']);

    await _scriviNota(tester, 'Seconda');

    expect(salvate.last.note, ['Prima', 'Seconda']);
    expect(
      tester.getTopLeft(find.text('Prima')).dy,
      lessThan(tester.getTopLeft(find.text('Seconda')).dy),
    );
  });

  testWidgets('una nota vuota non viene aggiunta', (tester) async {
    final salvate = await _apri(tester);

    await _scriviNota(tester, '   ');

    expect(find.text('Nessuna nota.'), findsOneWidget);
    expect(salvate, isEmpty, reason: 'niente da salvare');
  });

  testWidgets('la X toglie la nota', (tester) async {
    final salvate = await _apri(tester, note: const ['Prima', 'Seconda']);

    // La "X" della prima riga.
    await _tocca(tester, find.byTooltip('Rimuovi nota').first);

    expect(salvate.last.note, ['Seconda']);
    expect(find.text('Prima'), findsNothing);
  });

  test('le note salvate come testo unico non vanno perse', () {
    // Prima erano un campo solo: quel testo diventa la prima nota.
    final vecchia = Scheda.fromJson({
      ..._scheda().toJson(),
      'note': 'Cerca il fratello scomparso.',
    });

    expect(vecchia.note, ['Cerca il fratello scomparso.']);
  });

  test('una nota vuota nel vecchio formato non diventa una riga', () {
    final vecchia = Scheda.fromJson({..._scheda().toJson(), 'note': ''});

    expect(vecchia.note, isEmpty);
  });
}
