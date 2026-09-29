// APP/Pagina/Scheda, pagina Oggetti.
//
// Si aggiunge da una modale: una riga per oggetto, il nome apre i suoi
// dati e il "+" lo aggiunge chiudendo la modale. In scheda gli oggetti
// stanno in tabella con la quantità, e il "-" ne toglie uno alla volta
// finché la riga sparisce.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_oggetti.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/rarita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_dati.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

/// Un oggetto generico e un'arma: la modale li offre entrambi.
///
/// L'oggetto è il primo in ordine alfabetico, così sta in cima
/// all'elenco della modale ed è visibile senza scorrere.
final _oggetto =
    (listaOggetti.map((o) => o.nome).toList()..sort(confrontaNomi)).first;

/// La descrizione dell'oggetto di prova, come la mostra la modale.
final _descrizione = oggettoDaNome(_oggetto)!.descrizione;
final _arma = listaArmi.first;

Scheda _scheda({List<String> oggetti = const [], int socialita = 3}) {
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
            (c) => CaratteristicaPersonaggio(
              caratteristica: c,
              valoreBase: c.nome == 'Socialità' ? socialita : 3,
            ),
          )
          .toList(),
      abilita: listaAbilita
          .map((a) => AbilitaPersonaggio(abilita: a, valoreBase: 2))
          .toList(),
    ),
    equipaggiamento: Equipaggiamento(oggetti: oggetti),
  );
}

/// Il numero scritto sotto un'etichetta della riga in alto (Influenza).
///
/// Etichetta e valore stanno nella stessa Column, così basta guardare
/// lì dentro invece di cercare il numero in tutta la pagina, dove di
/// numeri ce ne sono altri.
String _valoreSotto(WidgetTester tester, String etichetta) {
  final colonna = find
      .ancestor(of: find.text(etichetta), matching: find.byType(Column))
      .first;
  final testi = find.descendant(of: colonna, matching: find.byType(Text));
  return tester.widget<Text>(testi.at(1)).data!;
}

/// Apre la Scheda sulla pagina Oggetti e raccoglie le schede salvate.
Future<List<Scheda>> _apriOggetti(
  WidgetTester tester, {
  List<String> oggetti = const [],
  int socialita = 3,
}) async {
  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(oggetti: oggetti, socialita: socialita),
        onModificata: salvate.add,
      ),
    ),
  );
  await vaiAllaPagina(tester, 'Oggetti');
  return salvate;
}

Future<void> _apriModale(WidgetTester tester) async {
  final bottone = find.widgetWithText(OutlinedButton, 'Aggiungi oggetto');
  await tester.ensureVisible(bottone);
  await tester.pumpAndSettle();
  await tester.tap(bottone);
  await tester.pumpAndSettle();
}

/// Porta in vista e tocca: la sezione Oggetti è in fondo alla pagina.
Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Il nome [nome] fra le righe della modale.
///
/// Cercato dentro l'elenco e non in tutta la pagina: quello che si
/// scrive nel campo di ricerca è a sua volta un testo, e verrebbe
/// contato anche lui.
Finder _nellaLista(String nome) =>
    find.descendant(of: find.byType(ListView), matching: find.text(nome));

/// I dati dell'oggetto sono scritti in grassetto + testo, cioè come
/// RichText: find.text non li vedrebbe.
Finder _testoRicco(String atteso) => find.byWidgetPredicate(
  (w) => w is RichText && w.text.toPlainText().contains(atteso),
  description: 'RichText contenente "$atteso"',
);

/// Scrive [testo] nel campo di ricerca della modale e lo salva come
/// filtro: finché non si preme "Aggiungi filtro" l'elenco non cambia.
///
/// Cercato dentro la modale: dietro c'è la pagina, che ha i suoi campi
/// di testo (Ferite e Shock Attuali).
Future<void> _cerca(WidgetTester tester, String testo) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    ),
    testo,
  );
  await tester.pumpAndSettle();
  await _tocca(tester, find.widgetWithText(FilledButton, 'Aggiungi filtro'));
}

