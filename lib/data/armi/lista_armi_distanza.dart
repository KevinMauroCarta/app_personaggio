import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../../models/armi/arma_distanza.dart';
import '../lista_tratti.dart';

/// Lista/Armi/Distanza
///
/// Le armi che colpiscono da lontano (Modello/Armi/ArmaDistanza), con le
/// tre gittate corta / media / lunga e, dove ha senso, la Raffica.
///
/// ATTENZIONE - dati non ufficiali: non esiste ancora un documento
/// "Regolamento/Armi". I nomi e il tipo di danno sono sensati, ma i
/// numeri sono una proposta costruita perché le armi si distinguano fra
/// loro, non valori presi da un regolamento.
final List<ArmaDistanza> listaArmiDistanza = [
  ArmaDistanza(
    nome: 'Pistola',
    abilitaAssociata: AbilitaArma.mira,
    danno: 3,
    // Spara proiettili.
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 3,
    valorePenetrazione: 1,
    gittataCorta: 3,
    gittataMedia: 6,
    gittataLunga: 9,
    raffica: true,
    tratti: [listaTratti[0], listaTratti[2]],
    tag: const ['Rapido', 'Militare'],
    valore: 20,
    rarita: Rarita.comune,
  ),
  ArmaDistanza(
    nome: 'Fucile d\'Assalto',
    abilitaAssociata: AbilitaArma.mira,
    danno: 5,
    // Anche qui proiettili, solo più grossi e più in fretta.
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 2,
    valorePenetrazione: 2,
    gittataCorta: 8,
    gittataMedia: 16,
    gittataLunga: 32,
    raffica: true,
    tag: const ['Militare', 'Brutale'],
    valore: 45,
    rarita: Rarita.nonComune,
  ),
  ArmaDistanza(
    nome: 'Fucile Laser',
    abilitaAssociata: AbilitaArma.mira,
    danno: 6,
    // Un raggio coerente: brucia invece di perforare.
    tipoDanno: TipoDanno.energetico,
    dadiExtra: 2,
    valorePenetrazione: 3,
    gittataCorta: 10,
    gittataMedia: 20,
    gittataLunga: 40,
    tag: const ['Ardente', 'Preciso'],
    valore: 70,
    rarita: Rarita.rara,
  ),
  ArmaDistanza(
    nome: 'Giavellotto',
    // Si lancia, ma è il braccio a tirarlo: l'abilità resta quella da
    // mischia leggera.
    abilitaAssociata: AbilitaArma.mischiaLeggera,
    danno: 4,
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 1,
    valorePenetrazione: 1,
    gittataCorta: 4,
    gittataMedia: 8,
    gittataLunga: 12,
    tratti: [listaTratti[2]],
    tag: const ['Preciso', 'Tagliente'],
    valore: 10,
    rarita: Rarita.comune,
  ),
];
