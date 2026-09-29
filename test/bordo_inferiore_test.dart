// I telefoni disegnano i tasti di sistema (o la barra dei gesti) sopra
// all'app: quella striscia in fondo allo schermo è occupata, e quello
// che ci finisce sotto non si legge e non si tocca. È successo su un
// Huawei P30 lite ma non è un caso isolato, quindi qui si simula quella
// striscia e si controlla che il contenuto delle pagine resti sopra.
//
// Non si guarda se c'è una SafeArea: si guarda dove finisce il
// contenuto, così il test regge anche se un domani il margine si
// ottiene in un altro modo.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/aumento_pg/aumento_pg_page.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_page.dart';
import 'package:app_personaggio/screens/home/home_page.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

/// Quanto si prende la barra di sistema in fondo, in punti.
const double _tastiSistema = 48;

/// Telefono stretto come quello di chi ha segnalato il problema.
const Size _telefono = Size(361, 800);

Scheda _scheda({bool conArmi = false}) {
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
      armi: conArmi ? [listaArmi.first] : const [],
    ),
  );
}

/// Mette lo schermo del telefono e ci appoggia in fondo i tasti di
/// sistema. Con devicePixelRatio 1 i punti sono anche pixel, così i
/// numeri del test sono quelli che si leggono a schermo.
void _conTastiInFondo(WidgetTester tester) {
  tester.view.physicalSize = _telefono;
  tester.view.devicePixelRatio = 1.0;
  tester.view.padding = const FakeViewPadding(bottom: _tastiSistema);
  tester.view.viewPadding = const FakeViewPadding(bottom: _tastiSistema);
  addTearDown(tester.view.reset);
}

/// La riga oltre la quale si finisce sotto ai tasti di sistema.
double get _limiteInferiore => _telefono.height - _tastiSistema;

void main() {
  testWidgets('la Scheda tiene le sue pagine sopra ai tasti di sistema', (
    tester,
  ) async {
    _conTastiInFondo(tester);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(), onModificata: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byType(TabBarView)).bottom,
      lessThanOrEqualTo(_limiteInferiore),
    );
  });

  testWidgets('in Creazione il contenuto resta sopra ai tasti di sistema', (
    tester,
  ) async {
    _conTastiInFondo(tester);

    await tester.pumpWidget(const MaterialApp(home: CharacterCreationPage()));
    await tester.pumpAndSettle();

    // Si guarda l'area delle tre sotto-pagine invece del bottone
    // Avanti: il bottone sta in fondo al contenuto, e finché il
    // contenuto ci sta tutto a schermo resta comunque in alto, quindi
    // non direbbe niente. L'area, invece, o si ferma sopra ai tasti o
    // ci finisce sotto.
    expect(
      tester.getRect(find.byType(PageView)).bottom,
      lessThanOrEqualTo(_limiteInferiore),
    );
  });

  testWidgets('nella Home la versione resta sopra ai tasti di sistema', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    _conTastiInFondo(tester);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    final versione = find.textContaining('version:');
    expect(versione, findsOneWidget);
    expect(
      tester.getRect(versione).bottom,
      lessThanOrEqualTo(_limiteInferiore),
    );
  });

  testWidgets('in Aumento la barra dei PX resta sopra ai tasti di sistema', (
    tester,
  ) async {
    _conTastiInFondo(tester);

    await tester.pumpWidget(
      MaterialApp(home: AumentoPgPage(personaggio: _scheda().personaggio)),
    );
    await tester.pumpAndSettle();

    // La barra dei PX è ancorata in fondo: è la prima cosa che i tasti
    // di sistema coprirebbero.
    final px = find.textContaining('Punti Esperienza disponibili');
    expect(px, findsOneWidget);
    expect(tester.getRect(px).bottom, lessThanOrEqualTo(_limiteInferiore));
  });

  testWidgets('la barra di scorrimento resta fuori dalla tabella', (
    tester,
  ) async {
    _conTastiInFondo(tester);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: _scheda(conArmi: true), onModificata: (_) {}),
      ),
    );
    // A 361 punti la barra delle pagine non ci sta tutta: la linguetta
    // va portata in vista, altrimenti il tocco cade fuori dallo schermo.
    await vaiAllaPagina(tester, 'Equip');

    final barra = find.byType(Scrollbar);
    expect(barra, findsWidgets, reason: 'la tabella delle Armi scorre');

    // Flutter posiziona il pollice tenendosi alla larga dal margine di
    // sistema che trova nel MediaQuery. Dentro a una tabella quel
    // margine non c'entra: se arriva fin qui, la barra risale di
    // altrettanti punti e finisce sopra all'intestazione.
    expect(MediaQuery.of(tester.element(barra.first)).padding, EdgeInsets.zero);
  });
}
