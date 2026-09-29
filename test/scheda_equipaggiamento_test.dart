// APP/Pagina/Scheda, pagina Equip: Armi e Armatura sono in tabella,
// con un'intestazione che nomina ogni campo, come già fanno
// Caratteristiche e Abilità. Qui si verifica che
// l'intestazione ci sia, che i valori della riga siano quelli dell'arma
// e che i Tratti restino consultabili sotto la tabella.
//
// L'equipaggiamento arriva da Lista/Armi e Lista/Armature e non è
// inventato qui: le tendine di scelta accettano solo quelle voci.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_tratti.dart';
import 'package:app_personaggio/enums/abilita_arma.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

/// Arma a distanza, con Raffica e due Tratti. Presa per nome e non per
/// posizione: il catalogo è diviso in due elenchi e l'ordine cambia
/// appena se ne aggiunge una.
final _fucile = listaArmi.firstWhere((a) => a.nome == 'Pistola');

/// Arma da mischia, senza Raffica, con un solo Tratto.
final _mazza = listaArmi.firstWhere((a) => a.nome == 'Martello');

/// Tratto in comune fra le due armi: deve essere spiegato una volta sola.
final _trattoComune = listaTratti[2];

final _armatura = listaArmature[0];

/// Le formule del Pulsante Info sono scritte in grassetto + testo, cioè
/// come un RichText: find.text non le vedrebbe.
Finder _testoRicco(String atteso) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(atteso),
  description: 'RichText contenente "$atteso"',
);

Scheda _scheda() {
  final sistema = listaSistemi.first;
  return Scheda(
    personaggio: Personaggio(
      nome: 'Kaleb',
      anni: 34,
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
      armi: [_fucile, _mazza],
      armatura: _armatura,
    ),
  );
}

/// Porta la Scheda sulla pagina Equip.
Future<void> _apriPagina3(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
    ),
  );
  await vaiAllaPagina(tester, 'Equip');
}

void main() {
  testWidgets('la tabella delle Armi intesta ogni campo', (tester) async {
    await _apriPagina3(tester);

    for (final campo in [
      'Arma',
      'Abilità',
      'Danno',
      'DE',
      'VP',
      'Tipo Danno',
      'Gittata',
      'Raffica',
      'Tratti',
      'Tag',
    ]) {
      expect(find.text(campo), findsWidgets, reason: campo);
    }

    // La colonna "Tipo" (mischia o distanza) non c'è più: si legge
    // dalla Gittata, e sul telefono lo spazio serve altrove.
    expect(find.text('Tipo'), findsNothing);
  });

  testWidgets('il Tipo Danno sta dopo il VP', (tester) async {
    await _apriPagina3(tester);

    // Le intestazioni sono in riga: basta confrontare la posizione.
    expect(
      tester.getTopLeft(find.text('Tipo Danno').first).dx,
      greaterThan(tester.getTopLeft(find.text('VP').first).dx),
    );
    expect(
      tester.getTopLeft(find.text('Gittata').first).dx,
      greaterThan(tester.getTopLeft(find.text('Tipo Danno').first).dx),
    );
  });

  testWidgets('ogni arma è una riga con i suoi valori', (tester) async {
    await _apriPagina3(tester);

    expect(find.text(_fucile.nome), findsWidgets);
    expect(find.text(_mazza.nome), findsWidgets);

    // Mischia o distanza si distinguono dalla Gittata: tre numeri per
    // l'arma a distanza, uno solo per quella da mischia.
    expect(find.text('3 / 6 / 9'), findsOneWidget);

    // La Raffica ce l'ha solo l'arma a distanza: sull'altra la cella
    // resta vuota invece di dire "No".
    expect(find.text('Sì'), findsOneWidget);
    expect(find.text('-'), findsWidgets);

    // L'Abilità è quella associata all'arma, e serve al giocatore per
    // sapere su quale valore tirare (la Riserva di Dadi si legge in
    // pagina Abilità).
    expect(find.text(_fucile.abilitaAssociata.nomeAbilita), findsWidgets);
  });

  testWidgets('la pagina Stato ha il tasto info con tutte le formule', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
      ),
    );
    await vaiAllaPagina(tester, 'Stato');

    // Cercato per tooltip perché di tasti info l'app ne ha più d'uno.
    final tasto = find.byTooltip('Come si calcolano questi valori');
    await tester.ensureVisible(tasto);
    await tester.pumpAndSettle();
    await tester.tap(tasto);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    // Ogni valore della pagina è spiegato.
    for (final formula in [
      'Difesa: Iniziativa - 1',
      'Resilienza Base: Resistenza + 1',
      'Ferite Base: Resistenza',
      'Shock Massimo: Volontà + Resistenza',
      'Grinta: Resistenza',
      'Fermezza: Volontà',
      'Risolutezza: Volontà - 1',
    ]) {
      expect(_testoRicco(formula), findsOneWidget, reason: formula);
    }
  });

  // Gli Oggetti non hanno più una tendina: si aggiungono da una modale,
  // e il loro comportamento sta in scheda_oggetti_test.dart.

  testWidgets('la tabella dell Armatura intesta PA e PA Energia', (
    tester,
  ) async {
    await _apriPagina3(tester);

    expect(find.text('Armatura'), findsWidgets);
    expect(find.text('PA'), findsWidgets);
    expect(find.text('PA Energia'), findsWidgets);
    expect(find.text(_armatura.nome), findsWidgets);
  });

  testWidgets('la stessa arma si può prendere più di una volta', (
    tester,
  ) async {
    await _apriPagina3(tester);

    // La scheda ha già la Pistola: deve restare fra le opzioni del campo
    // vuoto in coda, altrimenti non si potrebbe averne due.
    final tendine = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(tendine.at(2));
    await tester.pumpAndSettle();
    await tester.tap(tendine.at(2));
    await tester.pumpAndSettle();

    expect(
      find.text(_fucile.nome),
      findsWidgets,
      reason: 'un\'arma già scelta deve restare selezionabile',
    );
  });

  testWidgets('un tratto su due armi è spiegato una volta sola', (
    tester,
  ) async {
    await _apriPagina3(tester);

    // Nella colonna Tratti il nome da solo è la cella della mazza (quella
    // del fucile elenca due tratti); sotto la tabella la voce
    // espandibile è una sola, anche se il tratto è su entrambe le armi.
    expect(find.text(_trattoComune.nome), findsNWidgets(2));

    // La voce sta in fondo alla pagina: va portata in vista prima di
    // toccarla.
    final voce = find.text(_trattoComune.nome).last;
    await tester.ensureVisible(voce);
    await tester.pumpAndSettle();
    await tester.tap(voce);
    await tester.pumpAndSettle();
    expect(find.text(_trattoComune.descrizione), findsOneWidget);
    expect(find.text(_trattoComune.effetto), findsOneWidget);
  });
}
