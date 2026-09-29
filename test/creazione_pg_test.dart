// APP/Pagina/Creazione-PG: i due controlli che impediscono di creare un
// personaggio non valido (campi obbligatori di Pagina 1 e PE negativi) e
// il legame fra Capacità Generiche e Poteri Psionici.
//
// Il Tag Psionico arriva quasi sempre da una Capacità Generica: se la si
// toglie, i poteri già scelti non spettano più al personaggio e i PE
// spesi devono tornare indietro.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show abilitaFuoriRegola;
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_page.dart';

/// Apre la tendina intestata [etichetta] e ne sceglie la voce [valore].
Future<void> _scegli(
  WidgetTester tester,
  String etichetta,
  String valore,
) async {
  final tendina = find
      .ancestor(
        of: find.text(etichetta),
        matching: find.byType(DropdownButtonFormField<String>),
      )
      .first;
  await tester.ensureVisible(tendina);
  await tester.pumpAndSettle();
  await tester.tap(tendina);
  await tester.pumpAndSettle();
  await tester.tap(find.text(valore).last);
  await tester.pumpAndSettle();
}

/// Compila tutti i campi obbligatori di Pagina 1 e passa a Pagina 2.
Future<void> _compilaPagina1(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'Kaleb');
  await tester.pumpAndSettle();

  await _scegli(tester, 'Razza', 'Solari');
  await tester.enterText(find.byType(TextField).last, '30');
  await tester.pumpAndSettle();
  await _scegli(tester, 'Genere', 'Maschio');
  await _scegli(tester, 'Background', 'Nato tra le Stelle');
  await _scegli(tester, 'Sistema di origine', 'Sistema Solare');
  await tester.pumpAndSettle();

  // Il pianeta compare solo dopo il sistema, ed è uno di quelli di quel
  // sistema: si prende il primo dal catalogo.
  await _scegli(
    tester,
    'Pianeta di origine',
    listaSistemi.first.pianeti.first.nome,
  );

  await tester.tap(find.text('Avanti'));
  await tester.pumpAndSettle();
}

/// I PE letti dalla barra in fondo a Pagina 2.
int _peDisponibili(WidgetTester tester) {
  final testo = tester
      .widgetList<Text>(find.textContaining('Punti Esperienza disponibili:'))
      .first
      .data!;
  return int.parse(testo.split(':').last.trim());
}

/// Porta in vista e tocca: le pagine sono più lunghe dello schermo, e un
/// tocco su un widget fuori schermo non arriva a destinazione.
Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Alza di [passi] punti l'Abilità [nome] con il bottone "+".
Future<void> _alzaAbilita(WidgetTester tester, String nome, int passi) async {
  final riga = find
      .ancestor(of: find.textContaining(nome), matching: find.byType(Row))
      .first;
  final piu = find.descendant(
    of: riga,
    matching: find.byIcon(Icons.add_circle_outline),
  );
  for (var i = 0; i < passi; i++) {
    await tester.ensureVisible(piu);
    await tester.pumpAndSettle();
    await tester.tap(piu);
    await tester.pumpAndSettle();
  }
}

void main() {
  test('le abilità fuori regola sono quelle segnate in rosso', () {
    // Avanzamento/Abilità: per portare un'abilità a x servono almeno x
    // abilità apprese (Valore Base >= 1), quella compresa.
    expect(abilitaFuoriRegola({'Atletica': 1, 'Mira': 0}), isEmpty);
    expect(abilitaFuoriRegola({'Atletica': 2, 'Mira': 1}), isEmpty);
    expect(abilitaFuoriRegola({'Atletica': 2, 'Mira': 0}), ['Atletica']);
    expect(abilitaFuoriRegola({'Atletica': 3, 'Mira': 3}), [
      'Atletica',
      'Mira',
    ]);
  });

  testWidgets('senza i campi obbligatori non si passa a Pagina 2', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));

    await tester.tap(find.text('Avanti'));
    await tester.pumpAndSettle();

    // L'avviso dice quali campi mancano, e la pagina resta la prima.
    expect(find.textContaining('Compila prima:'), findsOneWidget);
    expect(find.textContaining('Nome personaggio'), findsWidgets);
    expect(find.text('Avanti'), findsOneWidget);
  });

  testWidgets('a 361 punti Pagina 2 non va in overflow', (tester) async {
    // La barra dei Punti Esperienza sta su una riga sola con il suo
    // tasto: su uno schermo stretto è il pezzo che rischia di non
    // starci.
    tester.view.physicalSize = const Size(361, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('con tutti i campi compilati si passa a Pagina 2', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    expect(find.text('Caratteristiche'), findsWidgets);
  });

  testWidgets('con un abilità in rosso il personaggio non si crea', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    // Atletica a 2 con una sola abilità appresa è fuori regola: la
    // riga diventa rossa, ma finora si poteva salvare lo stesso.
    await _alzaAbilita(tester, 'Atletica', 2);

    await _tocca(tester, find.text('Riepilogo'));
    await _tocca(tester, find.text('CREA'));

    expect(find.textContaining('Abilità oltre il limite'), findsOneWidget);
    expect(find.textContaining('Atletica'), findsWidgets);
    // Il personaggio non è stato creato: la pagina è ancora aperta.
    expect(find.text('CREA'), findsOneWidget);
  });

  testWidgets(
    'togliendo la capacità psionica i poteri spariscono e i PE tornano',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
      await _compilaPagina1(tester);

      final potere = listaPoteriPsionici.first;
      final pePrima = _peDisponibili(tester);

      // Una Capacità Generica porta il tag Psionico...
      await _scegli(tester, 'Capacità Generica 1', 'Addestramento Psichico');
      // ...e da lì si può comprare un potere, che costa.
      await _scegli(tester, 'Potere Psionico 1', potere.nome);
      expect(find.text(potere.nome), findsWidgets);
      expect(_peDisponibili(tester), lessThan(pePrima));

      // Togliendo la capacità il potere non spetta più: sparisce dal
      // campo e il suo costo torna indietro.
      final rimuovi = find
          .ancestor(
            of: find.text('Capacità Generica 1'),
            matching: find.byType(Row),
          )
          .first;
      await tester.tap(
        find.descendant(of: rimuovi, matching: find.byIcon(Icons.close)),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(potere.nome),
        findsNothing,
        reason: 'il potere non doveva restare selezionato',
      );
      // È questa la prova che lo stato è stato ripulito davvero e non
      // solo nascosto: i PE del potere e della capacità sono tornati.
      expect(
        _peDisponibili(tester),
        pePrima,
        reason: 'i PE spesi in capacità e poteri dovevano tornare',
      );
    },
  );
}
