// Lista/Armi è divisa in due cataloghi, uno per tipo di arma, e
// catalogo_armi.dart li unisce. Qui si verifica che i due elenchi restino
// coerenti col tipo che dichiarano e che l'unione non perda niente.

import 'package:flutter_test/flutter_test.dart';

// catalogo_armi.dart riesporta i due cataloghi: basta un import solo.
import 'package:app_personaggio/data/armi/catalogo_armi.dart';
import 'package:app_personaggio/enums/abilita_arma.dart';
import 'package:app_personaggio/enums/tipo_danno.dart';
import 'package:app_personaggio/models/armi/arma_distanza.dart';
import 'package:app_personaggio/models/armi/arma_mischia.dart';

void main() {
  test('ogni catalogo ha almeno quattro armi', () {
    expect(listaArmiMischia.length, greaterThanOrEqualTo(4));
    expect(listaArmiDistanza.length, greaterThanOrEqualTo(4));
  });

  test('il catalogo completo è l unione dei due', () {
    expect(
      listaArmi.length,
      listaArmiMischia.length + listaArmiDistanza.length,
    );
    for (final arma in listaArmiMischia) {
      expect(listaArmi, contains(arma));
    }
    for (final arma in listaArmiDistanza) {
      expect(listaArmi, contains(arma));
    }
  });

  test('nessun nome di arma è ripetuto', () {
    // Due armi con lo stesso nome romperebbero le tendine di scelta
    // dell'Equipaggiamento, che lavorano per nome.
    final nomi = listaArmi.map((a) => a.nome).toList();
    expect(nomi.toSet().length, nomi.length);
  });

  test('le armi da mischia usano un abilità da mischia', () {
    for (final arma in listaArmiMischia) {
      expect(arma, isA<ArmaMischia>());
      expect(
        arma.abilitaAssociata,
        isNot(AbilitaArma.mira),
        reason: '"${arma.nome}" si usa da vicino',
      );
      expect(arma.gittata, greaterThan(0), reason: arma.nome);
    }
  });

  test('le armi a distanza hanno le tre gittate in ordine', () {
    for (final arma in listaArmiDistanza) {
      expect(arma, isA<ArmaDistanza>());
      expect(arma.gittataCorta, lessThan(arma.gittataMedia), reason: arma.nome);
      expect(arma.gittataMedia, lessThan(arma.gittataLunga), reason: arma.nome);
    }
  });

  test('ogni arma dichiara che tipo di danno fa', () {
    // Il campo è obbligatorio, quindi il controllo serve a dire che
    // esistono armi di entrambi i tipi: se fossero tutte fisiche, la
    // distinzione non sarebbe mai provata.
    final tipi = listaArmi.map((a) => a.tipoDanno).toSet();
    expect(tipi, contains(TipoDanno.fisico));
    expect(tipi, contains(TipoDanno.energetico));
  });

  test('la Raffica è solo delle armi a distanza', () {
    // Sulle armi da mischia il campo proprio non esiste: è il modello a
    // impedirlo, e questo test lo mette nero su bianco.
    expect(listaArmiDistanza.any((a) => a.raffica), isTrue);
  });
}
