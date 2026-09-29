// La versione mostrata in Home deve essere quella vera dell'app.
//
// [versioneApp] è una costante nel codice, mentre la versione che
// finisce nell'APK e nella build web sta in pubspec.yaml: questo test
// tiene insieme i due posti, così non può succedere di distribuire la
// 0.6 con scritto "version: 0.5.0" in fondo alla Home.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/main.dart';
import 'package:app_personaggio/versione_app.dart';

/// Il `version:` di pubspec.yaml senza il numero di build dopo il "+":
/// in Home si mostra la sola versione.
String _versioneDaPubspec() {
  final riga = File('pubspec.yaml')
      .readAsLinesSync()
      .firstWhere((l) => l.startsWith('version:'));
  return riga.split(':').last.trim().split('+').first;
}

void main() {
  test('la versione nel codice è quella di pubspec.yaml', () {
    expect(versioneApp, _versioneDaPubspec());
    expect(
      versioneApp,
      isNot(contains('+')),
      reason: 'il numero di build non si mostra',
    );
  });

  testWidgets('la Home mostra la versione in fondo a sinistra', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const AppPersonaggi());
    await tester.pumpAndSettle();

    final versione = find.text('version: $versioneApp');
    expect(versione, findsOneWidget);

    // In fondo: sotto il contenuto della pagina. A sinistra: nella metà
    // sinistra dello schermo.
    final posizione = tester.getTopLeft(versione);
    final schermo = tester.getSize(find.byType(MaterialApp));
    expect(posizione.dy, greaterThan(schermo.height / 2));
    expect(posizione.dx, lessThan(schermo.width / 2));
  });
}
