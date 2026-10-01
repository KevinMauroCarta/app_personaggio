// APP/Pagina/Creazione-PG: i controlli che impediscono di creare un
// personaggio non valido (campi obbligatori di Pagina 1 e 2, PE negativi),
// la sezione Talenti e Capacità di Pagina 2 e il legame fra Capacità
// Generiche e Poteri Psionici.
//
// Il Tag Psionico arriva quasi sempre da una Capacità Generica: se la si
// toglie, i poteri già scelti non spettano più al personaggio e i PE
// spesi devono tornare indietro.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/sistema.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show abilitaFuoriRegola;
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_page.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_widgets.dart'
    show CampoFissoConDettagli;

/// Razza e background che [_compilaPagina1] sceglie.
final _razza = listaRazze.firstWhere((r) => r.nome == 'Solari');
final _background = listaBackground.firstWhere(
  (b) => b.nome == 'Nato tra le Stelle',
);

/// Apre la tendina intestata [etichetta] e ne sceglie la voce [valore].
Future<void> _scegli(
  WidgetTester tester,
  String etichetta,
  String valore,
) async {
  final tendina = find
      .ancestor(
        of: find.text(etichetta),
        matching: find.byType(DropdownButtonFormField<String>),
      )
      .first;
  await tester.ensureVisible(tendina);
  await tester.pumpAndSettle();
  await tester.tap(tendina);
  await tester.pumpAndSettle();
  await tester.tap(find.text(valore).last);
  await tester.pumpAndSettle();
}

/// Le voci offerte dalla tendina intestata [etichetta].
List<String?> _vociTendina(WidgetTester tester, String etichetta) {
  final campo = find
      .ancestor(
        of: find.text(etichetta),
        matching: find.byType(DropdownButtonFormField<String>),
      )
      .first;
  final tendina = tester.widget<DropdownButton<String>>(
    find.descendant(of: campo, matching: find.byType(DropdownButton<String>)),
  );
  return tendina.items!.map((voce) => voce.value).toList();
}

/// Compila tutti i campi obbligatori di Pagina 1 e passa a Pagina 2.
///
/// Senza [sistema] sceglie il primo sistema del catalogo; il pianeta è
/// sempre il primo del sistema.
Future<void> _compilaPagina1(WidgetTester tester, {Sistema? sistema}) async {
  final sistemaScelto = sistema ?? listaSistemi.first;
  final pianetaScelto = sistemaScelto.pianeti.first;

  await tester.enterText(find.byType(TextField).first, 'Kaleb');
  await tester.pumpAndSettle();

  await _scegli(tester, 'Razza', _razza.nome);
  await tester.enterText(find.byType(TextField).last, '30');
  await tester.pumpAndSettle();
  await _scegli(tester, 'Genere', 'Maschio');
  await _scegli(tester, 'Background', _background.nome);
  await _scegli(tester, 'Sistema di origine', sistemaScelto.nome);
  await tester.pumpAndSettle();

  // Il pianeta compare solo dopo il sistema, ed è uno di quelli di quel
  // sistema.
  await _scegli(tester, 'Pianeta di origine', pianetaScelto.nome);

  await tester.tap(find.text('Avanti'));
  await tester.pumpAndSettle();
}

/// Compila i campi obbligatori di Pagina 2 - Talento e Capacità di
/// Razza, di Sistema e del Pianeta - per un personaggio passato da
/// [_compilaPagina1] senza argomenti.
Future<void> _compilaObbligatoriPagina2(WidgetTester tester) async {
  final sistema = listaSistemi.first;

  await _scegli(tester, 'Talento', listaTalenti.first.nome);
  await _scegli(tester, 'Capacità di Razza 1', _razza.capacita[0].nome);
  await _scegli(tester, 'Capacità di Razza 2', _razza.capacita[1].nome);
  await _scegli(
    tester,
    'Capacità di Sistema',
    sistema.capacitaDelSistema.first.nome,
  );
  await _scegli(
    tester,
    'Capacità del Pianeta',
    sistema.pianeti.first.capacitaDelPianeta.first.nome,
  );
}

/// I PE letti dalla barra in fondo a Pagina 2.
int _peDisponibili(WidgetTester tester) {
  final testo = tester
      .widgetList<Text>(find.textContaining('Punti Esperienza disponibili:'))
      .first
      .data!;
  return int.parse(testo.split(':').last.trim());
}

