// APP/Pagina/Scheda: la modale di scelta di Armi, Armatura e Oggetti.
//
// Ogni ricerca guarda un campo solo, scelto con "Cerca per" (Nome,
// Tratti, Tag, Danno...), e diventa un filtro solo con "Aggiungi
// filtro". I filtri si sommano e restano in vista come chip da togliere.
// L'elenco si ordina dal riquadro accanto a "Lista". Per restringere a un tipo solo (armi da
// mischia, solo oggetti...) si filtra per Tipo.
//
// Armi e armature sono quelle di Lista/Armi e Lista/Armature, prese per
// nome: il catalogo cambia ordine appena se ne aggiunge una. I risultati
// attesi sono calcolati dal catalogo, non scritti a mano.

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
import 'package:app_personaggio/enums/rarita.dart';
import 'package:app_personaggio/models/armi/arma.dart';
import 'package:app_personaggio/models/armi/arma_distanza.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/criteri_catalogo.dart';
import 'package:app_personaggio/screens/scheda/scheda_dati.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';
import 'package:app_personaggio/widgets/sezione_collassabile.dart';

import 'linguette_scheda.dart';

final _pistola = listaArmi.firstWhere((a) => a.nome == 'Pistola');
final _martello = listaArmi.firstWhere((a) => a.nome == 'Martello');
final _armatura = listaArmature.first;
final _oggetto = listaOggetti.first;

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
    // Una Pistola già in mano: il campo libero in coda è "Arma 2".
    equipaggiamento: Equipaggiamento(armi: [_pistola]),
  );
}

/// Apre la Scheda sulla pagina [pagina] e raccoglie le schede salvate.
Future<List<Scheda>> _apri(WidgetTester tester, String pagina) async {
  // Uno schermo da telefono e non la finestra di test di default
  // (800x600), più bassa di qualunque telefono: la modale prende una
  // parte dell'altezza, e su 600 l'elenco mostrerebbe due righe appena.
  tester.view.physicalSize = const Size(400, 850);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(scheda: _scheda(), onModificata: salvate.add),
    ),
  );
  await vaiAllaPagina(tester, pagina);
  return salvate;
}

/// Apre la modale di scelta delle armi dal campo libero in coda.
Future<void> _apriArmi(WidgetTester tester) async {
  await _apri(tester, 'Equip');
  await _tocca(tester, _campo('Arma 2'));
}

