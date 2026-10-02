// Tutto ciò che porta Modificatori - Capacità, Background, Mutazioni,
// Impianti - cambia il valore che ciascuno prende come bersaglio: una
// Caratteristica o un'Abilità (nel loro Valore Bonus) o un valore della
// Scheda (Ferite Massime, Velocità, Difesa...). I bonus sono sempre
// ricalcolati da zero dall'elenco completo di ciò che il personaggio ha,
// così togliere una di queste cose ne toglie anche il bonus.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_mutazioni.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/bersaglio.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/screens/scheda/scheda_page.dart';
import 'package:app_personaggio/models/background.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/models/modificatore.dart';
import 'package:app_personaggio/models/mutazione.dart';
import 'package:app_personaggio/services/effetti_personaggio.dart';

import 'linguette_scheda.dart';

Modificatore _m(Bersaglio bersaglio, int valore) =>
    Modificatore(bersaglio: bersaglio, valore: valore);

Capacita _capacita(
  List<Modificatore> modificatori, {
  String nome = 'Capacità',
}) => Capacita(
  nome: nome,
  tipo: TipoCapacita.generica,
  descrizione: '',
  effetto: '',
  modificatori: modificatori,
  costo: 2,
  tag: const [],
);

Background _background([List<Modificatore> modificatori = const []]) =>
    Background(
      nome: 'Background',
      descrizione: '',
      capacitaDiBackground: _capacita(const [], nome: 'Di Background'),
      modificatori: modificatori,
      tag: 'Militare',
    );

Mutazione _mutazione(List<Modificatore> modificatori) => Mutazione(
  nome: 'Mutazione',
  descrizione: '',
  effetto: '',
  modificatori: modificatori,
);

/// Una Scheda con tutte le Caratteristiche a [base] e tutte le Abilità a
/// 1, più le [capacita] e le [mutazioni] indicate.
Scheda _scheda({
  int base = 3,
  List<Capacita> capacita = const [],
  List<Mutazione> mutazioni = const [],
  int furtivitaPassiva = 0,
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
      background: _background(),
      caratteristiche: [
        for (final c in listaCaratteristiche)
          CaratteristicaPersonaggio(caratteristica: c, valoreBase: base),
      ],
      // Tutte le abilità: la Scheda calcola la Percezione Passiva e si
      // aspetta di trovarle.
      abilita: [
        for (final a in listaAbilita)
          AbilitaPersonaggio(abilita: a, valoreBase: 1),
      ],
      capacita: capacita,
      mutazioni: mutazioni,
    ),
    furtivitaPassiva: furtivitaPassiva,
  );
}

