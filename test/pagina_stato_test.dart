// APP/Pagina/Scheda, pagina "Stato": quella che si tiene aperta durante
// uno scontro.
//
// Difesa e barra delle Ferite in alto, sotto le Resilienze, il Grado
// Ferita e la barra dello Shock. Le barre partono del colore acceso e
// si riempiono di quello scuro mentre si incassa; toccandole si segna
// il colpo ricevuto, e l'app sottrae da sé la Resilienza che gli si
// oppone.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_armature.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/grado_ferita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/armatura.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/ferite.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/barra_stato.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';

import 'linguette_scheda.dart';

/// Resistenza 4 -> Resilienza Base 5, Ferite Base 4. Con l'armatura da
/// PA 1 la Resilienza Fisica viene 6, l'Energetica 6.
Scheda _scheda({
  int ferite = 0,
  GradoFerita grado = GradoFerita.zero,
  Armatura? armatura,
}) {
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
            (c) => CaratteristicaPersonaggio(caratteristica: c, valoreBase: 4),
          )
          .toList(),
      abilita: listaAbilita
          .map((a) => AbilitaPersonaggio(abilita: a, valoreBase: 2))
          .toList(),
    ),
    ferite: Ferite(attuali: ferite, gradoFerita: grado),
    equipaggiamento: Equipaggiamento(armatura: armatura),
  );
}

Future<List<Scheda>> _apriStato(
  WidgetTester tester, {
  int ferite = 0,
  GradoFerita grado = GradoFerita.zero,
  Armatura? armatura,
}) async {
  final salvate = <Scheda>[];
  await tester.pumpWidget(
    MaterialApp(
      home: SchedaPage(
        scheda: _scheda(ferite: ferite, grado: grado, armatura: armatura),
        onModificata: salvate.add,
      ),
    ),
  );
  // Su uno schermo stretto la barra delle pagine non ci sta tutta: la
  // linguetta va portata in vista, altrimenti il tocco cade fuori.
  await vaiAllaPagina(tester, 'Stato');
  return salvate;
}

/// La barra intestata [etichetta].
BarraStato _barra(WidgetTester tester, String etichetta) => tester
    .widgetList<BarraStato>(find.byType(BarraStato))
    .firstWhere((b) => b.etichetta == etichetta);

/// Segna un colpo: apre la modale dalla barra Ferite, porta lo slider
/// circa a [danno], conferma e restituisce il danno davvero scelto.
///
/// "Circa" perché il punto esatto dipende dalla geometria dello slider:
/// invece di fidarsi, il valore viene riletto dal widget e restituito,
/// così i conti del test partono da quello che l'utente ha davvero
/// scelto.
Future<int> _segnaDanno(
  WidgetTester tester,
  int danno, {
  bool energetico = false,
}) async {
  await tester.tap(find.byType(BarraStato).first);
  await tester.pumpAndSettle();

  if (energetico) {
    await tester.tap(find.text('Energetico'));
    await tester.pumpAndSettle();
  }

  // La traccia dello slider è rientrata di una ventina di punti per
  // lato: toccando in proporzione dentro quella fascia si sposta il
  // cursore dove serve.
  final slider = find.byType(Slider);
  final area = tester.getRect(slider);
  const margine = 24.0;
  final utile = area.width - margine * 2;
  await tester.tapAt(
    Offset(area.left + margine + utile * danno / 30, area.center.dy),
  );
  await tester.pumpAndSettle();

  final scelto = tester.widget<Slider>(slider).value.round();

  await tester.tap(find.widgetWithText(TextButton, 'Applica'));
  await tester.pumpAndSettle();
  return scelto;
}

