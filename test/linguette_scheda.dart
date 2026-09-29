// Aiuto condiviso per navigare fra le pagine della Scheda.
//
// Non è un file di test: non ha un main(), lo importano gli altri.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// La linguetta [nome] nella barra delle pagine della Scheda.
///
/// Cercata dentro al TabBar e non in tutta la schermata: da quando le
/// pagine portano il nome del loro contenuto, "Abilità", "Capacità" e
/// "Oggetti" sono anche titoli di sezione e intestazioni di tabella, e
/// un find.text nudo ne troverebbe più d'uno.
Finder linguetta(String nome) =>
    find.descendant(of: find.byType(TabBar), matching: find.text(nome));

/// Porta la Scheda sulla pagina [nome].
///
/// Le linguette non ci stanno tutte su uno schermo stretto: quella
/// cercata va portata in vista, altrimenti il tocco cadrebbe fuori
/// dallo schermo e la pagina non cambierebbe.
Future<void> vaiAllaPagina(WidgetTester tester, String nome) async {
  await tester.ensureVisible(linguetta(nome));
  await tester.pumpAndSettle();
  await tester.tap(linguetta(nome));
  await tester.pumpAndSettle();
}