void main() {
  test('il catalogo dei Bersagli è quello di Caratteristiche e Abilità', () {
    // Il Modificatore trova la riga da alzare per nome: se i due elenchi
    // si scostassero, un bonus finirebbe nel vuoto.
    List<String> diCategoria(CategoriaBersaglio categoria) => [
      for (final b in Bersaglio.values)
        if (b.categoria == categoria) b.label,
    ];

    expect(
      diCategoria(CategoriaBersaglio.caratteristica),
      unorderedEquals(listaCaratteristiche.map((c) => c.nome)),
    );
    expect(
      diCategoria(CategoriaBersaglio.abilita),
      unorderedEquals(listaAbilita.map((a) => a.nome)),
    );
  });

  test('i modificatori delle Capacità alimentano il Valore Bonus', () {
    final capacita = [
      _capacita([_m(Bersaglio.forza, 1)]),
      _capacita([_m(Bersaglio.forza, 2), _m(Bersaglio.percezione, 1)]),
    ];

    expect(bonusCaratteristica('Forza', capacita: capacita), 3);
    expect(bonusAbilita('Percezione', capacita: capacita), 1);
  });

  test('una sola sorgente può portare quanti modificatori vuole', () {
    final capacita = [
      _capacita([
        _m(Bersaglio.forza, 1),
        _m(Bersaglio.agilita, 2),
        _m(Bersaglio.mira, 1),
        _m(Bersaglio.tempra, -1),
      ]),
    ];

    expect(bonusCaratteristica('Forza', capacita: capacita), 1);
    expect(bonusCaratteristica('Agilità', capacita: capacita), 2);
    expect(bonusAbilita('Mira', capacita: capacita), 1);
    expect(bonusAbilita('Tempra', capacita: capacita), -1);
  });

  test('anche i modificatori del Background contano', () {
    final background = _background([
      _m(Bersaglio.socialita, 1),
      _m(Bersaglio.persuasione, 2),
    ]);

    expect(
      bonusCaratteristica(
        'Socialità',
        capacita: const [],
        background: background,
      ),
      1,
    );
    expect(
      bonusAbilita('Persuasione', capacita: const [], background: background),
      2,
    );
  });

  test('le Mutazioni possono toccare anche le Abilità', () {
    final mutazioni = [
      _mutazione([_m(Bersaglio.forza, 1)]),
      _mutazione([_m(Bersaglio.forza, 2), _m(Bersaglio.intimidazione, 1)]),
      _mutazione(const []),
    ];

    expect(
      bonusCaratteristica('Forza', capacita: const [], mutazioni: mutazioni),
      3,
    );
    expect(
      bonusAbilita('Intimidazione', capacita: const [], mutazioni: mutazioni),
      1,
    );
  });

  test('i bonus delle diverse sorgenti si sommano', () {
    final bonus = bonusCaratteristica(
      'Forza',
      capacita: [
        _capacita([_m(Bersaglio.forza, 1)]),
      ],
      background: _background([_m(Bersaglio.forza, 2)]),
      mutazioni: [
        _mutazione([_m(Bersaglio.forza, 4)]),
      ],
    );

    expect(bonus, 7);
  });

  test('una caratteristica non toccata resta a 0', () {
    expect(
      bonusCaratteristica(
        'Volontà',
        capacita: [
          _capacita([_m(Bersaglio.forza, 3)]),
        ],
        background: _background(),
        mutazioni: [
          _mutazione([_m(Bersaglio.agilita, 2)]),
        ],
      ),
      0,
    );
  });

  test('i modificatori negativi sottraggono', () {
    expect(
      bonusCaratteristica(
        'Agilità',
        capacita: const [],
        mutazioni: [
          _mutazione([_m(Bersaglio.agilita, -2)]),
        ],
      ),
      -2,
    );
  });

  test('senza sorgenti il bonus è zero', () {
    expect(bonusCaratteristica('Forza', capacita: const []), 0);
    expect(bonusAbilita('Percezione', capacita: const []), 0);
  });

  group('valori della Scheda', () {
    test('ogni valore somma alla formula i suoi modificatori', () {
      final senza = _scheda();
      final con = _scheda(
        capacita: [
          _capacita([
            _m(Bersaglio.ferite, 2),
            _m(Bersaglio.shock, 1),
            _m(Bersaglio.difesa, 1),
            _m(Bersaglio.resilienza, 1),
            _m(Bersaglio.grinta, 1),
            _m(Bersaglio.fermezza, 1),
            _m(Bersaglio.risolutezza, 1),
            _m(Bersaglio.influenza, 1),
            _m(Bersaglio.percezionePassiva, 1),
          ]),
        ],
      );

      expect(con.feriteMassime, senza.feriteMassime + 2);
      expect(con.shockMassimo, senza.shockMassimo + 1);
      expect(con.difesaBase, senza.difesaBase + 1);
      // La Resilienza Base entra in quella Fisica e in quella Energetica.
      expect(con.resilienzaFisica, senza.resilienzaFisica + 1);
      expect(con.resilienzaEnergetica, senza.resilienzaEnergetica + 1);
      expect(con.grinta, senza.grinta + 1);
      expect(con.fermezza, senza.fermezza + 1);
      expect(con.risolutezza, senza.risolutezza + 1);
      expect(con.influenza, senza.influenza + 1);
      expect(con.percezionePassiva, senza.percezionePassiva + 1);
    });

    test('Velocità, Ferite e Riserva Furtiva prendono i loro bonus', () {
      final scheda = _scheda(
        furtivitaPassiva: 4,
        mutazioni: [
          _mutazione([
            _m(Bersaglio.velocita, -1),
            _m(Bersaglio.ferite, 1),
            _m(Bersaglio.riservaFurtiva, 2),
          ]),
        ],
      );

      expect(scheda.velocitaBonus, -1);
      expect(scheda.velocitaTotale, 6 - 1);
      // Ferite Massime = Resistenza (3) + bonus.
      expect(scheda.feriteMassime, 3 + 1);
      // La Riserva Furtiva è scritta a mano: il bonus si somma a quella.
      expect(scheda.riservaFurtivaTotale, 4 + 2);
    });

    test('Resilienza Fisica ed Energetica hanno bonus separati', () {
      final senza = _scheda();
      final con = _scheda(
        capacita: [
          _capacita([
            _m(Bersaglio.resilienzaFisica, -1),
            _m(Bersaglio.resilienzaEnergetica, 2),
          ]),
        ],
      );

      expect(con.resilienzaFisica, senza.resilienzaFisica - 1);
      expect(con.resilienzaEnergetica, senza.resilienzaEnergetica + 2);
    });

    test('un modificatore di Caratteristica non tocca i valori di Scheda', () {
      // Forza non entra in nessuna formula di Scheda: alzarla non deve
      // cambiare Ferite o Velocità.
      final senza = _scheda();
      final con = _scheda(
        capacita: [
          _capacita([_m(Bersaglio.forza, 5)]),
        ],
      );

      expect(con.feriteMassime, senza.feriteMassime);
      expect(con.velocitaTotale, senza.velocitaTotale);
    });
  });

  group('salvataggi di prima', () {
    test('un Modificatore col solo nome diventa il suo Bersaglio', () {
      final m = Modificatore.fromJson({'nome': 'Mischia Leggera', 'valore': 2});
      expect(m.bersaglio, Bersaglio.mischiaLeggera);
      expect(m.valore, 2);
    });

    test('i vecchi campi singoli diventano la lista di modificatori', () {
      final vecchia = {
        'nome': 'Vista Acuta',
        'tipo': 'razza',
        'descrizione': '',
        'effetto': '',
        'modificatoreCaratteristica': {'nome': 'Intelletto', 'valore': 1},
        'modificatoreAbilita': {'nome': 'Percezione', 'valore': 1},
        'costo': 0,
        'tag': <String>[],
      };

      final capacita = Capacita.fromJson(vecchia);
      expect(capacita.modificatori.map((m) => m.testo), [
        'Intelletto +1',
        'Percezione +1',
      ]);

      // E risalvata usa la forma nuova, che si rilegge uguale.
      final riletta = Capacita.fromJson(capacita.toJson());
      expect(riletta.modificatori.map((m) => m.testo), [
        'Intelletto +1',
        'Percezione +1',
      ]);
    });

    test('una Mutazione salvata senza modificatori ne ha zero', () {
      final mutazione = Mutazione.fromJson({
        'nome': 'Mutazione',
        'descrizione': '',
        'effetto': '',
        'modificatoreCaratteristica': null,
      });
      expect(mutazione.modificatori, isEmpty);
    });
  });

  testWidgets('in Scheda il bonus della Mutazione arriva alla Caratteristica', (
    tester,
  ) async {
    // Le Mutazioni si prendono dalla Scheda, quindi è lì che il loro
    // Modificatore deve farsi vedere.
    final mutazione = listaMutazioni.firstWhere(
      (m) => m.modificatori.any(
        (x) => x.bersaglio.categoria == CategoriaBersaglio.caratteristica,
      ),
    );
    final modificatore = mutazione.modificatori.firstWhere(
      (x) => x.bersaglio.categoria == CategoriaBersaglio.caratteristica,
    );
    final nomeCaratteristica = modificatore.bersaglio.label;
    final valore = modificatore.valore;

    final scheda = _scheda(mutazioni: [mutazione]);

    await tester.pumpWidget(
      MaterialApp(
        home: SchedaPage(scheda: scheda, onModificata: (_) {}),
      ),
    );
    await vaiAllaPagina(tester, 'Abilità');

    // La riga della Caratteristica toccata: Totale, Base, Bonus.
    final riga = find
        .ancestor(of: find.text(nomeCaratteristica), matching: find.byType(Row))
        .first;
    expect(
      find.descendant(of: riga, matching: find.text('${3 + valore}')),
      findsOneWidget,
      reason: 'il Valore Totale deve comprendere il bonus della Mutazione',
    );
    expect(
      find.descendant(of: riga, matching: find.text('$valore')),
      findsWidgets,
      reason: 'il Valore Bonus deve valere quanto il Modificatore',
    );
  });
}
