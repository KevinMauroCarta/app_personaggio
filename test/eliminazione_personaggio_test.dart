// APP/Pagina/Home, voce "Elimina": toccando un personaggio compare il
// menu Scheda/Modifica/Aumento/Elimina, e "Elimina" chiede conferma
// prima di cancellare. Qui si verifica che "Annulla" non tocchi niente e
// che "Elimina" tolga il personaggio sia dalla Home sia dal salvataggio
// permanente, lasciando gli altri al loro posto.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/main.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/services/character_storage.dart';

Scheda _scheda(String nome) {
  final sistema = listaSistemi.first;
  return Scheda(
    personaggio: Personaggio(
      nome: nome,
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

/// Avvia l'app con due personaggi già salvati e apre il menu del primo.
Future<void> _apriMenuDiKaleb(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({
    'personaggi_salvati': [
      jsonEncode(_scheda('Kaleb').toJson()),
      jsonEncode(_scheda('Seconda').toJson()),
    ],
  });

  await tester.pumpWidget(const AppPersonaggi());
  await tester.pumpAndSettle();

  await tester.tap(find.text('Kaleb'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('il menu del personaggio offre anche Elimina, per ultima', (
    tester,
  ) async {
    await _apriMenuDiKaleb(tester);

    expect(find.text('Scheda'), findsOneWidget);
    expect(find.text('Modifica'), findsOneWidget);
    expect(find.text('Aumento'), findsOneWidget);
    expect(find.text('Elimina'), findsOneWidget);

    // "Elimina" sta sotto "Aumento".
    double y(String voce) => tester.getCenter(find.text(voce)).dy;
    expect(y('Elimina'), greaterThan(y('Aumento')));
  });

  testWidgets('Elimina chiede conferma e Annulla non cancella niente', (
    tester,
  ) async {
    await _apriMenuDiKaleb(tester);

    await tester.tap(find.text('Elimina'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Elimina personaggio'), findsOneWidget);
    expect(find.text('Annulla'), findsOneWidget);

    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Kaleb'), findsOneWidget);
    expect((await CharacterStorage().caricaSchede()).length, 2);
  });

  testWidgets('confermando, il personaggio sparisce anche dal salvataggio', (
    tester,
  ) async {
    await _apriMenuDiKaleb(tester);

    await tester.tap(find.text('Elimina'));
    await tester.pumpAndSettle();

    // Nel dialogo "Elimina" è il pulsante, non il titolo della voce di
    // menu (che nel frattempo è stata chiusa).
    await tester.tap(find.widgetWithText(TextButton, 'Elimina'));
    await tester.pumpAndSettle();

    expect(find.text('Kaleb'), findsNothing);
    // L'altro personaggio resta dov'era.
    expect(find.text('Seconda'), findsOneWidget);

    final rimaste = await CharacterStorage().caricaSchede();
    expect(rimaste.length, 1);
    expect(rimaste.single.personaggio.nome, 'Seconda');
  });
}