/// Come [_segnaDanno], ma dalla barra dello Shock. Lo slider dello
/// Shock arriva almeno a 10.
Future<int> _segnaShock(WidgetTester tester, int shock) async {
  await tester.tap(find.byType(BarraStato).last);
  await tester.pumpAndSettle();

  final slider = find.byType(Slider);
  final massimo = tester.widget<Slider>(slider).max;
  final area = tester.getRect(slider);
  const margine = 24.0;
  final utile = area.width - margine * 2;
  // Oltre il fondo della barra si toccherebbe fuori dalla modale, che
  // si chiuderebbe: la richiesta si ferma al massimo dello slider.
  final quota = (shock / massimo).clamp(0.0, 1.0);
  await tester.tapAt(
    Offset(area.left + margine + utile * quota, area.center.dy),
  );
  await tester.pumpAndSettle();

  final scelto = tester.widget<Slider>(slider).value.round();

  await tester.tap(find.widgetWithText(TextButton, 'Applica'));
  await tester.pumpAndSettle();
  return scelto;
}

void main() {
  testWidgets('la pagina mostra Difesa, Resilienze e le due barre', (
    tester,
  ) async {
    await _apriStato(tester);

    expect(find.text('Difesa'), findsOneWidget);
    expect(find.text('Grado Ferita'), findsOneWidget);

    // Fermezza e Risolutezza in cima, affiancate e sopra la Difesa.
    expect(
      tester.getTopLeft(find.text('Fermezza')).dy,
      tester.getTopLeft(find.text('Risolutezza')).dy,
      reason: 'stessa riga',
    );
    expect(
      tester.getTopLeft(find.text('Fermezza')).dy,
      lessThan(tester.getTopLeft(find.text('Difesa')).dy),
      reason: 'in cima a tutto',
    );
    expect(find.byType(BarraStato), findsNWidgets(2));

    // Le Resilienze sono il sottotitolo della barra delle Ferite, non
    // due righe per conto loro.
    expect(
      _barra(tester, 'Ferite').sottotitolo,
      'Resilienza Fisica 5 · Energetica 5',
    );
  });

  testWidgets('la barra delle Ferite si riempie man mano che si incassa', (
    tester,
  ) async {
    // Ferite Massime 4: a 1 ferita la barra e' piena per un quarto.
    await _apriStato(tester, ferite: 1);

    final barra = _barra(tester, 'Ferite');
    expect(barra.massimi, 4);
    expect(barra.attuali, 1);
    expect(barra.quotaRiempita, closeTo(0.25, 0.001));
  });

  testWidgets('incassate tutte le ferite la barra è piena, non oltre', (
    tester,
  ) async {
    await _apriStato(tester, ferite: 99);

    expect(_barra(tester, 'Ferite').quotaRiempita, 1);
  });

  testWidgets('un colpo fisico toglie la Resilienza Fisica', (tester) async {
    // Resistenza 4 -> Resilienza Base 5, e senza armatura è anche la
    // Resilienza Fisica.
    final salvate = await _apriStato(tester);
    const resilienzaFisica = 5;

    // Ferite Massime 4: il colpo deve passare ma restare nei limiti.
    final danno = await _segnaDanno(tester, 8);

    expect(danno, greaterThan(resilienzaFisica), reason: 'il colpo passa');
    expect(danno - resilienzaFisica, lessThanOrEqualTo(4), reason: 'ci sta');
    expect(salvate.last.ferite.attuali, danno - resilienzaFisica);
  });

  testWidgets('un colpo che non supera la Resilienza non lascia ferite', (
    tester,
  ) async {
    final salvate = await _apriStato(tester);

    final danno = await _segnaDanno(tester, 3);

    expect(danno, lessThanOrEqualTo(5), reason: 'il colpo si ferma');
    expect(salvate, isEmpty, reason: 'niente da salvare');
    expect(_barra(tester, 'Ferite').attuali, 0);
  });

  testWidgets('il tipo Energetico usa la Resilienza Energetica', (
    tester,
  ) async {
    // Con l'armatura le due Resilienze sono diverse: PA 1, PA Energia 1
    // sulla prima armatura del catalogo.
    final armatura = listaArmature.first;
    final salvate = await _apriStato(tester, armatura: armatura);
    final resilienzaEnergetica = 5 + armatura.paEnergia;

    final danno = await _segnaDanno(tester, 9, energetico: true);

    expect(danno, greaterThan(resilienzaEnergetica));
    expect(
      danno - resilienzaEnergetica,
      lessThanOrEqualTo(4),
      reason: 'ci sta',
    );
    expect(salvate.last.ferite.attuali, danno - resilienzaEnergetica);
  });

  testWidgets('le Ferite si fermano al massimo e l eccesso si perde', (
    tester,
  ) async {
    // Ferite Massime 4, già 3 prese: un colpo che ne lascerebbe molte
    // ne segna una sola, e le altre non lasciano traccia.
    final salvate = await _apriStato(tester, ferite: 3);

    final danno = await _segnaDanno(tester, 12);

    expect(danno - 5, greaterThan(1), reason: 'il colpo sfora');
    expect(salvate.last.ferite.attuali, 4);
    expect(_barra(tester, 'Ferite').quotaRiempita, 1);
    expect(find.textContaining('le altre si perdono'), findsOneWidget);
  });

  testWidgets('a Ferite già al massimo un altro colpo non aggiunge niente', (
    tester,
  ) async {
    final salvate = await _apriStato(tester, ferite: 4);

    await _segnaDanno(tester, 12);

    expect(salvate, isEmpty, reason: 'niente da salvare');
    expect(_barra(tester, 'Ferite').attuali, 4);
    expect(find.textContaining('non aggiunge niente'), findsOneWidget);
  });

  testWidgets('un colpo che riempie esattamente le Ferite viene segnato', (
    tester,
  ) async {
    // Ferite Massime 4, già 3: una sola ferita ci sta ancora.
    final salvate = await _apriStato(tester, ferite: 3);

    final danno = await _segnaDanno(tester, 6);

    expect(danno - 5, 1, reason: 'una ferita esatta');
    expect(salvate.last.ferite.attuali, 4);
    expect(_barra(tester, 'Ferite').quotaRiempita, 1);
  });

  testWidgets('lo Shock si ferma al massimo e l eccesso diventa danno', (
    tester,
  ) async {
    // Shock Massimo = Volontà + Resistenza = 8, si parte da 0.
    final salvate = await _apriStato(tester);

    final shock = await _segnaShock(tester, 12);

    expect(shock, greaterThan(8), reason: 'lo Shock sfora');
    expect(salvate.last.shockAttuale, 8, reason: 'si ferma al massimo');
    // L'eccesso diventa Ferite, senza passare dalla Resilienza.
    expect(salvate.last.ferite.attuali, shock - 8);
    expect(find.textContaining('danni diretti'), findsOneWidget);
  });

  testWidgets('lo Shock che ci sta non fa danni diretti', (tester) async {
    final salvate = await _apriStato(tester);

    final shock = await _segnaShock(tester, 3);

    expect(shock, lessThanOrEqualTo(8));
    expect(salvate.last.shockAttuale, shock);
    expect(salvate.last.ferite.attuali, 0);
  });

  testWidgets('dalla scheda Cure le Ferite si tolgono', (tester) async {
    final salvate = await _apriStato(tester, ferite: 3);

    await tester.tap(find.byType(BarraStato).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cure'));
    await tester.pumpAndSettle();

    // Lo slider delle cure arriva al massimo alle ferite prese.
    final slider = find.byType(Slider);
    expect(tester.widget<Slider>(slider).max, 3, reason: 'non si cura di più');

    final area = tester.getRect(slider);
    await tester.tapAt(Offset(area.right - 24, area.center.dy));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Applica'));
    await tester.pumpAndSettle();

    expect(salvate.last.ferite.attuali, 0);
    expect(_barra(tester, 'Ferite').quotaRiempita, 0);
  });

  testWidgets('senza ferite la scheda Cure lo dice', (tester) async {
    await _apriStato(tester);

    await tester.tap(find.byType(BarraStato).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cure'));
    await tester.pumpAndSettle();

    expect(find.text('Nessuna ferita da curare.'), findsOneWidget);
  });

  testWidgets('dalla scheda Cure lo Shock si recupera', (tester) async {
    final salvate = await _apriStato(tester);
    // Prima se ne subisce, poi lo si recupera tutto.
    await _segnaShock(tester, 4);
    final subito = salvate.last.shockAttuale;
    expect(subito, greaterThan(0));

    await tester.tap(find.byType(BarraStato).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cure'));
    await tester.pumpAndSettle();

    final slider = find.byType(Slider);
    final area = tester.getRect(slider);
    await tester.tapAt(Offset(area.right - 24, area.center.dy));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Applica'));
    await tester.pumpAndSettle();

    expect(salvate.last.shockAttuale, 0);
  });

  testWidgets('salendo di Grado Ferita le Ferite Attuali tornano a zero', (
    tester,
  ) async {
    final salvate = await _apriStato(tester, ferite: 3);

    final piu = find.descendant(
      of: find
          .ancestor(of: find.text('Grado Ferita'), matching: find.byType(Row))
          .first,
      matching: find.byIcon(Icons.add_circle_outline),
    );
    await tester.tap(piu);
    await tester.pumpAndSettle();

    expect(salvate.last.ferite.gradoFerita, GradoFerita.uno);
    expect(salvate.last.ferite.attuali, 0);
    expect(_barra(tester, 'Ferite').quotaRiempita, 0);
  });

  testWidgets('scendendo di grado le Ferite non si toccano', (tester) async {
    final salvate = await _apriStato(tester, ferite: 2, grado: GradoFerita.due);

    final meno = find.descendant(
      of: find
          .ancestor(of: find.text('Grado Ferita'), matching: find.byType(Row))
          .first,
      matching: find.byIcon(Icons.remove_circle_outline),
    );
    await tester.tap(meno);
    await tester.pumpAndSettle();

    expect(salvate.last.ferite.gradoFerita, GradoFerita.uno);
    expect(salvate.last.ferite.attuali, 2, reason: 'guarire non annulla');
  });

  testWidgets('le Ferite sono rosse, lo Shock blu, e il pieno è più scuro', (
    tester,
  ) async {
    await _apriStato(tester);

    final ferite = _barra(tester, 'Ferite');
    expect(ferite.coloreLibero, Colors.red);
    expect(ferite.colorePreso, Colors.red.shade900);

    final shock = _barra(tester, 'Shock');
    expect(shock.coloreLibero, Colors.blue);
    expect(shock.colorePreso, Colors.blue.shade900);

    // Quello che conta è il rapporto fra le due tinte: se il pieno non
    // fosse più scuro del vuoto non si capirebbe quanta barra è andata.
    for (final barra in [ferite, shock]) {
      expect(
        barra.colorePreso.computeLuminance(),
        lessThan(barra.coloreLibero.computeLuminance()),
        reason: '${barra.etichetta}: il pieno deve essere il più scuro',
      );
    }
  });

  testWidgets('scegliere il tipo di danno non rimescola le etichette', (
    tester,
  ) async {
    // Su un telefono stretto la spunta che compariva sul segmento scelto
    // si prendeva lo spazio dell'etichetta, e "Energetico" ci finiva a
    // capo per una lettera sola. Le due scritte devono restare come
    // erano: quale sia attiva si vede dal colore.
    tester.view.physicalSize = const Size(361, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _apriStato(tester);
    await tester.tap(find.byType(BarraStato).first);
    await tester.pumpAndSettle();

    Size misura(String etichetta) => tester.getSize(find.text(etichetta).first);
    final fisicoPrima = misura('Fisico');
    final energeticoPrima = misura('Energetico');

    await tester.tap(find.text('Energetico'));
    await tester.pumpAndSettle();

    expect(misura('Fisico'), fisicoPrima);
    expect(misura('Energetico'), energeticoPrima);
  });
}
