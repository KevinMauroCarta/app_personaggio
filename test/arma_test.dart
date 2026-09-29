// Modello/Armi: un'arma è da mischia o a distanza, e le due si
// distinguono proprio su gittata e raffica. Qui si verifica che ognuna
// porti i suoi campi, che sopravvivano al salvataggio tornando del tipo
// giusto, e che la Riserva di Dadi resti un valore del personaggio.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_tratti.dart';
import 'package:app_personaggio/enums/abilita_arma.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/rarita.dart';
import 'package:app_personaggio/enums/tipo_danno.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/armi/arma.dart';
import 'package:app_personaggio/models/armi/arma_distanza.dart';
import 'package:app_personaggio/models/armi/arma_mischia.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';

void main() {
  test('un arma da mischia ha una sola gittata', () {
    final arma = ArmaMischia(
      nome: 'Spada',
      abilitaAssociata: AbilitaArma.mischiaPesante,
      danno: 5,
      tipoDanno: TipoDanno.fisico,
      gittata: 2,
      valore: 10,
      rarita: Rarita.comune,
    );

    expect(arma.etichettaGittata, '2');
    expect(arma.descrizioneTipo, 'Mischia');
    // I campi opzionali della base partono a zero/vuoto.
    expect(arma.dadiExtra, 0);
    expect(arma.valorePenetrazione, 0);
    expect(arma.tratti, isEmpty);
    expect(arma.tag, isEmpty);
  });

  test('un arma a distanza ha tre gittate e può avere la raffica', () {
    final arma = ArmaDistanza(
      nome: 'Fucile',
      abilitaAssociata: AbilitaArma.mira,
      danno: 8,
      tipoDanno: TipoDanno.fisico,
      gittataCorta: 6,
      gittataMedia: 12,
      gittataLunga: 24,
      raffica: true,
      valore: 40,
      rarita: Rarita.rara,
    );

    expect(arma.etichettaGittata, '6 / 12 / 24');
    expect(arma.descrizioneTipo, 'Distanza');
    expect(arma.raffica, isTrue);
  });

  test('la raffica di default è spenta', () {
    final arma = ArmaDistanza(
      nome: 'Arco',
      abilitaAssociata: AbilitaArma.mira,
      danno: 4,
      tipoDanno: TipoDanno.fisico,
      gittataCorta: 5,
      gittataMedia: 10,
      gittataLunga: 15,
      valore: 8,
      rarita: Rarita.comune,
    );

    expect(arma.raffica, isFalse);
  });

  test('un arma da mischia sopravvive al salvataggio', () {
    final arma = ArmaMischia(
      nome: 'Ascia',
      abilitaAssociata: AbilitaArma.mischiaPesante,
      danno: 6,
      tipoDanno: TipoDanno.fisico,
      dadiExtra: 2,
      valorePenetrazione: 1,
      gittata: 1,
      tratti: [listaTratti[0], listaTratti[2]],
      tag: const ['Duro'],
      valore: 15,
      rarita: Rarita.nonComune,
    );

    // Arma.fromJson non sa in partenza che tipo sia: lo deduce dal JSON.
    final riletta = Arma.fromJson(arma.toJson());

    expect(riletta, isA<ArmaMischia>());
    expect(riletta.toJson(), arma.toJson());
    expect((riletta as ArmaMischia).gittata, 1);
    expect(riletta.valore, 15);
    expect(riletta.rarita, Rarita.nonComune);
    expect(riletta.tag.single, 'Duro');
    expect(riletta.tratti.map((t) => t.nome), [
      listaTratti[0].nome,
      listaTratti[2].nome,
    ]);
  });

  test('un arma a distanza sopravvive al salvataggio', () {
    final arma = ArmaDistanza(
      nome: 'Fucile',
      abilitaAssociata: AbilitaArma.mira,
      danno: 8,
      tipoDanno: TipoDanno.fisico,
      dadiExtra: 3,
      valorePenetrazione: 2,
      gittataCorta: 5,
      gittataMedia: 10,
      gittataLunga: 20,
      raffica: true,
      tratti: [listaTratti[0]],
      tag: const ['Rapido'],
      valore: 50,
      rarita: Rarita.moltoRara,
    );

    final riletta = Arma.fromJson(arma.toJson());

    expect(riletta, isA<ArmaDistanza>());
    expect(riletta.toJson(), arma.toJson());
    final distanza = riletta as ArmaDistanza;
    expect(distanza.gittataCorta, 5);
    expect(distanza.gittataMedia, 10);
    expect(distanza.gittataLunga, 20);
    expect(distanza.raffica, isTrue);
  });

  test('il tipo di danno sopravvive al salvataggio', () {
    final laser = ArmaDistanza(
      nome: 'Fucile Laser',
      abilitaAssociata: AbilitaArma.mira,
      danno: 6,
      tipoDanno: TipoDanno.energetico,
      gittataCorta: 10,
      gittataMedia: 20,
      gittataLunga: 40,
      valore: 70,
      rarita: Rarita.rara,
    );

    expect(Arma.fromJson(laser.toJson()).tipoDanno, TipoDanno.energetico);
  });

  test('le armi salvate nel vecchio formato non vanno perse', () {
    // Com'erano prima della divisione in due tipi: un solo modello, con
    // la gittata come oggetto.
    final vecchiaMischia = {
      'nome': 'Coltello',
      'gittata': {'mischia': 1, 'corta': null, 'media': null, 'lunga': null},
      'abilitaAssociata': 'mischiaLeggera',
      'danno': 3,
    };
    final vecchiaDistanza = {
      'nome': 'Pistola',
      'gittata': {'mischia': null, 'corta': 3, 'media': 6, 'lunga': 9},
      'abilitaAssociata': 'mira',
      'danno': 4,
      'raffica': true,
    };

    final mischia = Arma.fromJson(vecchiaMischia);
    expect(mischia, isA<ArmaMischia>());
    // Nel vecchio formato il tipo di danno non c'era: ricade su fisico.
    expect(mischia.tipoDanno, TipoDanno.fisico);
    expect((mischia as ArmaMischia).gittata, 1);
    expect(mischia.danno, 3);

    final distanza = Arma.fromJson(vecchiaDistanza);
    expect(distanza, isA<ArmaDistanza>());
    expect((distanza as ArmaDistanza).gittataLunga, 9);
    expect(distanza.raffica, isTrue);
  });

  test('la Riserva di Dadi si legge dall abilità associata all arma', () {
    final personaggio = Personaggio(
      nome: 'Kaleb',
      anni: 30,
      genere: Genere.maschio,
      razza: listaRazze.first,
      sistemaDiOrigine: listaSistemi.first,
      pianetaDiOrigine: listaSistemi.first.pianeti.first,
      background: listaBackground.first,
      caratteristiche: listaCaratteristiche
          .map(
            (c) => CaratteristicaPersonaggio(caratteristica: c, valoreBase: 4),
          )
          .toList(),
      abilita: listaAbilita
          .map(
            (a) => AbilitaPersonaggio(
              abilita: a,
              // Mira a 3, tutte le altre a 0: così il valore che torna
              // dice da solo quale abilità è stata usata.
              valoreBase: a.nome == 'Mira' ? 3 : 0,
            ),
          )
          .toList(),
    );
    final scheda = Scheda(personaggio: personaggio);

    final fucile = ArmaDistanza(
      nome: 'Fucile',
      abilitaAssociata: AbilitaArma.mira,
      danno: 6,
      tipoDanno: TipoDanno.fisico,
      gittataCorta: 5,
      gittataMedia: 10,
      gittataLunga: 20,
      valore: 30,
      rarita: Rarita.comune,
    );
    final spada = ArmaMischia(
      nome: 'Spada',
      abilitaAssociata: AbilitaArma.mischiaPesante,
      danno: 5,
      tipoDanno: TipoDanno.fisico,
      gittata: 2,
      valore: 12,
      rarita: Rarita.comune,
    );

    // Valore Totale = Valore Base + Valore Caratteristica + Bonus.
    expect(scheda.riservaDiDadi(fucile), 3 + 4);
    expect(scheda.riservaDiDadi(spada), 0 + 4);
  });
}
