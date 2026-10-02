// APP/Pagina/Scheda, pagina Punk (nome provvisorio): gli Impianti.
//
// Chip Neurali e Protesi (Sostitutivi ed Esoscheletri): il modello, il
// salvataggio con la Scheda, i dati segnaposto e la pagina, dove si
// aggiungono dalla stessa modale di ricerca di Equip e Oggetti.
//
// I dati di prova sono presi dai cataloghi, non scritti a mano: sono
// segnaposto e cambieranno.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/data/lista_chip_neurali.dart';
import 'package:app_personaggio/data/lista_oggetti.dart';
import 'package:app_personaggio/data/lista_protesi.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/bersaglio.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/parte_corpo.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/enums/tipo_protesi.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/impianti.dart';
import 'package:app_personaggio/models/modificatore.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show capacitaGenericheOptions;
import 'package:app_personaggio/screens/scheda/criteri_catalogo.dart';
import 'package:app_personaggio/screens/scheda/dialog_scelta_catalogo.dart';
import 'package:app_personaggio/screens/scheda/scheda_dati.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';
import 'package:app_personaggio/services/effetti_personaggio.dart';

import 'linguette_scheda.dart';

/// Il primo dei [modificatori] che tocca una voce di [categoria], null se
/// non ce n'è.
Modificatore? _di(
  List<Modificatore> modificatori,
  CategoriaBersaglio categoria,
) {
  for (final m in modificatori) {
    if (m.bersaglio.categoria == categoria) return m;
  }
  return null;
}

final _chip = listaChipNeurali.first;
final _sostitutivo = listaProtesi.firstWhere(
  (p) => p.tipo == TipoProtesi.sostitutivo,
);
final _esoscheletro = listaProtesi.firstWhere(
  (p) => p.tipo == TipoProtesi.esoscheletro,
);

Scheda _scheda({
  Impianti impianti = const Impianti(),
  List<String> oggetti = const [],
}) {
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
    impianti: impianti,
    equipaggiamento: Equipaggiamento(oggetti: oggetti),
  );
}

/// Apre la Scheda sulla pagina Punk e raccoglie le schede salvate.
Future<List<Scheda>> _apriPunk(
  WidgetTester tester, {
  Impianti impianti = const Impianti(),
  List<String> oggetti = const [],
}) async {
  // Uno schermo da telefono: la modale prende una parte dell'altezza.
  tester.view.physicalSize = const Size(400, 850);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(impianti: impianti, oggetti: oggetti),
        onModificata: salvate.add,
      ),
    ),
  );
  await vaiAllaPagina(tester, 'Punk');
  return salvate;
}

Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Apre la modale con [pulsante] e aggiunge [nome] dal suo "+".
Future<void> _aggiungi(
  WidgetTester tester,
  String pulsante,
  String nome,
) async {
  await _tocca(tester, find.widgetWithText(OutlinedButton, pulsante));
  // L'elenco della modale costruisce solo le righe in vista: una voce in
  // fondo va raggiunta scorrendo.
  final voce = find.byTooltip('Aggiungi $nome');
  await tester.scrollUntilVisible(
    voce,
    100,
    scrollable: find
        .descendant(
          of: find.byType(DialogSceltaCatalogo),
          matching: find.byType(Scrollable),
        )
        .last,
  );
  await _tocca(tester, voce);
}

