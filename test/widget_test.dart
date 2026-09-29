// La Home: si avvia, ha il suo titolo ed è divisa in sezioni. La
// sezione "Personaggi" contiene i personaggi salvati e il pulsante di
// creazione; le altre due sono segnaposto.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/main.dart';

/// Larghezza del telefono su cui l'app viene usata davvero.
const _telefonoStretto = Size(361, 800);

Future<void> _avvia(WidgetTester tester) async {
  // La Home carica i personaggi salvati da SharedPreferences: senza
  // valori mock il plugin non risponde e lo spinner di caricamento
  // resterebbe visibile per sempre (pumpAndSettle andrebbe in timeout).
  SharedPreferences.setMockInitialValues({});

  await tester.pumpWidget(const AppPersonaggi());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App avvia e mostra il pulsante di creazione personaggio', (
    tester,
  ) async {
    await _avvia(tester);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('la Home ha il titolo e le sue sezioni', (tester) async {
    await _avvia(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Personaggi'), findsOneWidget);
    expect(find.text('Regolamento // in progress'), findsOneWidget);
    expect(find.text('Ambientazione // in progress'), findsOneWidget);
  });

  testWidgets('le sezioni da fare partono chiuse e si aprono', (tester) async {
    await _avvia(tester);

    // Chiusa: il contenuto non c'è proprio.
    expect(find.text('Non c\'è ancora niente qui.'), findsNothing);

    await tester.tap(find.text('Regolamento // in progress'));
    await tester.pumpAndSettle();

    expect(find.text('Non c\'è ancora niente qui.'), findsOneWidget);
  });

  testWidgets('a 361 punti la Home non va in overflow', (tester) async {
    tester.view.physicalSize = _telefonoStretto;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _avvia(tester);

    expect(tester.takeException(), isNull);
  });
}