Future<void> _tocca(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Il campo di scelta con l'etichetta [label].
///
/// Si tocca il campo e non l'etichetta: a campo vuoto l'etichetta sta
/// dentro il bordo, a campo pieno sale sopra, e toccarla direttamente
/// finirebbe a volte fuori dall'area del campo.
Finder _campo(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first;

/// Cercato dentro la modale: dietro c'è la pagina, che ha i suoi testi
/// e i suoi campi.
Finder _nellaModale(Finder finder) =>
    find.descendant(of: find.byType(AlertDialog), matching: finder);

/// Il nome [nome] fra le righe dell'elenco della modale.
Finder _nellaLista(String nome) =>
    find.descendant(of: find.byType(ListView), matching: find.text(nome));

/// Le righe mostrate dall'elenco, una SezioneCollassabile ciascuna.
Finder get _righe => find.descendant(
  of: find.byType(ListView),
  matching: find.byType(SezioneCollassabile),
);

/// L'elenco della modale quando ha [n] voci, o la scritta "Nessun..."
/// quando non ne ha.
///
/// Si conta dal numero di voci dichiarato dall'elenco e non dalle righe
/// costruite: l'elenco costruisce solo quelle in vista, e con la sezione
/// Ricerca aperta sono poche. Un ListView.separated ha una riga in più
/// per ogni separatore: n voci sono 2n - 1 figli.
Finder _quante(int n) => _nellaModale(
  n == 0
      ? find.textContaining('Nessun')
      : find.byWidgetPredicate(
          (w) =>
              w is ListView &&
              w.childrenDelegate is SliverChildBuilderDelegate &&
              (w.childrenDelegate as SliverChildBuilderDelegate).childCount ==
                  2 * n - 1,
          description: 'elenco con $n voci',
        ),
);

/// I nomi delle righe costruite, dall'alto in basso. L'elenco è pigro:
/// sono solo quelle in vista, cioè le prime.
List<String> _nomiInOrdine(WidgetTester tester) => tester
    .widgetList<SezioneCollassabile>(_righe)
    .map((s) => s.titolo)
    .toList();

/// Il pulsante che salva la ricerca come filtro.
Finder get _aggiungiFiltro =>
    _nellaModale(find.widgetWithText(FilledButton, 'Aggiungi filtro'));

/// Scrive [testo] nel campo di ricerca, senza salvarlo come filtro.
Future<void> _scrivi(WidgetTester tester, String testo) async {
  await tester.enterText(_nellaModale(find.byType(TextField)), testo);
  await tester.pumpAndSettle();
}

/// Scrive [testo] e lo salva come filtro, per il campo di "Cerca per".
Future<void> _cerca(WidgetTester tester, String testo) async {
  await _scrivi(tester, testo);
  await _tocca(tester, _aggiungiFiltro);
}

/// Sceglie [valore] nella tendina dei valori (campi a scelta come Tipo o
/// Rarità) e lo salva come filtro.
Future<void> _cercaValore(WidgetTester tester, String valore) async {
  await _tocca(
    tester,
    _nellaModale(find.byType(DropdownButtonFormField<String>)),
  );
  await tester.tap(find.text(valore).last);
  await tester.pumpAndSettle();
  await _tocca(tester, _aggiungiFiltro);
}

/// Sceglie [criterio] nel menu [menu] ("Cerca per", o "Ordina per"
/// finché non si è scelto niente: dopo il riquadro prende il nome del
/// campo scelto).
Future<void> _scegli(WidgetTester tester, String menu, String criterio) async {
  await _tocca(
    tester,
    find.ancestor(
      of: _nellaModale(find.text(menu)),
      matching: find.byType(DropdownButtonFormField<CriterioCatalogo>),
    ),
  );
  // Le voci del menu aperto stanno sopra a tutto: l'ultima trovata è
  // quella del menu, non il valore mostrato dal campo chiuso.
  await tester.tap(find.text(criterio).last);
  await tester.pumpAndSettle();
}

void main() {
  group('criteri', () {
    test('ogni criterio cerca nel suo campo e basta', () {
      final tag = _pistola.tag.first;
      final tratto = _pistola.tratti.first.nome;

      expect(criterioNome.corrisponde(_pistola.nome, 'PIST'), isTrue);
      expect(criterioNome.corrisponde(_pistola.nome, tag), isFalse);
      expect(criterioTag.corrisponde(_pistola.nome, tag), isTrue);
      expect(criterioTag.corrisponde(_pistola.nome, tratto), isFalse);
      expect(criterioTratti.corrisponde(_pistola.nome, tratto), isTrue);
    });

    test('un criterio numerico vuole il valore esatto', () {
      final danno = _pistola.danno;
      expect(criterioDanno.corrisponde(_pistola.nome, '$danno'), isTrue);
      expect(criterioDanno.corrisponde(_pistola.nome, '${danno}0'), isFalse);
      expect(criterioDanno.corrisponde(_pistola.nome, 'abc'), isFalse);
    });

    test('un oggetto generico non ha Danno, Tratti né PA', () {
      expect(criterioDanno.haValore(_oggetto.nome), isFalse);
      expect(criterioTratti.haValore(_oggetto.nome), isFalse);
      expect(criterioPA.haValore(_oggetto.nome), isFalse);
      // Il Valore invece ce l'hanno tutti.
      expect(criterioValore.haValore(_oggetto.nome), isTrue);
    });

    // Si cerca per qualunque dato mostrato aprendo la voce: ogni campo
    // di datiOggetto deve avere il suo criterio, e cercando il valore
    // che si legge lì la voce si deve trovare.
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
          // "-" è un elenco vuoto (niente Tratti): lì non c'è niente da
          // trovare. Di un elenco basta il primo valore.
          if (dato.value == '-') continue;
          final valore = dato.value.split(', ').first;
          expect(
            criterio!.corrisponde(nome, valore),
            isTrue,
            reason: '$nome, ${dato.key}: ${dato.value}',
          );
          // Un campo a scelta deve offrire il valore nella tendina,
          // altrimenti non ci sarebbe modo di cercarlo.
          if (criterio.aScelta) {
            expect(
              criterio.valoriPossibili(opzioni),
              contains(valore),
              reason: '$nome, ${dato.key}: ${dato.value}',
            );
          }
        }
      }
    }

    test('negli Oggetti si cerca per qualunque dato', () {
      cercabileOgniDato(oggettiOptions, criteriOggetti);
    });

    test('nelle Armi si cerca per qualunque dato', () {
      cercabileOgniDato(armiOptions, criteriArmi);
    });

    test('nelle Armature si cerca per qualunque dato tranne il Tipo', () {
      cercabileOgniDato(armatureOptions, criteriArmature, esclusi: {'Tipo'});
    });

    test('la Rarità si ordina per scala, non per alfabeto', () {
      final comune = listaOggetti.firstWhere((o) => o.rarita.index == 0).nome;
      final rara = listaOggetti.firstWhere((o) => o.rarita.index > 1).nome;
      // In alfabeto "Comune" < "Rara" per caso; la scala lo dice apposta.
      expect(criterioRarita.confronta(comune, rara), lessThan(0));
      expect(criterioRarita.confronta(rara, comune), greaterThan(0));
    });

    test('un campo a scelta vuole il valore intero', () {
      final tipo = datiOggetto(_pistola.nome)['Tipo']!;
      expect(criterioTipo.corrisponde(_pistola.nome, tipo), isTrue);
      // Un pezzo non basta: "Rara" non deve trovare "Molto Rara".
      expect(criterioTipo.corrisponde(_pistola.nome, 'Arma'), isFalse);
      // Un campo libero invece cerca il pezzo.
      expect(criterioNome.corrisponde(_pistola.nome, 'Pis'), isTrue);
    });

    test('la tendina della Rarità segue la scala', () {
      final valori = criterioRarita.valoriPossibili(oggettiOptions);
      final scala = Rarita.values.map((r) => r.label).toList();
      final indici = valori.map(scala.indexOf).toList();
      expect(indici, [...indici]..sort());
      // Solo le rarità che qualche voce ha davvero, ognuna una volta.
      expect(valori.toSet().length, valori.length);
    });

    test('Tratti e Tag non si possono usare per ordinare', () {
      expect(criterioTratti.ordinabile, isFalse);
      expect(criterioTag.ordinabile, isFalse);
      expect(criterioNome.ordinabile, isTrue);
      expect(criterioDanno.ordinabile, isTrue);
    });
  });

  testWidgets('il campo Arma apre la modale con la ricerca', (tester) async {
    await _apriArmi(tester);

    expect(_nellaModale(find.text('Scegli arma')), findsOneWidget);
    expect(_nellaModale(find.text('Cerca per')), findsOneWidget);
    expect(_nellaModale(find.text('Cerca per Nome')), findsOneWidget);
    // I chip per categoria non ci sono: lo stesso lavoro lo fa un filtro
    // sul Tipo.
    expect(_nellaModale(find.byType(ChoiceChip)), findsNothing);
    expect(_nellaModale(find.text('Tutti')), findsNothing);
  });

  testWidgets('di partenza si cerca per nome e le armi sono in ordine', (
    tester,
  ) async {
    await _apriArmi(tester);

    final alfabetico = listaArmi.map((a) => a.nome).toList()
      ..sort(confrontaNomi);
    final mostrate = _nomiInOrdine(tester);
    expect(mostrate, alfabetico.take(mostrate.length));

    await _cerca(tester, 'martel');
    expect(_nellaLista(_martello.nome), findsOneWidget);
    expect(_quante(1), findsOneWidget);

    // Per nome un tag non si trova: si cerca in un campo alla volta.
    await _cerca(tester, _pistola.tag.first);
    expect(find.text('Nessuna arma trovata.'), findsOneWidget);
  });

  testWidgets('si cerca un arma per tag', (tester) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Cerca per', 'Tag');

    // Il Tag si sceglie da una tendina, non si scrive.
    expect(_nellaModale(find.byType(TextField)), findsNothing);

    const tag = 'Militare';
    await _cercaValore(tester, tag);

    final attese = listaArmi.where((a) => a.tag.contains(tag)).toList();
    expect(_quante(attese.length), findsOneWidget);
    for (final arma in attese) {
      expect(_nellaLista(arma.nome), findsOneWidget, reason: arma.nome);
    }
  });

  testWidgets('si cerca un arma per tratto', (tester) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Cerca per', 'Tratti');

    final tratto = _pistola.tratti.first.nome;
    await _cercaValore(tester, tratto);

    final attese = listaArmi
        .where((a) => a.tratti.any((t) => t.nome == tratto))
        .toList();
    expect(_quante(attese.length), findsOneWidget);
    expect(_nellaLista(_pistola.nome), findsOneWidget);
  });

  testWidgets('si cerca un arma per danno esatto', (tester) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Cerca per', 'Danno');

    final danno = _martello.danno;
    await _cerca(tester, '$danno');

    final attese = listaArmi.where((a) => a.danno == danno).toList();
    expect(_quante(attese.length), findsOneWidget);
    expect(_nellaLista(_martello.nome), findsOneWidget);
  });

  testWidgets('cambiando campo il valore scritto si svuota', (tester) async {
    await _apriArmi(tester);
    await _scrivi(tester, 'pist');

    await _scegli(tester, 'Cerca per', 'Danno');

    expect(
      tester
          .widget<TextField>(_nellaModale(find.byType(TextField)))
          .controller!
          .text,
      isEmpty,
    );
    expect(_quante(listaArmi.length), findsOneWidget);
  });

  testWidgets('accanto a Lista ci sono Ordina per e la freccia', (
    tester,
  ) async {
    await _apriArmi(tester);

    // Solo "Lista": niente numero di voci, niente icona.
    expect(_nellaModale(find.text('Lista')), findsOneWidget);
    expect(_nellaModale(find.textContaining('Lista (')), findsNothing);
    expect(_nellaModale(find.byIcon(Icons.list)), findsNothing);

    // Sulla stessa riga del titolo, a destra.
    final titolo = tester.getCenter(_nellaModale(find.text('Lista')));
    final ordina = tester.getCenter(_nellaModale(find.text('Ordina per')));
    final freccia = tester.getCenter(find.byTooltip('Crescente'));
    expect(ordina.dy, moreOrLessEquals(titolo.dy, epsilon: 4));
    expect(freccia.dy, moreOrLessEquals(titolo.dy, epsilon: 4));
    expect(ordina.dx, greaterThan(titolo.dx));
    expect(freccia.dx, greaterThan(ordina.dx));

    // Finché non si sceglie, l'ordine è per nome.
    final alfabetico = listaArmi.map((a) => a.nome).toList()
      ..sort(confrontaNomi);
    final mostrate = _nomiInOrdine(tester);
    expect(mostrate, alfabetico.take(mostrate.length));
  });

  testWidgets('scelto il campo, il riquadro ne prende il nome', (tester) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Ordina per', 'Valore Penetrazione');

    expect(_nellaModale(find.text('Ordina per')), findsNothing);
    final scritta = find.descendant(
      of: find.byType(DropdownButtonFormField<CriterioCatalogo>).last,
      matching: find.text('Valore Penetrazione'),
    );
    expect(scritta, findsOneWidget);
    // Un nome lungo si taglia con i puntini invece di sfondare.
    expect(tester.widget<Text>(scritta).overflow, TextOverflow.ellipsis);
  });

  testWidgets('si ordina per danno nei due versi, con il valore accanto', (
    tester,
  ) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Ordina per', 'Danno');

    List<String> ordinate({required bool crescente}) {
      final armi = [...listaArmi]
        ..sort((a, b) {
          final c = crescente
              ? a.danno.compareTo(b.danno)
              : b.danno.compareTo(a.danno);
          return c != 0 ? c : confrontaNomi(a.nome, b.nome);
        });
      return armi.map((a) => a.nome).toList();
    }

    var mostrate = _nomiInOrdine(tester);
    expect(mostrate, ordinate(crescente: true).take(mostrate.length));

    // Il danno della prima riga è scritto accanto al nome.
    final prima = listaArmi.firstWhere((a) => a.nome == mostrate.first);
    expect(
      find.descendant(of: _righe.first, matching: find.text('${prima.danno}')),
      findsOneWidget,
    );

    await _tocca(tester, find.byTooltip('Crescente'));

    mostrate = _nomiInOrdine(tester);
    expect(mostrate, ordinate(crescente: false).take(mostrate.length));
    expect(find.byTooltip('Decrescente'), findsOneWidget);
  });

  testWidgets('ordinando gli Oggetti per danno le armi vengono prima', (
    tester,
  ) async {
    await _apri(tester, 'Oggetti');
    await _tocca(
      tester,
      find.widgetWithText(OutlinedButton, 'Aggiungi oggetto'),
    );

    // Gli oggetti generici il Danno non ce l'hanno: vanno in fondo, in
    // entrambi i versi.
    await _scegli(tester, 'Ordina per', 'Danno');
    expect(armaDaNome(_nomiInOrdine(tester).first), isNotNull);

    await _tocca(tester, find.byTooltip('Crescente'));
    expect(armaDaNome(_nomiInOrdine(tester).first), isNotNull);
  });

  testWidgets('mentre si scrive l elenco non cambia', (tester) async {
    await _apriArmi(tester);

    // A campo vuoto il pulsante è spento.
    expect(tester.widget<FilledButton>(_aggiungiFiltro).onPressed, isNull);

    await _scrivi(tester, 'martel');
    expect(_quante(listaArmi.length), findsOneWidget);
    expect(tester.widget<FilledButton>(_aggiungiFiltro).onPressed, isNotNull);

    await _tocca(tester, _aggiungiFiltro);
    expect(_quante(1), findsOneWidget);
    // Salvato il filtro, il campo è pronto per il prossimo.
    expect(_nellaModale(find.text('martel')), findsNothing);
    expect(_nellaModale(find.text('Nome: martel')), findsOneWidget);
  });

  testWidgets('Invio nel campo vale come Aggiungi filtro', (tester) async {
    await _apriArmi(tester);
    await _scrivi(tester, 'martel');

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(_quante(1), findsOneWidget);
  });

  testWidgets('i filtri si sommano e si tolgono uno alla volta', (
    tester,
  ) async {
    // Lo scenario: un'arma con "pist" nel nome e un certo Danno; poi
    // via il nome, resta il Danno; poi solo quelle a distanza.
    final danno = _pistola.danno;
    int quante(bool Function(Arma) filtro) => listaArmi.where(filtro).length;

    await _apriArmi(tester);

    await _cerca(tester, 'pist');
    expect(
      _quante(quante((a) => a.nome.toLowerCase().contains('pist'))),
      findsOneWidget,
    );

    await _scegli(tester, 'Cerca per', 'Danno');
    await _cerca(tester, '$danno');
    expect(
      _quante(
        quante(
          (a) => a.nome.toLowerCase().contains('pist') && a.danno == danno,
        ),
      ),
      findsOneWidget,
    );
    // Tutti e due i filtri in vista, ognuno con la sua X.
    expect(_nellaModale(find.text('Nome: pist')), findsOneWidget);
    expect(_nellaModale(find.text('Danno: $danno')), findsOneWidget);

    // Via il filtro sul nome: resta solo il Danno.
    await _tocca(tester, find.byTooltip('Togli Nome: pist'));
    expect(_quante(quante((a) => a.danno == danno)), findsOneWidget);

    // Il Tipo si sceglie dalla tendina.
    await _scegli(tester, 'Cerca per', 'Tipo');
    await _cercaValore(tester, 'Arma da Distanza');
    expect(
      _quante(quante((a) => a is ArmaDistanza && a.danno == danno)),
      findsOneWidget,
    );

    await _tocca(tester, _nellaModale(find.text('Rimuovi tutti')));
    expect(_quante(listaArmi.length), findsOneWidget);
    expect(_nellaModale(find.text('Ricerca')), findsOneWidget);
  });

  testWidgets('un nuovo filtro sullo stesso campo sostituisce il vecchio', (
    tester,
  ) async {
    await _apriArmi(tester);
    await _scegli(tester, 'Cerca per', 'Tipo');

    await _cercaValore(tester, 'Arma da Mischia');
    await _cercaValore(tester, 'Arma da Distanza');

    expect(_nellaModale(find.text('Tipo: Arma da Mischia')), findsNothing);
    expect(_nellaModale(find.text('Tipo: Arma da Distanza')), findsOneWidget);
    expect(_quante(listaArmiDistanza.length), findsOneWidget);
  });

  testWidgets('il Tipo Mischia lascia solo le armi da mischia', (tester) async {
    await _apriArmi(tester);

    await _scegli(tester, 'Cerca per', 'Tipo');
    await _cercaValore(tester, 'Arma da Mischia');

    expect(_quante(listaArmiMischia.length), findsOneWidget);
    expect(_nellaLista(_martello.nome), findsOneWidget);
    expect(_nellaLista(_pistola.nome), findsNothing);

    // Tipo e nome si sommano: la Pistola è a distanza, e cercandola fra
    // le armi da mischia non c'è.
    await _scegli(tester, 'Cerca per', 'Nome');
    await _cerca(tester, _pistola.nome);
    expect(find.text('Nessuna arma trovata.'), findsOneWidget);

    // Tolto il Tipo, la Pistola torna.
    await _tocca(tester, find.byTooltip('Togli Tipo: Arma da Mischia'));
    expect(_nellaLista(_pistola.nome), findsOneWidget);
  });

  testWidgets('scegliendo un arma già in mano se ne ha due', (tester) async {
    final salvate = await _apri(tester, 'Equip');
    await _tocca(tester, _campo('Arma 2'));

    await _cerca(tester, _pistola.nome);
    await _tocca(tester, find.byTooltip('Scegli ${_pistola.nome}'));

    expect(find.byType(AlertDialog), findsNothing);
    expect(salvate.last.equipaggiamento.armi.map((a) => a.nome), [
      _pistola.nome,
      _pistola.nome,
    ]);
    // Si è aperto un nuovo campo libero in coda.
    expect(find.text('Arma 3'), findsOneWidget);
  });

  testWidgets('annullando la modale l arma non cambia', (tester) async {
    final salvate = await _apri(tester, 'Equip');
    await _tocca(tester, _campo('Arma 2'));
    await _tocca(tester, find.text('Annulla'));

    expect(find.byType(AlertDialog), findsNothing);
    expect(salvate, isEmpty);
  });

  testWidgets('l armatura si cerca per PA', (tester) async {
    final salvate = await _apri(tester, 'Equip');
    await _tocca(tester, _campo('Armatura indossata'));

    expect(_nellaModale(find.text('Scegli armatura')), findsOneWidget);

    await _scegli(tester, 'Cerca per', 'PA');
    await _cerca(tester, '${_armatura.pa}');
    expect(
      _quante(listaArmature.where((a) => a.pa == _armatura.pa).length),
      findsOneWidget,
    );

    await _tocca(tester, find.byTooltip('Scegli ${_armatura.nome}'));
    expect(salvate.last.equipaggiamento.armatura?.nome, _armatura.nome);
  });

  testWidgets('negli Oggetti il Tipo divide oggetti, armi e armature', (
    tester,
  ) async {
    await _apri(tester, 'Oggetti');
    await _tocca(
      tester,
      find.widgetWithText(OutlinedButton, 'Aggiungi oggetto'),
    );
    await _scegli(tester, 'Cerca per', 'Tipo');

    // Anche gli oggetti generici hanno un Tipo: senza, non ci sarebbe
    // modo di vedere solo loro.
    await _cercaValore(tester, 'Oggetto');
    expect(_quante(listaOggetti.length), findsOneWidget);
    // Il primo in ordine alfabetico: l'elenco costruisce solo le righe
    // in vista.
    final primo =
        (listaOggetti.map((o) => o.nome).toList()..sort(confrontaNomi)).first;
    expect(_nellaLista(primo), findsOneWidget);

    await _cercaValore(tester, 'Armatura');
    expect(_quante(listaArmature.length), findsOneWidget);
  });

  testWidgets('a Ricerca chiusa i filtri si vedono e si tolgono', (
    tester,
  ) async {
    await _apriArmi(tester);
    await _cerca(tester, 'martel');
    expect(_quante(1), findsOneWidget);

    final titolo = _nellaModale(find.text('Ricerca'));
    await _tocca(tester, titolo);

    // Chiusa: spariscono menu e campo...
    expect(_nellaModale(find.text('Cerca per')), findsNothing);
    expect(_nellaModale(find.byType(TextField)), findsNothing);
    // ...ma il filtro resta in vista, e la Lista resta filtrata.
    expect(_nellaModale(find.text('Nome: martel')), findsOneWidget);
    expect(_quante(1), findsOneWidget);
    expect(_nellaLista(_martello.nome), findsOneWidget);

    // La X lo toglie senza dover riaprire la Ricerca.
    await _tocca(tester, find.byTooltip('Togli Nome: martel'));
    expect(_nellaModale(find.text('Nome: martel')), findsNothing);
    expect(_quante(listaArmi.length), findsOneWidget);
  });

  testWidgets('negli Oggetti si cerca per descrizione', (tester) async {
    await _apri(tester, 'Oggetti');
    await _tocca(
      tester,
      find.widgetWithText(OutlinedButton, 'Aggiungi oggetto'),
    );

    // Un pezzo della descrizione, non il nome.
    final pezzo = _oggetto.descrizione.split(' ').take(3).join(' ');
    await _scegli(tester, 'Cerca per', 'Descrizione');
    await _cerca(tester, pezzo);

    final attesi = oggettiOptions
        .where((o) => criterioDescrizione.corrisponde(o, pezzo))
        .length;
    expect(attesi, greaterThan(0));
    expect(_quante(attesi), findsOneWidget);
    expect(_nellaLista(_oggetto.nome), findsOneWidget);
  });
}
