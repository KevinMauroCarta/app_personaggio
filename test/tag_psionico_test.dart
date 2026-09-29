// I Poteri Psionici si possono prendere in creazione solo se una delle
// scelte fatte ha dato al personaggio il tag Psionico.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/enums/tipo_capacita.dart';
import 'package:app_personaggio/models/capacita.dart';
import 'package:app_personaggio/screens/creazione_pg/creazione_pg_dati.dart'
    show costoPoterePsionico;
import 'package:app_personaggio/services/effetti_personaggio.dart';

void main() {
  final razza = listaRazze.first;
  final sistema = listaSistemi.first;
  final background = listaBackground.first;

  List<String> tagCon(List<Capacita> capacita) => tagDelPersonaggio(
    razza: razza,
    sistema: sistema,
    pianeta: sistema.pianeti.first,
    background: background,
    capacita: capacita,
    talenti: const [],
  );

  test('esiste almeno una scelta che dà il tag Psionico', () {
    final sorgenti = listaCapacita.where((c) => c.tag.contains(tagPsionico));
    expect(
      sorgenti,
      isNotEmpty,
      reason:
          'senza nessuna sorgente del tag "$tagPsionico" i Poteri '
          'Psionici sarebbero irraggiungibili',
    );
  });

  test('senza la capacità giusta il personaggio non è psionico', () {
    final nonPsionica = listaCapacita.firstWhere(
      (c) => c.tipo == TipoCapacita.generica && !c.tag.contains(tagPsionico),
    );
    expect(haTagPsionico(tagCon([nonPsionica])), isFalse);
  });

  test('prendendo Addestramento Psichico il personaggio diventa psionico', () {
    final psionica = listaCapacita.firstWhere(
      (c) => c.nome == 'Addestramento Psichico',
    );
    expect(psionica.tag, contains(tagPsionico));
    expect(haTagPsionico(tagCon([psionica])), isTrue);
  });

  test('togliendo quella capacità il tag sparisce', () {
    final psionica = listaCapacita.firstWhere(
      (c) => c.nome == 'Addestramento Psichico',
    );
    expect(haTagPsionico(tagCon([psionica])), isTrue);
    // I tag sono ricalcolati da zero a ogni salvataggio: basta togliere
    // la capacità perché il personaggio smetta di essere psionico.
    expect(haTagPsionico(tagCon(const [])), isFalse);
  });

  test('ogni potere psionico ha un costo in PE', () {
    for (final p in listaPoteriPsionici) {
      expect(p.costo, greaterThan(0), reason: p.nome);
      expect(costoPoterePsionico(p.nome), p.costo);
    }
  });

  test('prendere e togliere un potere lascia i PE come erano', () {
    final potere = listaPoteriPsionici.first;
    var pe = 100;

    pe -= costoPoterePsionico(potere.nome);
    expect(pe, 100 - potere.costo);

    pe += costoPoterePsionico(potere.nome);
    expect(pe, 100);
  });

  test('perdendo il tag si riprendono i PE spesi nei poteri', () {
    // Quello che fa _sincronizzaPoteriPsionici: i poteri scelti vengono
    // tolti e il loro costo restituito.
    final scelti = listaPoteriPsionici.take(2).toList();
    var pe = 100;
    for (final p in scelti) {
      pe -= costoPoterePsionico(p.nome);
    }
    expect(pe, 100 - scelti.fold<int>(0, (s, p) => s + p.costo));

    for (final p in scelti) {
      pe += costoPoterePsionico(p.nome);
    }
    expect(pe, 100);
  });

  test('il tag Psionico è raggiungibile da una Capacità Generica', () {
    // Le Capacità di Sistema dipendono dal sistema di origine scelto:
    // se l'unica via al tag fosse una di quelle, molti personaggi non
    // potrebbero mai diventare psionici.
    final generichePsioniche = listaCapacita.where(
      (c) => c.tipo == TipoCapacita.generica && c.tag.contains(tagPsionico),
    );
    expect(generichePsioniche, isNotEmpty);
    expect(
      generichePsioniche.map((c) => c.nome),
      contains('Memoria Fotografica'),
    );
  });

  test('Memoria Fotografica rende psionico il personaggio', () {
    final memoria = listaCapacita.firstWhere(
      (c) => c.nome == 'Memoria Fotografica',
    );
    expect(haTagPsionico(tagCon([memoria])), isTrue);
  });

  test('anche un Talento può dare il tag Psionico', () {
    final memoriaArca = listaTalenti.firstWhere(
      (t) => t.nome == 'Memoria d\'Arca',
    );
    expect(memoriaArca.tag, tagPsionico);

    final tag = tagDelPersonaggio(
      razza: razza,
      sistema: sistema,
      pianeta: sistema.pianeti.first,
      background: background,
      capacita: const [],
      talenti: [memoriaArca],
    );
    expect(haTagPsionico(tag), isTrue);
  });
}
