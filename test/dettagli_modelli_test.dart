// Il Pulsante Info della pagina Info mostra il modello completo del campo, e
// le Capacità che vi compaiono sono cliccabili: toccandone una si apre un
// secondo dialog con i suoi dettagli.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/enums/densita_popolativa.dart';
import 'package:app_personaggio/enums/grandezza_pianeta.dart';
import 'package:app_personaggio/enums/scuola_psionica.dart';
import 'package:app_personaggio/enums/tipo_azione.dart';
import 'package:app_personaggio/enums/taglia.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/enums/tipologia_pianeta.dart';
import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/screens/creazione_pg/dettagli_modelli.dart';

/// find.text non entra dentro i RichText, che è come vengono resi i campi
/// del modello: questo finder cerca nel loro testo completo.
Finder testoRicco(String atteso) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(atteso),
  description: 'RichText contenente "$atteso"',
);

Future<void> _mostra(WidgetTester tester, Widget contenuto) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: contenuto)),
    ),
  );
}

void main() {
  testWidgets('le info di una Razza mostrano tutti i campi del modello', (
    tester,
  ) async {
    final razza = listaRazze.first;
    await _mostra(tester, DettagliRazza(razze: [razza]));

    expect(find.text(razza.nome), findsOneWidget);
    expect(testoRicco('Descrizione: ${razza.descrizione}'), findsOneWidget);
    expect(testoRicco('Tag: ${razza.tag}'), findsOneWidget);
    expect(testoRicco('Taglia: ${razza.taglia.label}'), findsOneWidget);

    // Ogni Capacità di Razza compare come voce a sé, non appiattita nel
    // testo di un campo.
    for (final c in razza.capacita) {
      expect(find.text(c.nome), findsOneWidget);
    }
  });

  testWidgets('le info di un Background mostrano tutti i campi del modello', (
    tester,
  ) async {
    final background = listaBackground.first;
    await _mostra(tester, DettagliBackground(background: [background]));

    expect(find.text(background.nome), findsOneWidget);
    expect(
      testoRicco('Descrizione: ${background.descrizione}'),
      findsOneWidget,
    );
    expect(testoRicco('Tag: ${background.tag}'), findsOneWidget);
    expect(find.text(background.capacitaDiBackground.nome), findsOneWidget);
  });

  testWidgets('le info di un Sistema mostrano governo, pianeti e capacità', (
    tester,
  ) async {
    final sistema = listaSistemi.first;
    await _mostra(tester, DettagliSistema(sistemi: [sistema]));

    expect(find.text(sistema.nome), findsOneWidget);
    expect(testoRicco('Governo: ${sistema.governo}'), findsOneWidget);
    expect(testoRicco(sistema.pianeti.first.nome), findsWidgets);
    for (final c in sistema.capacitaDelSistema) {
      expect(find.text(c.nome), findsOneWidget);
    }
  });

  testWidgets('le info di un Pianeta mostrano tutti i campi del modello', (
    tester,
  ) async {
    final pianeta = listaSistemi.first.pianeti.first;
    await _mostra(tester, DettagliPianeta(pianeti: [pianeta]));

    expect(find.text(pianeta.nome), findsOneWidget);
    expect(testoRicco('Grandezza: ${pianeta.grandezza.label}'), findsOneWidget);
    expect(testoRicco('Tipologia: ${pianeta.tipologia.label}'), findsOneWidget);
    expect(testoRicco('Capitale: ${pianeta.capitale}'), findsOneWidget);
    expect(
      testoRicco('Densità popolativa: ${pianeta.densitaPopolativa.label}'),
      findsOneWidget,
    );
  });

  testWidgets('toccando una capacità si aprono i suoi dettagli', (
    tester,
  ) async {
    final razza = listaRazze.first;
    final capacita = razza.capacita.first;
    await _mostra(tester, DettagliRazza(razze: [razza]));

    // Prima del tocco si vede solo il nome della capacità.
    expect(testoRicco('Effetto: ${capacita.effetto}'), findsNothing);

    await tester.tap(find.text(capacita.nome));
    await tester.pumpAndSettle();

    expect(find.text('Capacità'), findsOneWidget);
    expect(testoRicco('Tipo: ${capacita.tipo.label}'), findsOneWidget);
    expect(testoRicco('Effetto: ${capacita.effetto}'), findsOneWidget);
    expect(testoRicco('Costo: ${capacita.costo}'), findsOneWidget);

    // Chiudendo si torna alle info del campo, che sono rimaste aperte.
    await tester.tap(find.text('Chiudi'));
    await tester.pumpAndSettle();
    expect(find.text(razza.nome), findsOneWidget);
  });

  testWidgets('con più elementi si vedono solo i nomi, finché non si apre', (
    tester,
  ) async {
    await _mostra(tester, DettagliRazza(razze: listaRazze));

    // Tutti i nomi sono visibili...
    for (final r in listaRazze) {
      expect(find.text(r.nome), findsOneWidget);
    }
    // ...ma nessun contenuto lo è: partono tutti chiusi.
    for (final r in listaRazze) {
      expect(testoRicco('Descrizione: ${r.descrizione}'), findsNothing);
    }

    // Aprendo una razza compare solo il suo contenuto.
    final scelta = listaRazze[1];
    await tester.tap(find.text(scelta.nome));
    await tester.pumpAndSettle();

    expect(testoRicco('Descrizione: ${scelta.descrizione}'), findsOneWidget);
    expect(
      testoRicco('Descrizione: ${listaRazze.first.descrizione}'),
      findsNothing,
    );

    // Ritoccandola si richiude.
    await tester.tap(find.text(scelta.nome));
    await tester.pumpAndSettle();
    expect(testoRicco('Descrizione: ${scelta.descrizione}'), findsNothing);
  });

  testWidgets('le info di un Talento mostrano tutti i campi del modello', (
    tester,
  ) async {
    final talento = listaTalenti.first;
    await _mostra(tester, DettagliTalento(talenti: [talento]));

    expect(find.text(talento.nome), findsOneWidget);
    expect(testoRicco('Descrizione: ${talento.descrizione}'), findsOneWidget);
    expect(testoRicco('Effetto: ${talento.effetto}'), findsOneWidget);
    expect(testoRicco('Tag: ${talento.tag}'), findsOneWidget);
  });

  testWidgets('le info di un Potere Psionico mostrano tutti i campi', (
    tester,
  ) async {
    final potere = listaPoteriPsionici.first;
    await _mostra(tester, DettagliPoterePsionico(poteri: [potere]));

    expect(find.text(potere.nome), findsOneWidget);
    expect(testoRicco('Scuola: ${potere.scuola.label}'), findsOneWidget);
    expect(testoRicco('CD: ${potere.cd}'), findsOneWidget);
    expect(
      testoRicco('Attivazione: ${potere.attivazione.label}'),
      findsOneWidget,
    );
    expect(testoRicco('Durata: ${potere.durata.etichetta}'), findsOneWidget);
    expect(testoRicco('Gittata: ${potere.gittata}'), findsOneWidget);
    expect(testoRicco('Costo: ${potere.costo}'), findsOneWidget);
  });
}
