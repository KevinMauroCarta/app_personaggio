// Verifica che una Scheda salvata sopravviva al riavvio dell'app: viene
// scritta su SharedPreferences da una istanza di CharacterStorage e
// riletta da una istanza nuova (come farebbe la Home al prossimo avvio).

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_capacita.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_lesioni_memorabili.dart';
import 'package:app_personaggio/data/lista_mutazioni.dart';
import 'package:app_personaggio/data/lista_poteri_psionici.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_talenti.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/grado_ferita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/armatura.dart';
import 'package:app_personaggio/enums/abilita_arma.dart';
import 'package:app_personaggio/enums/rarita.dart';
import 'package:app_personaggio/enums/tipo_danno.dart';
import 'package:app_personaggio/data/lista_tratti.dart';
import 'package:app_personaggio/models/armi/arma_distanza.dart';
import 'package:app_personaggio/models/armi/arma_mischia.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/ferite.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/services/character_storage.dart';

Scheda _schedaDiProva() {
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
            (c) => CaratteristicaPersonaggio(
              caratteristica: c,
              valoreBase: 3,
              valoreBonus: 1,
            ),
          )
          .toList(),
      abilita: listaAbilita
          .map(
            (a) =>
                AbilitaPersonaggio(abilita: a, valoreBase: 2, valoreBonus: 1),
          )
          .toList(),
      talenti: [listaTalenti.first],
      capacita: [listaCapacita.first],
      lesioniMemorabili: [listaLesioniMemorabili.first],
      mutazioni: [listaMutazioni.first],
      corruzione: 4,
      poteriPsionici: [listaPoteriPsionici.first],
      tag: const ['Militare'],
      pxDisponibili: 17,
    ),
    keyword: const ['Imperiale', 'Psionico'],
    iraAttuale: 5,
    velocitaBonus: 2,
    ferite: const Ferite(attuali: 3, bonus: 2, gradoFerita: GradoFerita.due),
    equipaggiamento: Equipaggiamento(
      armi: [
        ArmaDistanza(
          nome: 'Fucile',
          abilitaAssociata: AbilitaArma.mira,
          danno: 10,
          tipoDanno: TipoDanno.fisico,
          dadiExtra: 2,
          valorePenetrazione: 1,
          gittataCorta: 10,
          gittataMedia: 20,
          gittataLunga: 40,
          raffica: true,
          tratti: [listaTratti[0]],
          tag: const ['Rapido'],
          valore: 50,
          rarita: Rarita.rara,
        ),
        ArmaMischia(
          nome: 'Coltello',
          abilitaAssociata: AbilitaArma.mischiaLeggera,
          danno: 4,
          tipoDanno: TipoDanno.fisico,
          gittata: 1,
          valore: 5,
          rarita: Rarita.comune,
        ),
      ],
      armatura: Armatura(
        nome: 'Corazza',
        pa: 4,
        paEnergia: 2,
        tratti: [listaTratti[1], listaTratti[2]],
        valore: 40,
        rarita: Rarita.nonComune,
      ),
      oggetti: const ['Corda', 'Razioni'],
      ricchezza: 6,
    ),
    furtivitaPassiva: 7,
    shockAttuale: 5,
    note: const ['Cerca il fratello scomparso.', 'Deve un favore a Vhal.'],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('una Scheda salvata viene riletta identica al riavvio', () async {
    SharedPreferences.setMockInitialValues({});
    final scheda = _schedaDiProva();

    await CharacterStorage().aggiungiScheda(scheda);

    // Istanza nuova = nuovo avvio dell'app.
    final riletta = (await CharacterStorage().caricaSchede()).single;

    expect(riletta.toJson(), scheda.toJson());
    expect(riletta.personaggio.nome, 'Kaleb');
    expect(riletta.personaggio.pxDisponibili, 17);
    expect(riletta.iraAttuale, 5);
    expect(riletta.furtivitaPassiva, 7);
    expect(riletta.shockAttuale, 5);
    expect(riletta.ferite.attuali, 3);
    expect(riletta.note, [
      'Cerca il fratello scomparso.',
      'Deve un favore a Vhal.',
    ]);
    expect(riletta.equipaggiamento.armatura?.paEnergia, 2);
    expect(riletta.equipaggiamento.armatura?.tratti.length, 2);
    expect(
      riletta.equipaggiamento.armatura?.tratti.first.nome,
      listaTratti[1].nome,
    );
    expect(riletta.personaggio.abilita.length, listaAbilita.length);
  });

  test('aggiornaScheda sovrascrive solo la scheda indicata', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = CharacterStorage();
    final scheda = _schedaDiProva();

    await storage.aggiungiScheda(scheda);
    await storage.aggiungiScheda(
      scheda.copyWith(
        personaggio: Personaggio.fromJson(
          scheda.personaggio.toJson()..['nome'] = 'Seconda',
        ),
      ),
    );
    await storage.aggiornaScheda(0, scheda.copyWith(iraAttuale: 9));

    final schede = await CharacterStorage().caricaSchede();
    expect(schede.length, 2);
    expect(schede[0].iraAttuale, 9);
    expect(schede[1].personaggio.nome, 'Seconda');
  });

  test('i personaggi salvati nel vecchio formato non vanno persi', () async {
    final personaggio = _schedaDiProva().personaggio;
    SharedPreferences.setMockInitialValues({
      'personaggi_salvati': [jsonEncode(personaggio.toJson())],
    });

    final schede = await CharacterStorage().caricaSchede();
    expect(schede.single.personaggio.nome, 'Kaleb');
    expect(schede.single.iraAttuale, Scheda.iraIniziale);
  });

  test('una scheda illeggibile non fa perdere le altre', () async {
    SharedPreferences.setMockInitialValues({
      'personaggi_salvati': [
        '{non è json',
        jsonEncode(_schedaDiProva().toJson()),
      ],
    });

    final schede = await CharacterStorage().caricaSchede();
    expect(schede.single.personaggio.nome, 'Kaleb');
  });
}
