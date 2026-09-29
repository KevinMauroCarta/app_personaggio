// APP/Pagina/Scheda, pagina "Poteri".
//
// I Poteri Psionici stavano in coda alla pagina Capacità, sotto Talenti e
// Capacità: per leggerli in mezzo a una scena bisognava scorrere tutta
// la pagina. Ora hanno una pagina loro.
//
// Qui si verifica che ci siano finiti davvero, che dalle Capacità siano
// spariti, e che la barra delle linguette dica che di pagine ce n'è più
// di quante se ne vedano.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/scuola_psionica.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/potere_psionico.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

final PoterePsionico _potere = listaPoteriPsionici.first;

Scheda _scheda({bool conPoteri = true}) {
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
      poteriPsionici: conPoteri ? [_potere] : const [],
    ),
  );
}

/// Apre la Scheda sulla pagina [pagina].
///
/// Le linguette non ci stanno tutte: quella cercata va portata in vista
/// prima di toccarla, o il tocco cade fuori dallo schermo.
Future<void> _apri(
  WidgetTester tester,
  String pagina, {
  bool conPoteri = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(conPoteri: conPoteri),
        onModificata: (_) {},
      ),
    ),
  );
  await vaiAllaPagina(tester, pagina);
}

void main() {
  testWidgets('i Poteri Psionici stanno sulla loro pagina', (tester) async {
    await _apri(tester, 'Poteri');

    expect(find.text('Poteri Psionici'), findsWidgets);
    expect(find.text(_potere.nome), findsOneWidget);
  });

  testWidgets('il potere si apre e mostra i suoi campi', (tester) async {
    await _apri(tester, 'Poteri');

    await tester.tap(find.text(_potere.nome));
    await tester.pumpAndSettle();

    expect(find.text(_potere.scuola.label), findsOneWidget);
    expect(find.text('${_potere.cd}'), findsWidgets);
    expect(find.text(_potere.durata.etichetta), findsWidgets);
  });

  testWidgets('dalla pagina Capacità i poteri sono spariti', (tester) async {
    await _apri(tester, 'Capacità');

    expect(find.text('Talenti'), findsWidgets);
    expect(find.text('Capacità'), findsWidgets);
    expect(find.text(_potere.nome), findsNothing);
  });

  testWidgets('senza poteri la pagina resta, e lo dice', (tester) async {
    await _apri(tester, 'Poteri', conPoteri: false);

    expect(find.text('Poteri Psionici'), findsWidgets);
    expect(find.text(_potere.nome), findsNothing);
  });

  testWidgets('su uno schermo stretto la barra dice che continua', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(361, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    // Appena aperta la scheda si vedono le prime linguette e basta: il
    // segnale serve a dire che le altre ci sono, non che sono finite.
    expect(find.text('Oggetti'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Oggetti')).dx,
      greaterThan(361),
      reason: 'l\'ultima pagina è fuori schermo: è questo il problema',
    );
    expect(find.byTooltip('Scorri per le altre pagine'), findsOneWidget);
  });

  testWidgets('se le linguette ci stanno tutte niente segnale', (tester) async {
    tester.view.physicalSize = const Size(2400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Scorri per le altre pagine'), findsNothing);
  });
}
