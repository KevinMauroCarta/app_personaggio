// Modello/Tratto: un modello unico per Armi e Armature, dove ambiti dice
// dove il tratto si applica. Alcuni tratti prendono un valore fra
// parentesi ("Scudo (X)"), e quelli con un effetto senza condizioni
// portano Modificatori che valgono finché l'arma o l'armatura è in uso.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_abilita.dart';
import 'package:app_personaggio/data/lista_background.dart';
import 'package:app_personaggio/data/lista_caratteristiche.dart';
import 'package:app_personaggio/data/lista_razze.dart';
import 'package:app_personaggio/data/lista_sistemi.dart';
import 'package:app_personaggio/data/lista_tratti.dart';
import 'package:app_personaggio/enums/ambito_tratto.dart';
import 'package:app_personaggio/enums/bersaglio.dart';
import 'package:app_personaggio/enums/genere.dart';
import 'package:app_personaggio/enums/rarita.dart';
import 'package:app_personaggio/models/abilita_personaggio.dart';
import 'package:app_personaggio/models/armatura.dart';
import 'package:app_personaggio/models/caratteristica_personaggio.dart';
import 'package:app_personaggio/models/equipaggiamento.dart';
import 'package:app_personaggio/models/personaggio.dart';
import 'package:app_personaggio/models/scheda.dart';
import 'package:app_personaggio/models/tratto.dart';
import 'package:app_personaggio/services/effetti_personaggio.dart';

/// Una Scheda con tutte le Caratteristiche a 3, che indossa [armatura].
Scheda _scheda({Armatura? armatura}) {
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
      caratteristiche: [
        for (final c in listaCaratteristiche)
          CaratteristicaPersonaggio(caratteristica: c, valoreBase: 3),
      ],
      abilita: [
        for (final a in listaAbilita)
          AbilitaPersonaggio(abilita: a, valoreBase: 0),
      ],
    ),
    equipaggiamento: Equipaggiamento(armatura: armatura),
  );
}

Armatura _armatura(List<Tratto> tratti) => Armatura(
  nome: 'Prova',
  pa: 0,
  paEnergia: 0,
  tratti: tratti,
  valore: 0,
  rarita: Rarita.comune,
);

void main() {
  const condiviso = Tratto(
    nome: 'Sacro',
    descrizione: 'Benedetto.',
    effetto: '+1 contro i corrotti.',
    ambiti: [AmbitoTratto.arma, AmbitoTratto.armatura],
  );

  test('un tratto sa dove si applica', () {
    expect(condiviso.valePerArmi, isTrue);
    expect(condiviso.valePerArmature, isTrue);
    expect(tratto('Parata').valePerArmature, isFalse);
    expect(tratto('Scudo', '1').valePerArmi, isFalse);
  });

  test('un tratto sopravvive al salvataggio con valore e modificatori', () {
    final scudo = tratto('Scudo', '2');
    final riletto = Tratto.fromJson(scudo.toJson());
    expect(riletto.toJson(), scudo.toJson());
    expect(riletto.etichetta, 'Scudo (2)');
    expect(riletto.modificatoriEffettivi.single.valore, 2);
  });

  test('le liste filtrate contengono solo i tratti dell ambito giusto', () {
    expect(trattiArma.every((t) => t.valePerArmi), isTrue);
    expect(trattiArmatura.every((t) => t.valePerArmature), isTrue);
    expect(trattiArma.length + trattiArmatura.length, listaTratti.length);
  });

  test('il catalogo ha nomi unici', () {
    final nomi = listaTratti.map((t) => t.nome).toList();
    expect(nomi.toSet(), hasLength(nomi.length));
  });

  group('valore fra parentesi', () {
    test('nel catalogo si legge il segnaposto, sull arma il valore', () {
      expect(
        listaTratti.firstWhere((t) => t.nome == 'Scudo').etichetta,
        'Scudo (X)',
      );
      expect(tratto('Scudo', '3').etichetta, 'Scudo (3)');
      expect(tratto('Infligge', 'In Fiamme').etichetta, 'Infligge (In Fiamme)');
      expect(tratto('Parata').etichetta, 'Parata');
    });

    test('il valore va dato solo ai tratti che lo prendono', () {
      expect(() => tratto('Scudo'), throwsArgumentError);
      expect(() => tratto('Parata', '1'), throwsArgumentError);
      expect(() => tratto('Inesistente'), throwsArgumentError);
    });
  });

  group('modificatori dei tratti', () {
    test('solo Scudo, Massiccia e Potenziata ne hanno', () {
      // Gli altri effetti hanno condizioni (Parata solo in mischia,
      // Psichica solo per chi è Psionico...) e restano nel testo.
      expect(
        listaTratti.where((t) => t.modificatori.isNotEmpty).map((t) => t.nome),
        unorderedEquals(['Scudo', 'Massiccia', 'Potenziata']),
      );
    });

    test('valgono per ogni punto di X', () {
      List<String> testi(Tratto t) =>
          t.modificatoriEffettivi.map((m) => m.testo).toList();

      expect(testi(tratto('Scudo', '2')), ['Difesa +2']);
      expect(testi(tratto('Massiccia', '3')), ['Velocità -3']);
      expect(testi(tratto('Potenziata', '1')), ['Forza +1']);
    });

    test('l armatura indossata cambia Difesa e Velocità', () {
      final senza = _scheda();
      final con = _scheda(
        armatura: _armatura([tratto('Scudo', '2'), tratto('Massiccia', '1')]),
      );

      expect(con.difesaBase, senza.difesaBase + 2);
      expect(con.velocitaTotale, senza.velocitaTotale - 1);
    });

    test('Potenziata alza la Forza nel Valore Bonus', () {
      final scheda = _scheda(armatura: _armatura([tratto('Potenziata', '2')]));
      final ricalcolato = conEffettiRicalcolati(
        scheda.personaggio,
        equipaggiamento: scheda.equipaggiamento,
      );
      final forza = ricalcolato.caratteristiche.firstWhere(
        (c) => c.caratteristica.nome == 'Forza',
      );
      expect(forza.valoreBonus, 2);
      expect(forza.valoreTotale, 3 + 2);
    });

    test('un tratto condizionato non dà bonus', () {
      final arma = tratto('Parata');
      expect(arma.modificatoriEffettivi, isEmpty);
      expect(
        sommaModificatori(arma.modificatoriEffettivi, Bersaglio.difesa),
        0,
      );
    });
  });
}
