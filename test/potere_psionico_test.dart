// Modello/Potere_Psionico e Modello/Durata: i due casi di durata
// (istantanea e a tempo) e la serializzazione del potere.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/enums/scuola_psionica.dart';
import 'package:app_personaggio/enums/tipo_azione.dart';
import 'package:app_personaggio/models/durata.dart';
import 'package:app_personaggio/models/potere_psionico.dart';

void main() {
  test('una durata istantanea si scrive "-"', () {
    const durata = Durata.istantanea();
    expect(durata.istantanea, isTrue);
    expect(durata.quantita, isNull);
    expect(durata.etichetta, '-');
  });

  test('una durata a tempo concorda singolare e plurale', () {
    expect(const Durata.per(1, UnitaDurata.round).etichetta, '1 round');
    expect(const Durata.per(3, UnitaDurata.round).etichetta, '3 round');
    expect(const Durata.per(1, UnitaDurata.minuti).etichetta, '1 minuto');
    expect(const Durata.per(10, UnitaDurata.minuti).etichetta, '10 minuti');
    expect(const Durata.per(1, UnitaDurata.ore).etichetta, '1 ora');
    expect(const Durata.per(2, UnitaDurata.ore).etichetta, '2 ore');
  });

  test('una durata a tempo non è istantanea', () {
    const durata = Durata.per(3, UnitaDurata.round);
    expect(durata.istantanea, isFalse);
    expect(durata.quantita, 3);
    expect(durata.unita, UnitaDurata.round);
  });

  test('entrambe le durate sopravvivono al salvataggio', () {
    for (final durata in const [
      Durata.istantanea(),
      Durata.per(10, UnitaDurata.minuti),
    ]) {
      final riletta = Durata.fromJson(durata.toJson());
      expect(riletta.toJson(), durata.toJson());
      expect(riletta.etichetta, durata.etichetta);
    }
  });

  test('un potere psionico sopravvive al salvataggio con tutti i campi', () {
    const potere = PoterePsionico(
      nome: 'Lancia Mentale',
      scuola: ScuolaPsionica.telepatia,
      descrizione: 'Un proiettile psichico.',
      effetto: 'Danno mentale diretto.',
      cd: 3,
      attivazione: TipoAzione.standard,
      durata: Durata.istantanea(),
      gittata: 12,
      multiBersaglio: true,
      costo: 10,
    );

    final riletto = PoterePsionico.fromJson(potere.toJson());

    expect(riletto.toJson(), potere.toJson());
    expect(riletto.scuola, ScuolaPsionica.telepatia);
    expect(riletto.attivazione, TipoAzione.standard);
    expect(riletto.cd, 3);
    expect(riletto.gittata, 12);
    expect(riletto.multiBersaglio, isTrue);
    expect(riletto.costo, 10);
    expect(riletto.durata.istantanea, isTrue);
  });

  test('il catalogo copre tutte le scuole e tutti i casi di durata', () {
    expect(
      listaPoteriPsionici.map((p) => p.scuola).toSet(),
      ScuolaPsionica.values.toSet(),
    );
    expect(listaPoteriPsionici.any((p) => p.durata.istantanea), isTrue);
    expect(listaPoteriPsionici.any((p) => !p.durata.istantanea), isTrue);
  });
}