void main() {
  test('il catalogo della modale è in ordine alfabetico', () {
    final ordinato = [...oggettiOptions]
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    expect(oggettiOptions, ordinato);
  });

  testWidgets('gli oggetti in scheda sono in ordine alfabetico', (
    tester,
  ) async {
    // Presi in ordine sparso, devono comparire ordinati.
    await _apriOggetti(
      tester,
      oggetti: const ['Torcia', 'Corda', 'Auspex', 'Corda'],
    );

    double posizione(String nome) => tester.getTopLeft(find.text(nome)).dy;

    expect(posizione('Auspex'), lessThan(posizione('Corda')));
    expect(posizione('Corda'), lessThan(posizione('Torcia')));
    // La Corda presa due volte resta una riga sola, con quantità 2.
    expect(find.text('Corda'), findsOneWidget);
  });

  testWidgets('la modale elenca gli oggetti e si cerca per nome', (
    tester,
  ) async {
    await _apriOggetti(tester);
    await _apriModale(tester);

    expect(find.text('Aggiungi oggetto'), findsWidgets);
    expect(find.text(_oggetto), findsOneWidget);

    // L'arma è in fondo al catalogo, fuori dalla parte visibile
    // dell'elenco: cercandola per nome resta lei sola.
    await _cerca(tester, _arma.nome);

    expect(_nellaLista(_arma.nome), findsOneWidget);
    expect(_nellaLista(_oggetto), findsNothing);

    // Un nome che non esiste non trova niente.
    await _cerca(tester, 'zzz');
    expect(find.text('Nessun oggetto trovato.'), findsOneWidget);
  });

  testWidgets('toccando il nome si aprono i dati dell oggetto', (tester) async {
    await _apriOggetti(tester);
    await _apriModale(tester);

    expect(_testoRicco(_descrizione), findsNothing);

    await tester.tap(find.text(_oggetto));
    await tester.pumpAndSettle();

    expect(_testoRicco('Descrizione: $_descrizione'), findsOneWidget);
  });

  testWidgets('di un oggetto la modale dice anche quanto costa', (
    tester,
  ) async {
    // Valore e Rarità ce l'hanno tutti, non solo le armi: servono a
    // decidere se è roba che il personaggio può procurarsi.
    final oggetto = oggettoDaNome(_oggetto)!;

    await _apriOggetti(tester);
    await _apriModale(tester);
    await _tocca(tester, find.text(_oggetto));

    expect(_testoRicco('Valore: ${oggetto.valore}'), findsOneWidget);
    expect(_testoRicco('Rarità: ${oggetto.rarita.label}'), findsOneWidget);
  });

  testWidgets('di un armatura la modale dice anche quanto costa', (
    tester,
  ) async {
    final armatura = listaArmature.first;

    await _apriOggetti(tester);
    await _apriModale(tester);
    await _cerca(tester, armatura.nome);
    await _tocca(tester, _nellaLista(armatura.nome));

    expect(_testoRicco('Valore: ${armatura.valore}'), findsOneWidget);
    expect(_testoRicco('Rarità: ${armatura.rarita.label}'), findsOneWidget);
  });

  testWidgets('di un arma la modale mostra i suoi campi', (tester) async {
    await _apriOggetti(tester);
    await _apriModale(tester);
    await _cerca(tester, _arma.nome);

    await tester.tap(_nellaLista(_arma.nome));
    await tester.pumpAndSettle();

    expect(_testoRicco('Danno: ${_arma.danno}'), findsOneWidget);
    expect(_testoRicco('Gittata: ${_arma.etichettaGittata}'), findsOneWidget);
  });

  testWidgets('il + aggiunge l oggetto e chiude la modale', (tester) async {
    final salvate = await _apriOggetti(tester);
    await _apriModale(tester);

    await tester.tap(find.byTooltip('Aggiungi $_oggetto'));
    await tester.pumpAndSettle();

    // La modale si è chiusa...
    expect(find.byType(AlertDialog), findsNothing);
    // ...e l'oggetto è finito in scheda, quantità 1.
    expect(salvate.last.equipaggiamento.oggetti, [_oggetto]);
    expect(find.text(_oggetto), findsOneWidget);
    expect(find.byTooltip('Aggiungi un $_oggetto'), findsOneWidget);
  });

  testWidgets('la pagina ha Influenza e Ricchezza in alto, sulla stessa riga', (
    tester,
  ) async {
    await _apriOggetti(tester);

    expect(find.text('Influenza'), findsOneWidget);
    expect(find.text('Ricchezza'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Influenza')).dy,
      tester.getTopLeft(find.text('Ricchezza')).dy,
      reason: 'stessa riga',
    );
    expect(
      tester.getTopLeft(find.text('Influenza')).dy,
      lessThan(
        tester
            .getTopLeft(find.widgetWithText(OutlinedButton, 'Aggiungi oggetto'))
            .dy,
      ),
      reason: 'stanno sopra al pulsante di aggiunta',
    );
  });

  testWidgets('l Influenza è la Socialità, non un numero a sé', (tester) async {
    // Influenza = Socialità: è derivata come Grinta e Fermezza, quindi
    // il numero in pagina è quello della Caratteristica e cambia con
    // lei invece di restare fermo a quello che era in partenza.
    await _apriOggetti(tester, socialita: 5);
    expect(_valoreSotto(tester, 'Influenza'), '5');

    await _apriOggetti(tester, socialita: 2);
    expect(_valoreSotto(tester, 'Influenza'), '2');
  });

  testWidgets('la Ricchezza si regola con - e +', (tester) async {
    final salvate = await _apriOggetti(tester);
    final partenza = salvate.isEmpty
        ? 0
        : salvate.last.equipaggiamento.ricchezza;

    await _tocca(tester, find.byTooltip('Aggiungi ricchezza'));
    expect(salvate.last.equipaggiamento.ricchezza, partenza + 1);

    await _tocca(tester, find.byTooltip('Togli ricchezza'));
    expect(salvate.last.equipaggiamento.ricchezza, partenza);
  });

  testWidgets('la Ricchezza non scende sotto zero', (tester) async {
    await _apriOggetti(tester);

    final meno = find
        .ancestor(
          of: find.byTooltip('Togli ricchezza'),
          matching: find.byType(IconButton),
        )
        .first;
    expect(tester.widget<IconButton>(meno).onPressed, isNull);
  });

  testWidgets('il + della riga aggiunge un altro dello stesso oggetto', (
    tester,
  ) async {
    final salvate = await _apriOggetti(tester, oggetti: [_oggetto]);

    await _tocca(tester, find.byTooltip('Aggiungi un $_oggetto'));

    expect(salvate.last.equipaggiamento.oggetti, [_oggetto, _oggetto]);
    expect(find.text(_oggetto), findsOneWidget, reason: 'sempre una riga');
    expect(find.text('2'), findsWidgets);
  });

  testWidgets('toccando il nome in scheda si aprono i dati dell oggetto', (
    tester,
  ) async {
    await _apriOggetti(tester, oggetti: [_oggetto]);

    await _tocca(tester, find.text(_oggetto));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(_testoRicco('Descrizione: $_descrizione'), findsOneWidget);
  });

  testWidgets('lo stesso oggetto preso due volte fa quantità 2', (
    tester,
  ) async {
    final salvate = await _apriOggetti(tester, oggetti: [_oggetto, _oggetto]);

    expect(find.text(_oggetto), findsOneWidget, reason: 'una riga sola');
    expect(find.text('2'), findsWidgets);

    // Il "-" ne toglie uno: resta la riga con quantità 1.
    await _tocca(tester, find.byTooltip('Togli un $_oggetto'));

    expect(salvate.last.equipaggiamento.oggetti, [_oggetto]);
    expect(find.text(_oggetto), findsOneWidget);
  });

  testWidgets('arrivata a zero la riga sparisce', (tester) async {
    final salvate = await _apriOggetti(tester, oggetti: [_oggetto]);

    await _tocca(tester, find.byTooltip('Togli un $_oggetto'));

    expect(salvate.last.equipaggiamento.oggetti, isEmpty);
    expect(find.text(_oggetto), findsNothing);
    expect(find.text('Nessun oggetto.'), findsOneWidget);
  });

  testWidgets('fra il pulsante e l inventario c è il titolo, centrato', (
    tester,
  ) async {
    await _apriOggetti(tester, oggetti: [_oggetto]);

    final titolo = find.text('Il Mio Inventario');
    expect(titolo, findsOneWidget);

    double alto(Finder f) => tester.getTopLeft(f).dy;
    final bottone = find.widgetWithText(OutlinedButton, 'Aggiungi oggetto');
    expect(alto(titolo), greaterThan(alto(bottone)));
    expect(alto(titolo), lessThan(alto(find.text(_oggetto))));

    // Centrato nella pagina.
    expect(
      tester.getCenter(titolo).dx,
      moreOrLessEquals(
        tester.view.physicalSize.width / tester.view.devicePixelRatio / 2,
        epsilon: 1,
      ),
    );
  });
}
