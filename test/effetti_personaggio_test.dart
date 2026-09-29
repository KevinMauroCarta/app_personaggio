// I Modificatori di una Capacità posseduta alimentano il Valore Bonus
// della Caratteristica/Abilità indicata, e i suoi Tag entrano nei Tag del
// personaggio (Modello/Capacità).

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/enums/densita_popolativa.dart';
import 'package:app_personaggio/enums/grandezza_pianeta.dart';
import 'package:app_personaggio/enums/tipologia_pianeta.dart';
import 'package:app_personaggio/models/background.dart';
import 'package:app_personaggio/models/modificatore.dart';
import 'package:app_personaggio/models/pianeta.dart';
import 'package:app_personaggio/enums/taglia.dart';
import 'package:app_personaggio/models/razza.dart';
import 'package:app_personaggio/models/sistema.dart';
import 'package:app_personaggio/models/talento.dart';
import 'package:app_personaggio/services/effetti_personaggio.dart';

Capacita _capacita({
  required String nome,
  Modificatore? caratteristica,
  Modificatore? abilita,
  List<String> tag = const [],
}) {
  return Capacita(
    nome: nome,
    tipo: TipoCapacita.generica,
    descrizione: '',
    effetto: '',
    modificatoreCaratteristica: caratteristica,
    modificatoreAbilita: abilita,
    costo: 2,
    tag: tag,
  );
}

Razza _razza(String tag) => Razza(
  nome: 'Razza',
  descrizione: '',
  capacita: const [],
  tag: tag,
  taglia: Taglia.media,
);

Sistema _sistema(String tag) => Sistema(nome: 'Sistema', governo: '', tag: tag);

Pianeta _pianeta(List<String> tag) => Pianeta(
  nome: 'Pianeta',
  grandezza: GrandezzaPianeta.medio,
  tipologia: TipologiaPianeta.roccioso,
  luna: false,
  capitale: '',
  densitaPopolativa: DensitaPopolativa.nessuna,
  tag: tag,
);

Background _background(String tag) => Background(
  nome: 'Background',
  descrizione: '',
  capacitaDiBackground: _capacita(nome: 'Capacità del Background'),
  tag: tag,
);

Talento _talento(String tag) =>
    Talento(nome: 'Talento', descrizione: '', effetto: '', tag: tag);

void main() {
  final capacita = [
    _capacita(
      nome: 'Impeto',
      caratteristica: const Modificatore(nome: 'Forza', valore: 1),
      tag: const ['Brutale'],
    ),
    _capacita(
      nome: 'Vista Acuta',
      caratteristica: const Modificatore(nome: 'Forza', valore: 2),
      abilita: const Modificatore(nome: 'Percezione', valore: 1),
      tag: const ['Brutale', 'Vigile'],
    ),
    _capacita(nome: 'Senza effetti'),
  ];

  // I Modificatori hanno un file tutto loro: modificatori_test.dart.

  test('i tag arrivano da tutte le scelte, senza doppioni', () {
    final tag = tagDelPersonaggio(
      razza: _razza('Tag-Razza'),
      sistema: _sistema('Tag-Sistema'),
      pianeta: _pianeta(const ['Tag-Pianeta', 'Brutale']),
      background: _background('Tag-Background'),
      capacita: capacita,
      talenti: [_talento('Tag-Talento')],
    );

    expect(tag, [
      'Tag-Razza',
      'Tag-Sistema',
      'Tag-Pianeta',
      // "Brutale" arriva sia dal pianeta sia da due capacità: compare
      // una volta sola, nella posizione in cui è stato visto per primo.
      'Brutale',
      'Tag-Background',
      'Vigile',
      'Tag-Talento',
    ]);
  });

  test('i tag vuoti non entrano nella lista', () {
    final tag = tagDelPersonaggio(
      razza: _razza(''),
      sistema: _sistema(''),
      pianeta: _pianeta(const []),
      background: _background('Solo-Questo'),
      capacita: const [],
      talenti: const [],
    );

    expect(tag, ['Solo-Questo']);
  });

  test('senza nessuna scelta con tag il personaggio non ha tag', () {
    expect(
      tagDelPersonaggio(
        razza: _razza(''),
        sistema: _sistema(''),
        pianeta: _pianeta(const []),
        background: _background(''),
        capacita: const [],
        talenti: const [],
      ),
      isEmpty,
    );
  });
}