void main() {
  group('modello', () {
    test('chip e protesi sopravvivono al salvataggio della Scheda', () {
      final scheda = _scheda(
        impianti: Impianti(
          chipNeurali: [_chip],
          protesi: [_sostitutivo, _esoscheletro],
        ),
      );

      final riletta = Scheda.fromJson(scheda.toJson()).impianti;

      expect(riletta.chipNeurali.single.nome, _chip.nome);
      expect(
        riletta.chipNeurali.single.modificatori.map((m) => m.testo),
        _chip.modificatori.map((m) => m.testo),
      );
      expect(riletta.protesi.map((p) => p.nome), [
        _sostitutivo.nome,
        _esoscheletro.nome,
      ]);
      expect(riletta.protesi.first.parte, _sostitutivo.parte);
      expect(riletta.protesi.last.tipo, TipoProtesi.esoscheletro);
    });

    test('una scheda salvata prima degli Impianti parte senza', () {
      final json = _scheda().toJson()..remove('impianti');

      final impianti = Scheda.fromJson(json).impianti;

      expect(impianti.chipNeurali, isEmpty);
      expect(impianti.protesi, isEmpty);
    });

    test('le Protesi si dividono in Sostitutivi ed Esoscheletri', () {
      final impianti = Impianti(protesi: listaProtesi);

      expect(
        impianti.sostitutivi.every((p) => p.tipo == TipoProtesi.sostitutivo),
        isTrue,
      );
      expect(
        impianti.esoscheletri.every((p) => p.tipo == TipoProtesi.esoscheletro),
        isTrue,
      );
      expect(
        impianti.sostitutivi.length + impianti.esoscheletri.length,
        listaProtesi.length,
      );
    });
  });

  group('dati segnaposto', () {
    final nomiCaratteristiche = listaCaratteristiche.map((c) => c.nome).toSet();
    final nomiAbilita = listaAbilita.map((a) => a.nome).toSet();

    test('ci sono chip, sostitutivi ed esoscheletri da provare', () {
      expect(listaChipNeurali, isNotEmpty);
      expect(Impianti(protesi: listaProtesi).sostitutivi, isNotEmpty);
      expect(Impianti(protesi: listaProtesi).esoscheletri, isNotEmpty);
    });

    // Un Modificatore che punta a un nome inesistente non darebbe niente
    // nel Valore Bonus, senza che niente lo segnali.
    test('i Modificatori puntano a Caratteristiche e Abilità vere', () {
      final impianti = [
        for (final c in listaChipNeurali) (c.nome, c.modificatori),
        for (final p in listaProtesi) (p.nome, p.modificatori),
      ];
      for (final (nome, modificatori) in impianti) {
        for (final m in modificatori) {
          switch (m.bersaglio.categoria) {
            case CategoriaBersaglio.caratteristica:
              expect(nomiCaratteristiche, contains(m.bersaglio.label));
            case CategoriaBersaglio.abilita:
              expect(nomiAbilita, contains(m.bersaglio.label), reason: nome);
            case CategoriaBersaglio.scheda:
              break;
          }
        }
      }
    });

    test('l Effetto cita i Modificatori', () {
      for (final (nome, effetto, modificatori) in [
        for (final c in listaChipNeurali) (c.nome, c.effetto, c.modificatori),
        for (final p in listaProtesi) (p.nome, p.effetto, p.modificatori),
      ]) {
        for (final m in modificatori) {
          expect(effetto, contains(m.testo), reason: nome);
        }
      }
    });

    // datiOggetto e la modale trovano una voce dal nome: due voci con lo
    // stesso nome in cataloghi diversi si confonderebbero.
    test('nessun nome si ripete fra i cataloghi', () {
      final nomi = [
        ...listaOggetti.map((o) => o.nome),
        ...listaArmi.map((a) => a.nome),
        ...listaArmature.map((a) => a.nome),
        ...listaChipNeurali.map((c) => c.nome),
        ...listaProtesi.map((p) => p.nome),
      ];
      expect(nomi.toSet().length, nomi.length);
    });
  });

  group('ricerca', () {
    // Come per Oggetti, Armi e Armature: ogni dato mostrato aprendo la
    // voce ha il suo criterio, e cercando il valore la voce si trova.
    void cercabileOgniDato(
      List<String> opzioni,
      List<CriterioCatalogo> criteri, {
      Set<String> esclusi = const {},
    }) {
      for (final nome in opzioni) {
        for (final dato in datiOggetto(nome).entries) {
          if (esclusi.contains(dato.key)) continue;
          final criterio = criteri
              .where((c) => c.etichetta == dato.key)
              .firstOrNull;
          expect(criterio, isNotNull, reason: 'manca "${dato.key}"');
          if (dato.value == '-') continue;
          final valore = dato.value.split(', ').first;
          expect(criterio!.corrisponde(nome, valore), isTrue, reason: nome);
          if (criterio.aScelta) {
            expect(criterio.valoriPossibili(opzioni), contains(valore));
          }
        }
      }
    }

    // Il Tipo di un chip è sempre "Chip Neurale": cercarlo non
    // restringerebbe niente.
    test('nei Chip Neurali si cerca per qualunque dato tranne il Tipo', () {
      cercabileOgniDato(
        chipNeuraliOptions,
        criteriChipNeurali,
        esclusi: {'Tipo'},
      );
    });

    test('nelle Protesi si cerca per qualunque dato', () {
      cercabileOgniDato(protesiOptions, criteriProtesi);
    });
  });

  group('pagina', () {
    testWidgets('Equip, Punk e Oggetti sono le ultime tre linguette', (
      tester,
    ) async {
      await _apriPunk(tester);

      double x(String nome) => tester.getTopLeft(linguetta(nome)).dx;
      // Equip viene subito prima di Punk, che viene subito prima di
      // Oggetti; e Stato, che prima stava dopo Equip, ora sta prima.
      expect(x('Stato'), lessThan(x('Equip')));
      expect(x('Equip'), lessThan(x('Punk')));
      expect(x('Punk'), lessThan(x('Oggetti')));
      expect(x('Poteri'), lessThan(x('Stato')));
    });

    testWidgets('la pagina ha le due sezioni, vuote', (tester) async {
      await _apriPunk(tester);

      expect(find.text('Chip Neurali'), findsOneWidget);
      expect(find.text('Protesi'), findsOneWidget);
      expect(find.text('Sostitutivi'), findsOneWidget);
      expect(find.text('Esoscheletri'), findsOneWidget);
      expect(find.text('Nessun chip neurale.'), findsOneWidget);
      expect(find.text('Nessun sostitutivo.'), findsOneWidget);
      expect(find.text('Nessun esoscheletro.'), findsOneWidget);
    });

    testWidgets('un chip si installa dalla modale e la X lo manda in Oggetti', (
      tester,
    ) async {
      final salvate = await _apriPunk(tester);

      await _aggiungi(tester, 'Aggiungi chip neurale', _chip.nome);

      expect(find.byType(AlertDialog), findsNothing);
      expect(salvate.last.impianti.chipNeurali.single.nome, _chip.nome);
      expect(find.text(_chip.nome), findsOneWidget);
      expect(find.text('Nessun chip neurale.'), findsNothing);

      await _tocca(tester, find.byTooltip('Disinstalla ${_chip.nome}'));

      // Disinstallato non sparisce: è fra gli Oggetti.
      expect(salvate.last.impianti.chipNeurali, isEmpty);
      expect(salvate.last.equipaggiamento.oggetti, [_chip.nome]);
      expect(find.text('Nessun chip neurale.'), findsOneWidget);
    });

    testWidgets('ogni protesi finisce sotto il suo tipo', (tester) async {
      // Un esoscheletro leggero: con la Resistenza 3 della scheda di prova
      // il Sostitutivo (Carico 2) lascia un solo punto libero.
      final leggero = listaProtesi.firstWhere(
        (p) => p.tipo == TipoProtesi.esoscheletro && p.carico == 1,
      );
      final salvate = await _apriPunk(tester);

      await _aggiungi(tester, 'Aggiungi protesi', _sostitutivo.nome);
      await _aggiungi(tester, 'Aggiungi protesi', leggero.nome);

      expect(salvate.last.impianti.protesi.map((p) => p.nome), [
        _sostitutivo.nome,
        leggero.nome,
      ]);

      // Il sostitutivo fra "Sostitutivi" ed "Esoscheletri", l'esoscheletro
      // sotto "Esoscheletri".
      double y(Finder f) => tester.getTopLeft(f).dy;
      final sostitutivi = y(find.text('Sostitutivi'));
      final esoscheletri = y(find.text('Esoscheletri'));
      expect(y(find.text(_sostitutivo.nome)), greaterThan(sostitutivi));
      expect(y(find.text(_sostitutivo.nome)), lessThan(esoscheletri));
      expect(y(find.text(leggero.nome)), greaterThan(esoscheletri));
    });

    testWidgets('la stessa protesi si può avere due volte', (tester) async {
      // Di Carico 1, così due stanno nella Resistenza 3.
      final leggera = listaProtesi.firstWhere((p) => p.carico == 1);
      final salvate = await _apriPunk(tester);

      await _aggiungi(tester, 'Aggiungi protesi', leggera.nome);
      await _aggiungi(tester, 'Aggiungi protesi', leggera.nome);

      expect(salvate.last.impianti.protesi, hasLength(2));
      expect(find.text(leggera.nome), findsNWidgets(2));
    });

    testWidgets(
      'sotto il nome: parte del corpo, Carico, Modificatori e Capacità',
      (tester) async {
        await _apriPunk(tester, impianti: Impianti(protesi: [_esoscheletro]));

        final atteso = [
          _esoscheletro.parte.label,
          'Carico ${_esoscheletro.carico}',
          ..._esoscheletro.modificatori.map((m) => m.testo),
          if (_esoscheletro.capacita != null)
            'Capacità: ${_esoscheletro.capacita!.nome}',
        ].join(' · ');
        expect(find.text(atteso), findsOneWidget);
      },
    );

    testWidgets('toccando il nome si aprono tutti i dati', (tester) async {
      await _apriPunk(tester, impianti: Impianti(chipNeurali: [_chip]));

      await _tocca(tester, find.text(_chip.nome));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Effetto: ${_chip.effetto}'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('nella modale delle protesi si filtra per parte del corpo', (
      tester,
    ) async {
      await _apriPunk(tester);
      await _tocca(
        tester,
        find.widgetWithText(OutlinedButton, 'Aggiungi protesi'),
      );

      // "Cerca per" -> Parte del Corpo, poi la parte dalla tendina.
      await _tocca(
        tester,
        find.ancestor(
          of: find.text('Cerca per'),
          matching: find.byType(DropdownButtonFormField<CriterioCatalogo>),
        ),
      );
      await tester.tap(find.text('Parte del Corpo').last);
      await tester.pumpAndSettle();

      await _tocca(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(DropdownButtonFormField<String>),
        ),
      );
      await tester.tap(find.text(_esoscheletro.parte.label).last);
      await tester.pumpAndSettle();
      await _tocca(
        tester,
        find.widgetWithText(FilledButton, 'Aggiungi filtro'),
      );

      final attese = listaProtesi.where((p) => p.parte == _esoscheletro.parte);
      for (final p in attese) {
        expect(find.byTooltip('Aggiungi ${p.nome}'), findsOneWidget);
      }
      final altre = listaProtesi.where((p) => p.parte != _esoscheletro.parte);
      for (final p in altre) {
        expect(find.byTooltip('Aggiungi ${p.nome}'), findsNothing);
      }
    });
  });

  group('i Modificatori funzionano', () {
    // Presi per il loro Modificatore, non per nome: sono segnaposto.
    final chipCaratteristica = listaChipNeurali.firstWhere(
      (c) => _di(c.modificatori, CategoriaBersaglio.caratteristica) != null,
    );
    final chipAbilita = listaChipNeurali.firstWhere(
      (c) => _di(c.modificatori, CategoriaBersaglio.abilita) != null,
    );
    final esoscheletroCaratteristica = listaProtesi.firstWhere(
      (p) =>
          p.tipo == TipoProtesi.esoscheletro &&
          _di(p.modificatori, CategoriaBersaglio.caratteristica) != null,
    );

    int caratteristica(Scheda s, String nome) => s.personaggio.caratteristiche
        .firstWhere((c) => c.caratteristica.nome == nome)
        .valoreTotale;

    int bonusAbilitaDi(Scheda s, String nome) => s.personaggio.abilita
        .firstWhere((a) => a.abilita.nome == nome)
        .valoreBonus;

    test('il bonus conta chip e protesi', () {
      final m = _di(
        chipCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      final e = _di(
        esoscheletroCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      final a = _di(chipAbilita.modificatori, CategoriaBersaglio.abilita)!;
      final impianti = Impianti(
        chipNeurali: [chipCaratteristica, chipAbilita],
        protesi: [esoscheletroCaratteristica],
      );

      expect(
        bonusCaratteristica(
          m.bersaglio.label,
          capacita: const [],
          impianti: impianti,
        ),
        m.valore + (e.bersaglio.label == m.bersaglio.label ? e.valore : 0),
      );
      expect(
        bonusCaratteristica(
          e.bersaglio.label,
          capacita: const [],
          impianti: impianti,
        ),
        e.valore + (e.bersaglio.label == m.bersaglio.label ? m.valore : 0),
      );
      expect(
        bonusAbilita(a.bersaglio.label, capacita: const [], impianti: impianti),
        a.valore,
      );
      // Senza impianti, niente.
      expect(bonusCaratteristica(m.bersaglio.label, capacita: const []), 0);
    });

    test('dopo Modifica o Aumento i bonus degli impianti restano', () {
      // Modifica e Aumento ricalcolano senza impianti: il personaggio che
      // tornano ha bonus zero. La Home lo rimette nella scheda passando
      // da conEffettiRicalcolati con gli impianti della scheda.
      final m = _di(
        chipCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      final senza = _scheda().personaggio;

      final con = conEffettiRicalcolati(
        senza,
        impianti: Impianti(chipNeurali: [chipCaratteristica]),
      );

      int totale(Personaggio p) => p.caratteristiche
          .firstWhere((c) => c.caratteristica.nome == m.bersaglio.label)
          .valoreTotale;
      expect(totale(con), totale(senza) + m.valore);
      // Il resto del personaggio non cambia.
      expect(con.nome, senza.nome);
      expect(con.pxDisponibili, senza.pxDisponibili);
    });

    testWidgets('installare un chip alza la Caratteristica, toglierlo no', (
      tester,
    ) async {
      final m = _di(
        chipCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      final salvate = await _apriPunk(tester);
      final prima = caratteristica(_scheda(), m.bersaglio.label);

      await _aggiungi(tester, 'Aggiungi chip neurale', chipCaratteristica.nome);
      expect(caratteristica(salvate.last, m.bersaglio.label), prima + m.valore);

      await _tocca(
        tester,
        find.byTooltip('Disinstalla ${chipCaratteristica.nome}'),
      );
      expect(caratteristica(salvate.last, m.bersaglio.label), prima);
    });

    testWidgets('un chip d Abilità alza l Abilità', (tester) async {
      final a = _di(chipAbilita.modificatori, CategoriaBersaglio.abilita)!;
      final salvate = await _apriPunk(tester);

      await _aggiungi(tester, 'Aggiungi chip neurale', chipAbilita.nome);

      expect(bonusAbilitaDi(salvate.last, a.bersaglio.label), a.valore);
    });

    testWidgets('un esoscheletro alza la Caratteristica', (tester) async {
      final e = _di(
        esoscheletroCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      final salvate = await _apriPunk(tester);
      final prima = caratteristica(_scheda(), e.bersaglio.label);

      await _aggiungi(
        tester,
        'Aggiungi protesi',
        esoscheletroCaratteristica.nome,
      );

      expect(caratteristica(salvate.last, e.bersaglio.label), prima + e.valore);
    });

    testWidgets('il bonus si vede nella pagina Abilità', (tester) async {
      // Il chip è già installato all'apertura: la scheda salvata non ha
      // ancora il bonus, ma la pagina lo ricalcola.
      final m = _di(
        chipCaratteristica.modificatori,
        CategoriaBersaglio.caratteristica,
      )!;
      await _apriPunk(
        tester,
        impianti: Impianti(chipNeurali: [chipCaratteristica]),
      );
      await vaiAllaPagina(tester, 'Abilità');

      // La prima volta che compare il nome è la riga della tabella
      // Caratteristiche (Caratteristica, Totale, Base, Bonus); dopo
      // torna come titolo dei gruppi di Abilità.
      final riga = find
          .ancestor(
            of: find.text(m.bersaglio.label).first,
            matching: find.byType(Row),
          )
          .first;
      final celle = tester
          .widgetList<Text>(
            find.descendant(of: riga, matching: find.byType(Text)),
          )
          .map((t) => t.data)
          .toList();
      final base = caratteristica(_scheda(), m.bersaglio.label);
      expect(celle, [
        m.bersaglio.label,
        '${base + m.valore}',
        '$base',
        '${m.valore}',
      ]);
    });
  });

  group('Carico degli impianti', () {
    // La scheda di prova ha tutte le Caratteristiche a 3: Volontà e
    // Resistenza reggono 3 punti di Carico ciascuna.
    final leggero = listaChipNeurali.firstWhere((c) => c.carico == 1);
    final pesante = listaChipNeurali.firstWhere((c) => c.carico == 2);

    test('ogni impianto ha Carico da 1 a 3', () {
      for (final (nome, carico) in [
        for (final c in listaChipNeurali) (c.nome, c.carico),
        for (final p in listaProtesi) (p.nome, p.carico),
      ]) {
        expect(carico, inInclusiveRange(1, 3), reason: nome);
      }
    });

    test('nessun impianto tocca Volontà o Resistenza', () {
      // Sono i limiti del Carico: un impianto che li alzasse si
      // allargherebbe il posto da solo.
      for (final (nome, modificatori) in [
        for (final c in listaChipNeurali) (c.nome, c.modificatori),
        for (final p in listaProtesi) (p.nome, p.modificatori),
      ]) {
        for (final m in modificatori) {
          expect(
            m.bersaglio,
            isNot(anyOf(Bersaglio.volonta, Bersaglio.resistenza)),
            reason: nome,
          );
        }
      }
    });

    test('il Carico si somma per tipo', () {
      final impianti = Impianti(
        chipNeurali: [leggero, pesante],
        protesi: [_sostitutivo],
      );
      expect(impianti.caricoChip, leggero.carico + pesante.carico);
      expect(impianti.caricoProtesi, _sostitutivo.carico);
    });

    test('il limite è Volontà per i chip e Resistenza per le protesi', () {
      expect(_scheda().limiteCaricoChip, 3);
      expect(_scheda().limiteCaricoProtesi, 3);

      final occupata = _scheda(impianti: Impianti(chipNeurali: [pesante]));
      expect(occupata.entraChip(leggero), isTrue, reason: '2 + 1 = 3');
      expect(occupata.entraChip(pesante), isFalse, reason: '2 + 2 = 4');
      // Le protesi hanno il loro limite: i chip non lo toccano.
      expect(occupata.entraProtesi(_sostitutivo), isTrue);
    });

    testWidgets('ogni sezione mostra il suo Carico', (tester) async {
      await _apriPunk(tester);
      expect(find.text('Carico (limite: Volontà)'), findsOneWidget);
      expect(find.text('Carico (limite: Resistenza)'), findsOneWidget);
      expect(find.text('0/3'), findsNWidgets(2));

      await _aggiungi(tester, 'Aggiungi chip neurale', pesante.nome);
      expect(find.text('2/3'), findsOneWidget);

      await _tocca(tester, find.byTooltip('Disinstalla ${pesante.nome}'));
      expect(find.text('0/3'), findsNWidgets(2));
    });

    testWidgets('nella modale quello che non entra è spento, col motivo', (
      tester,
    ) async {
      final salvate = await _apriPunk(
        tester,
        impianti: Impianti(chipNeurali: [pesante]),
      );
      await _tocca(
        tester,
        find.widgetWithText(OutlinedButton, 'Aggiungi chip neurale'),
      );

      // Quelli da 2 non entrano nel punto rimasto: niente "Aggiungi",
      // al suo posto il motivo.
      expect(find.byTooltip('Aggiungi ${pesante.nome}'), findsNothing);
      expect(find.text('Carico 2, liberi 1'), findsWidgets);

      // Uno da 1 invece entra.
      await _tocca(tester, find.byTooltip('Aggiungi ${leggero.nome}'));
      expect(salvate.last.impianti.caricoChip, 3);
    });

    testWidgets('oltre il limite il Carico è rosso e lo dice', (tester) async {
      // Il limite può scendere dopo: qui Volontà 3 con 4 di Carico.
      await _apriPunk(
        tester,
        impianti: Impianti(chipNeurali: [pesante, pesante]),
      );

      expect(find.text('4/3'), findsOneWidget);
      expect(find.textContaining('Oltre il limite'), findsOneWidget);
    });
  });

  group('equipaggiato o negli Oggetti', () {
    test('gli impianti si trovano nella modale degli Oggetti', () {
      expect(oggettiOptions, containsAll([_chip.nome, _sostitutivo.nome]));
    });

    testWidgets('dagli Oggetti un impianto si installa', (tester) async {
      final salvate = await _apriPunk(tester, oggetti: [_chip.nome]);
      await vaiAllaPagina(tester, 'Oggetti');

      await _tocca(tester, find.byTooltip('Installa ${_chip.nome}'));

      // Passa dagli Oggetti agli Impianti.
      expect(salvate.last.equipaggiamento.oggetti, isEmpty);
      expect(salvate.last.impianti.chipNeurali.single.nome, _chip.nome);
    });

    testWidgets('gli oggetti normali non hanno Installa', (tester) async {
      final oggetto = listaOggetti.first.nome;
      await _apriPunk(tester, oggetti: [oggetto]);
      await vaiAllaPagina(tester, 'Oggetti');

      expect(find.byTooltip('Installa $oggetto'), findsNothing);
    });

    testWidgets('dagli Oggetti non si installa quello che non entra', (
      tester,
    ) async {
      // Resistenza 3, già occupata da una protesi di Carico 2: una da 2
      // non entra più.
      final altra = listaProtesi.firstWhere(
        (p) => p.carico == 2 && p.nome != _sostitutivo.nome,
      );
      await _apriPunk(
        tester,
        impianti: Impianti(protesi: [_sostitutivo]),
        oggetti: [altra.nome],
      );
      await vaiAllaPagina(tester, 'Oggetti');

      final installa = find.byTooltip('Carico 2, liberi 1');
      expect(installa, findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
              find.ancestor(of: installa, matching: find.byType(IconButton)),
            )
            .onPressed,
        isNull,
      );
    });
  });

  group('Capacità da Impianto', () {
    final concedente = listaProtesi.firstWhere((p) => p.capacita != null);
    final capacita = concedente.capacita!;

    test('si ottengono solo dagli impianti', () {
      final daImpianto = listaCapacita.where(
        (c) => c.tipo == TipoCapacita.impianto,
      );
      expect(daImpianto, isNotEmpty);
      final concesse = [
        ...listaChipNeurali.map((i) => i.capacita?.nome),
        ...listaProtesi.map((i) => i.capacita?.nome),
      ];
      for (final c in daImpianto) {
        // Non si comprano: non sono fra le Generiche che Creazione e
        // Aumento offrono, e non costano PE.
        expect(capacitaGenericheOptions, isNot(contains(c.nome)));
        expect(c.costo, 0, reason: c.nome);
        // E qualche impianto le concede davvero.
        expect(
          concesse,
          contains(c.nome),
          reason: '"${c.nome}" non è concessa da nessun impianto',
        );
      }
    });

    test('gli impianti concedono solo Capacità da Impianto', () {
      final concesse = [
        ...listaChipNeurali.map((i) => i.capacita),
        ...listaProtesi.map((i) => i.capacita),
      ].whereType<Capacita>();
      for (final c in concesse) {
        expect(c.tipo, TipoCapacita.impianto, reason: c.nome);
      }
    });

    test('la capacità si salva con l impianto', () {
      final scheda = _scheda(impianti: Impianti(protesi: [concedente]));
      final riletta = Scheda.fromJson(scheda.toJson()).impianti;
      expect(riletta.protesi.single.capacita?.nome, capacita.nome);
      expect(riletta.capacita.single.nome, capacita.nome);
    });

    test('due impianti uguali la concedono una volta sola', () {
      final impianti = Impianti(protesi: [concedente, concedente]);
      expect(impianti.capacita, hasLength(1));
    });

    int bonusDi(Personaggio p, String abilita) =>
        p.abilita.firstWhere((a) => a.abilita.nome == abilita).valoreBonus;

    testWidgets('installato l impianto, la capacità c è con i suoi effetti', (
      tester,
    ) async {
      final salvate = await _apriPunk(tester);

      await _aggiungi(tester, 'Aggiungi protesi', concedente.nome);

      final p = salvate.last.personaggio;
      // I suoi Tag...
      for (final tag in capacita.tag) {
        expect(p.tag, contains(tag));
      }
      // ...e i suoi Modificatori.
      final m = _di(capacita.modificatori, CategoriaBersaglio.abilita)!;
      expect(bonusDi(p, m.bersaglio.label), greaterThanOrEqualTo(m.valore));
      // Ma non diventa una Capacità del personaggio: è dell'impianto.
      expect(p.capacita.map((c) => c.nome), isNot(contains(capacita.nome)));

      // Nella pagina Capacità, con l'impianto che la concede.
      await vaiAllaPagina(tester, 'Capacità');
      expect(find.text('Da Impianto'), findsOneWidget);
      await _tocca(tester, find.text(capacita.nome));
      expect(find.text(concedente.nome), findsOneWidget);
    });

    testWidgets('disinstallato l impianto, la capacità se ne va', (
      tester,
    ) async {
      final salvate = await _apriPunk(
        tester,
        impianti: Impianti(protesi: [concedente]),
      );

      await _tocca(tester, find.byTooltip('Disinstalla ${concedente.nome}'));

      final m = _di(capacita.modificatori, CategoriaBersaglio.abilita)!;
      expect(bonusDi(salvate.last.personaggio, m.bersaglio.label), 0);
      await vaiAllaPagina(tester, 'Capacità');
      expect(find.text('Da Impianto'), findsNothing);
      expect(find.text(capacita.nome), findsNothing);
    });
  });
}
