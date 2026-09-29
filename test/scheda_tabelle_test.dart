// Le colonne delle tabelle della Scheda si adattano al contenuto.
//
// Il modo per verificarlo senza misurare pixel a mano è l'altezza del
// testo: se una parola non ci sta nella sua colonna va a capo, e la riga
// diventa alta il doppio. Confrontando con una parola corta si vede
// subito se è successo.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_oggetti.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

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
    equipaggiamento: Equipaggiamento(
      armi: [listaArmi.first, listaArmi.last],
      armatura: listaArmature.first,
      // Anche gli Oggetti: le loro tendine offrono armi e armature, che
      // hanno i nomi più lunghi del catalogo.
      oggetti: [listaOggetti.first.nome, listaArmi.first.nome],
    ),
  );
}

Future<void> _apri(WidgetTester tester, String pagina) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
    ),
  );
  await tester.tap(find.text(pagina));
  await tester.pumpAndSettle();
}

/// Larghezza di un telefono stretto, quello su cui l'app viene usata:
/// è lì che le tabelle sfondavano.
const _telefonoStretto = Size(361, 800);

void main() {
  testWidgets('a 361 punti nessuna pagina va in overflow', (tester) async {
    tester.view.physicalSize = _telefonoStretto;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    // Un overflow viene segnalato come eccezione durante il disegno:
    // basta visitare ogni pagina e controllare che non ne arrivino.
    for (final pagina in [
      'Info',
      'Abilità',
      'Equip',
      'Capacità',
      'Poteri',
      'Stato',
      'Oggetti',
    ]) {
      await vaiAllaPagina(tester, pagina);
      expect(tester.takeException(), isNull, reason: pagina);
    }
  });

  testWidgets('l asterisco sta attaccato al nome dell abilità', (tester) async {
    await _apri(tester, 'Abilità');

    expect(find.text('Sopravvivenza*'), findsOneWidget);
    expect(find.text('Sopravvivenza *'), findsNothing);
  });

  testWidgets('il nome di abilità più lungo entra su una riga sola', (
    tester,
  ) async {
    await _apri(tester, 'Abilità');

    // "Mira" è certamente su una riga: è il metro di paragone.
    final altezzaUnaRiga = tester.getSize(find.text('Mira*')).height;

    expect(
      tester.getSize(find.text('Sopravvivenza*')).height,
      altezzaUnaRiga,
      reason: 'la colonna dei nomi deve contenere "Sopravvivenza*" intero',
    );
  });

  testWidgets('le intestazioni della tabella Armi non si spezzano', (
    tester,
  ) async {
    await _apri(tester, 'Equip');

    // Prima le colonne erano a larghezza fissa e "Raffica" finiva
    // spezzata in "Raffic" + "a".
    final altezzaUnaRiga = tester.getSize(find.text('DE').first).height;

    for (final intestazione in ['Raffica', 'Tipo Danno', 'Abilità']) {
      expect(
        tester.getSize(find.text(intestazione).first).height,
        altezzaUnaRiga,
        reason: '"$intestazione" non deve andare a capo',
      );
    }
  });
}
