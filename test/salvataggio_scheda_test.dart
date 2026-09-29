// APP/Pagina/Scheda: le modifiche fatte durante il gioco (Ira, Ferite,
// Shock, equipaggiamento...) vengono salvate sul momento, senza aspettare
// il ritorno alla Home. Serve perché l'app può essere chiusa - o la
// pagina web ricaricata - con la Scheda ancora aperta.
//
// Qui si parte dalla Home, si apre la Scheda di un personaggio salvato,
// si modifica un valore e si rilegge SharedPreferences *senza* tornare
// indietro.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/grado_ferita.dart';
import 'package:app_personaggio/main.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/services/character_storage.dart';

import 'linguette_scheda.dart';

Scheda _scheda() {
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
  );
}

/// Avvia l'app con un personaggio salvato e ne apre la Scheda.
Future<void> _apriScheda(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({
    'personaggi_salvati': [jsonEncode(_scheda().toJson())],
  });

  await tester.pumpWidget(const AppPersonaggi());
  await tester.pumpAndSettle();

  await tester.tap(find.text('Kaleb'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Scheda'));
  await tester.pumpAndSettle();
}

/// Rilegge dal salvataggio permanente, come farebbe il prossimo avvio.
///
/// [WidgetTester.idle] svuota prima la coda dei future: il salvataggio
/// parte da un gestore di eventi e nessuno lo aspetta, quindi senza
/// questo si leggerebbe prima che sia stato scritto.
Future<Scheda> _riletta(WidgetTester tester) async {
  await tester.idle();
  await tester.pumpAndSettle();
  return (await CharacterStorage().caricaSchede()).single;
}

/// Il comando (bottone "+" o campo di testo) della riga intestata a
/// [etichetta]: cercarlo per tipo e basta prenderebbe quello di un'altra
/// riga, visto che la pagina ne ha diversi uguali.
Finder _comandoDellaRiga(String etichetta, Finder comando) {
  return find.descendant(
    of: find
        .ancestor(of: find.text(etichetta), matching: find.byType(Row))
        .first,
    matching: comando,
  );
}

/// Porta in vista il comando prima di usarlo: le pagine scorrono, e un
/// tocco su un widget fuori schermo non arriva a destinazione.
Future<Finder> _inVista(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  return finder;
}

/// Il "+" dell'Ira, nella pagina Info.
final _piuIra = _comandoDellaRiga('Ira', find.byIcon(Icons.add_circle_outline));

/// Il "+" del Grado Ferita, nella pagina Stato.
final _piuGradoFerita = _comandoDellaRiga(
  'Grado Ferita',
  find.byIcon(Icons.add_circle_outline),
);

void main() {
  testWidgets('l Ira è salvata appena cambiata, senza uscire dalla Scheda', (
    tester,
  ) async {
    await _apriScheda(tester);
    expect((await _riletta(tester)).iraAttuale, Scheda.iraIniziale);

    await tester.tap(await _inVista(tester, _piuIra));
    await tester.pumpAndSettle();

    expect((await _riletta(tester)).iraAttuale, Scheda.iraIniziale + 1);
  });

  testWidgets('anche il Grado Ferita è salvato subito', (tester) async {
    await _apriScheda(tester);

    await vaiAllaPagina(tester, 'Stato');

    await tester.tap(await _inVista(tester, _piuGradoFerita));
    await tester.pumpAndSettle();

    expect((await _riletta(tester)).ferite.gradoFerita, GradoFerita.uno);
  });

  testWidgets('anche l equipaggiamento scelto è salvato subito', (
    tester,
  ) async {
    await _apriScheda(tester);

    await vaiAllaPagina(tester, 'Equip');

    final armatura = listaArmature.first;
    // Cercato per etichetta: in pagina ci sono anche i campi delle Armi.
    // Toccandolo si apre la modale di scelta, e la spunta della riga
    // sceglie l'armatura.
    final campo = await _inVista(
      tester,
      find
          .ancestor(
            of: find.text('Armatura indossata'),
            matching: find.byType(InkWell),
          )
          .first,
    );
    await tester.tap(campo);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scegli ${armatura.nome}'));
    await tester.pumpAndSettle();

    expect(
      (await _riletta(tester)).equipaggiamento.armatura?.nome,
      armatura.nome,
    );
  });

  testWidgets('tornando alla Home la Scheda salvata resta quella modificata', (
    tester,
  ) async {
    await _apriScheda(tester);

    await tester.tap(await _inVista(tester, _piuIra));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Kaleb'), findsOneWidget);
    expect((await _riletta(tester)).iraAttuale, Scheda.iraIniziale + 1);
  });
}
