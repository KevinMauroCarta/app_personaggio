// Modello/Tratto: un modello unico per Armi e Armature, dove ambiti dice
// dove il tratto si applica. Un tratto condiviso resta uno solo, con un
// unico testo, e compare in entrambe le liste filtrate.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_personaggio/data/lista_tratti.dart';
import 'package:app_personaggio/enums/ambito_tratto.dart';
import 'package:app_personaggio/models/tratto.dart';

void main() {
  const soloArma = Tratto(
    nome: 'Pesante',
    descrizione: 'Ingombrante da maneggiare.',
    effetto: '-1 ai test di Agilità.',
    ambiti: [AmbitoTratto.arma],
  );
  const condiviso = Tratto(
    nome: 'Sacro',
    descrizione: 'Benedetto.',
    effetto: '+1 contro i corrotti.',
    ambiti: [AmbitoTratto.arma, AmbitoTratto.armatura],
  );

  test('un tratto sa dove si applica', () {
    expect(soloArma.valePerArmi, isTrue);
    expect(soloArma.valePerArmature, isFalse);
    expect(condiviso.valePerArmi, isTrue);
    expect(condiviso.valePerArmature, isTrue);
  });

  test('un tratto sopravvive al salvataggio con i suoi ambiti', () {
    final riletto = Tratto.fromJson(condiviso.toJson());
    expect(riletto.toJson(), condiviso.toJson());
    expect(riletto.ambiti, [AmbitoTratto.arma, AmbitoTratto.armatura]);
  });

  test('le liste filtrate contengono solo i tratti dell ambito giusto', () {
    expect(trattiArma.every((t) => t.valePerArmi), isTrue);
    expect(trattiArmatura.every((t) => t.valePerArmature), isTrue);
  });

  test('un tratto condiviso compare in entrambe le liste, una volta sola', () {
    final condivisi = listaTratti
        .where((t) => t.valePerArmi && t.valePerArmature)
        .toList();
    expect(condivisi, isNotEmpty);

    for (final t in condivisi) {
      expect(trattiArma.contains(t), isTrue);
      expect(trattiArmatura.contains(t), isTrue);
      // Stesso oggetto in entrambe le liste: un solo testo da mantenere.
      expect(
        identical(trattiArma.firstWhere((a) => a.nome == t.nome), t),
        isTrue,
      );
    }
  });
}