/// Porta in vista e tocca: le pagine sono più lunghe dello schermo, e un
/// tocco su un widget fuori schermo non arriva a destinazione.
Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Alza di [passi] punti l'Abilità [nome] con il bottone "+".
Future<void> _alzaAbilita(WidgetTester tester, String nome, int passi) async {
  final riga = find
      .ancestor(of: find.textContaining(nome), matching: find.byType(Row))
      .first;
  final piu = find.descendant(
    of: riga,
    matching: find.byIcon(Icons.add_circle_outline),
  );
  for (var i = 0; i < passi; i++) {
    await tester.ensureVisible(piu);
    await tester.pumpAndSettle();
    await tester.tap(piu);
    await tester.pumpAndSettle();
  }
}

void main() {
  test('le abilità fuori regola sono quelle segnate in rosso', () {
    // Avanzamento/Abilità: per portare un'abilità a x servono almeno x
    // abilità apprese (Valore Base >= 1), quella compresa.
    expect(abilitaFuoriRegola({'Atletica': 1, 'Mira': 0}), isEmpty);
    expect(abilitaFuoriRegola({'Atletica': 2, 'Mira': 1}), isEmpty);
    expect(abilitaFuoriRegola({'Atletica': 2, 'Mira': 0}), ['Atletica']);
    expect(abilitaFuoriRegola({'Atletica': 3, 'Mira': 3}), [
      'Atletica',
      'Mira',
    ]);
  });

  testWidgets('senza i campi obbligatori non si passa a Pagina 2', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));

    await tester.tap(find.text('Avanti'));
    await tester.pumpAndSettle();

    // L'avviso dice quali campi mancano, e la pagina resta la prima.
    expect(find.textContaining('Compila prima:'), findsOneWidget);
    expect(find.textContaining('Nome personaggio'), findsWidgets);
    expect(find.text('Avanti'), findsOneWidget);
  });

  testWidgets('a 361 punti Pagina 2 non va in overflow', (tester) async {
    // La barra dei Punti Esperienza sta su una riga sola con il suo
    // tasto: su uno schermo stretto è il pezzo che rischia di non
    // starci.
    tester.view.physicalSize = const Size(361, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('con tutti i campi compilati si passa a Pagina 2', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    expect(find.text('Caratteristiche'), findsWidgets);
  });

  testWidgets('con un abilità in rosso il personaggio non si crea', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);
    await _compilaObbligatoriPagina2(tester);

    // Atletica a 2 con una sola abilità appresa è fuori regola: la
    // riga diventa rossa, ma finora si poteva salvare lo stesso.
    await _alzaAbilita(tester, 'Atletica', 2);

    await _tocca(tester, find.text('Riepilogo'));
    await _tocca(tester, find.text('CREA'));

    expect(find.textContaining('Abilità oltre il limite'), findsOneWidget);
    expect(find.textContaining('Atletica'), findsWidgets);
    // Il personaggio non è stato creato: la pagina è ancora aperta.
    expect(find.text('CREA'), findsOneWidget);
  });

  testWidgets(
    'togliendo la capacità psionica i poteri spariscono e i PE tornano',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
      await _compilaPagina1(tester);

      final potere = listaPoteriPsionici.first;
      final pePrima = _peDisponibili(tester);

      // Una Capacità Generica porta il tag Psionico...
      await _scegli(tester, 'Capacità Generica 1', 'Addestramento Psichico');
      // ...e da lì si può comprare un potere, che costa.
      await _scegli(tester, 'Potere Psionico 1', potere.nome);
      expect(find.text(potere.nome), findsWidgets);
      expect(_peDisponibili(tester), lessThan(pePrima));

      // Togliendo la capacità il potere non spetta più: sparisce dal
      // campo e il suo costo torna indietro.
      final rimuovi = find
          .ancestor(
            of: find.text('Capacità Generica 1'),
            matching: find.byType(Row),
          )
          .first;
      await tester.tap(
        find.descendant(of: rimuovi, matching: find.byIcon(Icons.close)),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(potere.nome),
        findsNothing,
        reason: 'il potere non doveva restare selezionato',
      );
      // È questa la prova che lo stato è stato ripulito davvero e non
      // solo nascosto: i PE del potere e della capacità sono tornati.
      expect(
        _peDisponibili(tester),
        pePrima,
        reason: 'i PE spesi in capacità e poteri dovevano tornare',
      );
    },
  );

  testWidgets('Talento e Capacità stanno in una sezione sola, senza titoli', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    expect(find.text('Talenti e Capacità'), findsOneWidget);
    // Ogni nome compare una volta sola: è l'etichetta del campo, senza
    // più un titolo uguale sopra.
    for (final campo in [
      'Talento',
      'Capacità di Razza 1',
      'Capacità di Razza 2',
      'Capacità di Sistema',
      'Capacità del Pianeta',
      'Capacità di Background',
      'Capacità Generica 1',
    ]) {
      expect(find.text(campo), findsOneWidget, reason: campo);
    }
  });

  testWidgets('senza Talento e Capacità obbligatorie non si va al Riepilogo', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    await _tocca(tester, find.text('Riepilogo'));

    // La Capacità di Background non manca mai: è già presa.
    expect(
      find.text(
        'Compila prima: Talento, Capacità di Razza 1, Capacità di Razza 2, '
        'Capacità di Sistema, Capacità del Pianeta',
      ),
      findsOneWidget,
    );
    // Si resta in Pagina 2: il bottone CREA sta nel Riepilogo.
    expect(find.text('CREA'), findsNothing);
  });

  testWidgets('la Capacità di Background è già presa e ha le sue info', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    final capacita = _background.capacitaDiBackground;
    final campo = find.byType(CampoFissoConDettagli);

    // Compilata da sé, e non è una tendina: non c'è niente da scegliere.
    expect(
      find.descendant(of: campo, matching: find.text(capacita.nome)),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text('Capacità di Background'),
        matching: find.byType(DropdownButtonFormField<String>),
      ),
      findsNothing,
    );

    // Il Pulsante Info a fianco ne mostra la scheda.
    await _tocca(
      tester,
      find.descendant(of: campo, matching: find.byIcon(Icons.info_outline)),
    );
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text('Effetto: ${capacita.effetto}', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('le due Capacità di Razza non possono essere la stessa', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    final prima = _razza.capacita[0].nome;
    final seconda = _razza.capacita[1].nome;
    await _scegli(tester, 'Capacità di Razza 1', prima);

    final vociSeconda = _vociTendina(tester, 'Capacità di Razza 2');
    expect(vociSeconda, isNot(contains(prima)));
    expect(vociSeconda, contains(seconda));
  });

  testWidgets('il personaggio creato ha tutte le capacità, senza pagarle', (
    tester,
  ) async {
    Personaggio? creato;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              creato = await Navigator.of(context).push<Personaggio>(
                MaterialPageRoute(
                  builder: (_) => const CharacterCreationPage(),
                ),
              );
            },
            child: const Text('Apri'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Apri'));
    await tester.pumpAndSettle();

    await _compilaPagina1(tester);
    final pePrima = _peDisponibili(tester);
    await _compilaObbligatoriPagina2(tester);
    expect(
      _peDisponibili(tester),
      pePrima,
      reason: 'le capacità di razza, sistema e pianeta non si pagano',
    );

    await _tocca(tester, find.text('Riepilogo'));
    expect(find.text('Talenti e Capacità'), findsOneWidget);
    await _tocca(tester, find.text('CREA'));

    final sistema = listaSistemi.first;
    expect(creato, isNotNull, reason: 'il personaggio doveva essere creato');
    expect(creato!.talenti.map((t) => t.nome), [listaTalenti.first.nome]);
    // Nell'ordine dei campi: è quello su cui conta la Modifica.
    expect(creato!.capacita.map((c) => c.nome), [
      _razza.capacita[0].nome,
      _razza.capacita[1].nome,
      sistema.capacitaDelSistema.first.nome,
      sistema.pianeti.first.capacitaDelPianeta.first.nome,
      _background.capacitaDiBackground.nome,
    ]);
  });

  testWidgets('una Generica presa come Capacità di Sistema non costa PE', (
    tester,
  ) async {
    // Alcuni sistemi offrono Addestramento Psichico, che comprata come
    // Generica costa: presa dal sistema no, arriva con la nascita.
    final sistema = listaSistemi.firstWhere(
      (s) => s.capacitaDelSistema.any((c) => c.tipo == TipoCapacita.generica),
    );
    final capacita = sistema.capacitaDelSistema.firstWhere(
      (c) => c.tipo == TipoCapacita.generica,
    );
    expect(capacita.costo, greaterThan(0));

    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester, sistema: sistema);

    final pePrima = _peDisponibili(tester);
    await _scegli(tester, 'Capacità di Sistema', capacita.nome);

    expect(_peDisponibili(tester), pePrima);
  });

  testWidgets('la Capacità del Pianeta si sceglie fra le tre del pianeta', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await _compilaPagina1(tester);

    // Quella della tipologia e le due apprese sul pianeta, e nessuna di
    // quelle del sistema.
    final pianeta = listaSistemi.first.pianeti.first;
    expect(
      _vociTendina(tester, 'Capacità del Pianeta'),
      pianeta.capacitaDelPianeta.map((c) => c.nome).toList(),
    );
  });
}
