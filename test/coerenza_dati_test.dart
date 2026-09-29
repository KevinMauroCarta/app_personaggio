// I Modificatori delle Capacità vengono applicati cercando per nome la
// Caratteristica o l'Abilità corrispondente: un nome che non esiste in
// Lista/Caratteristiche o Lista/Abilità non darebbe nessun bonus, senza
// che niente lo segnali. Qui si verifica che ogni nome esista davvero, e
// che il testo dell'Effetto li riporti tutti.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_tag.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';

void main() {
  final nomiCaratteristiche = listaCaratteristiche.map((c) => c.nome).toSet();
  final nomiAbilita = listaAbilita.map((a) => a.nome).toSet();

  test('ogni modificatore punta a una Caratteristica esistente', () {
    for (final c in listaCapacita) {
      final m = c.modificatoreCaratteristica;
      if (m == null) continue;
      expect(
        nomiCaratteristiche,
        contains(m.nome),
        reason: '"${c.nome}" modifica la caratteristica "${m.nome}"',
      );
    }
  });

  test('ogni modificatore punta a un Abilità esistente', () {
    for (final c in listaCapacita) {
      final m = c.modificatoreAbilita;
      if (m == null) continue;
      expect(
        nomiAbilita,
        contains(m.nome),
        reason: '"${c.nome}" modifica l\'abilità "${m.nome}"',
      );
    }
  });

  test('l Effetto riporta tutti i modificatori della capacità', () {
    for (final c in listaCapacita) {
      for (final m in [c.modificatoreCaratteristica, c.modificatoreAbilita]) {
        if (m == null) continue;
        final atteso = '${m.nome} ${m.valore >= 0 ? '+' : ''}${m.valore}';
        expect(
          c.effetto,
          contains(atteso),
          reason: 'l\'effetto di "${c.nome}" non cita "$atteso"',
        );
      }
    }
  });

  test('ogni capacità ha descrizione ed effetto scritti', () {
    for (final c in listaCapacita) {
      expect(c.descrizione.trim(), isNotEmpty, reason: c.nome);
      expect(c.effetto.trim(), isNotEmpty, reason: c.nome);
    }
  });

  test('ogni talento ha descrizione ed effetto scritti', () {
    for (final t in listaTalenti) {
      expect(t.descrizione.trim(), isNotEmpty, reason: t.nome);
      expect(t.effetto.trim(), isNotEmpty, reason: t.nome);
      expect(
        t.effetto,
        isNot(contains('template-')),
        reason: '"${t.nome}" ha ancora un effetto segnaposto',
      );
    }
  });

  test('ogni razza ha le sue Capacità di Razza, tutte di tipo razza', () {
    for (final r in listaRazze) {
      expect(r.capacita, isNotEmpty, reason: r.nome);
      for (final c in r.capacita) {
        expect(c.tipo, TipoCapacita.razza, reason: '${r.nome} / ${c.nome}');
        expect(c.descrizione.trim(), isNotEmpty, reason: c.nome);
        expect(c.effetto.trim(), isNotEmpty, reason: c.nome);
      }
    }
  });

  test('il tag di una razza è il nome della razza stessa', () {
    for (final r in listaRazze) {
      expect(r.tag, r.nome);
    }
  });

  test('ogni tag usato nei dati viene da Lista/Tag', () {
    // tagDaNome lancia su un nome inesistente: se i dati si risolvono
    // senza errori, nessun tag è stato scritto a mano.
    final nomiCatalogo = listaTag.map((t) => t.nome).toSet();

    void verifica(String tag, String dove) {
      expect(nomiCatalogo, contains(tag), reason: dove);
    }

    for (final r in listaRazze) {
      verifica(r.tag, 'razza ${r.nome}');
    }
    for (final b in listaBackground) {
      verifica(b.tag, 'background ${b.nome}');
    }
    for (final t in listaTalenti) {
      verifica(t.tag, 'talento ${t.nome}');
    }
    for (final c in listaCapacita) {
      for (final tag in c.tag) {
        verifica(tag, 'capacità ${c.nome}');
      }
    }
    for (final a in listaArmi) {
      for (final tag in a.tag) {
        verifica(tag, 'arma ${a.nome}');
      }
    }
  });

  test('nessun tag del catalogo è ripetuto', () {
    final nomi = listaTag.map((t) => t.nome).toList();
    expect(nomi.toSet().length, nomi.length);
  });

  test('nessuna Capacità di Razza resta senza una razza che la offra', () {
    final assegnate = listaRazze.expand((r) => r.capacita).map((c) => c.nome);
    final diRazza = listaCapacita.where((c) => c.tipo == TipoCapacita.razza);
    for (final c in diRazza) {
      expect(
        assegnate,
        contains(c.nome),
        reason: '"${c.nome}" non è offerta da nessuna razza',
      );
    }
  });

  test('solo le Capacità Generiche si pagano in PE', () {
    for (final c in listaCapacita) {
      if (c.tipo == TipoCapacita.generica) {
        expect(c.costo, greaterThan(0), reason: c.nome);
      } else {
        // Razza, Sistema e Background arrivano da scelte già fatte: non
        // sono una spesa e devono costare 0.
        expect(
          c.costo,
          0,
          reason: '"${c.nome}" (${c.tipo.label}) deve costare 0',
        );
      }
    }
  });

  test('ogni background ha una Capacità di Background di tipo background', () {
    for (final b in listaBackground) {
      final c = b.capacitaDiBackground;
      expect(c.tipo, TipoCapacita.background, reason: '${b.nome} / ${c.nome}');
      expect(c.descrizione.trim(), isNotEmpty, reason: c.nome);
      expect(c.effetto.trim(), isNotEmpty, reason: c.nome);
    }
  });

  test('il legame background-capacità è uno a uno', () {
    final collegate = listaBackground
        .map((b) => b.capacitaDiBackground.nome)
        .toList();

    // Nessuna capacità è condivisa fra due background...
    expect(collegate.toSet().length, collegate.length);

    // ...e nessuna Capacità di Background resta senza il suo background.
    final diBackground = listaCapacita.where(
      (c) => c.tipo == TipoCapacita.background,
    );
    for (final c in diBackground) {
      expect(
        collegate,
        contains(c.nome),
        reason: '"${c.nome}" non è collegata a nessun background',
      );
    }
  });
}
