import '../../enums/abilita_arma.dart';
import '../../enums/rarita.dart';
import '../../enums/tipo_danno.dart';
import '../../models/armi/arma_mischia.dart';
import '../lista_tratti.dart';

/// Lista/Armi/Mischia
///
/// Le armi che colpiscono da vicino (Modello/Armi/ArmaMischia). La
/// [ArmaMischia.gittata] è la portata: 1 per le armi corte, 2 per quelle
/// che tengono l'avversario a distanza di braccio.
///
/// ATTENZIONE - dati non ufficiali: non esiste ancora un documento
/// "Regolamento/Armi". I nomi e il tipo di danno sono sensati, ma danno,
/// dadi extra, valore penetrazione, valore e rarità sono una proposta
/// costruita perché le armi si distinguano fra loro, non valori presi da
/// un regolamento.
final List<ArmaMischia> listaArmiMischia = [
  ArmaMischia(
    nome: 'Coltello',
    abilitaAssociata: AbilitaArma.mischiaLeggera,
    danno: 2,
    // Una lama: taglia, quindi danno fisico.
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 1,
    valorePenetrazione: 0,
    gittata: 1,
    tratti: [listaTratti[0]],
    tag: const ['Tagliente', 'Silenzioso'],
    valore: 5,
    rarita: Rarita.comune,
  ),
  ArmaMischia(
    nome: 'Spada a Catena',
    abilitaAssociata: AbilitaArma.mischiaLeggera,
    danno: 5,
    // I denti in movimento strappano: resta un impatto fisico.
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 2,
    valorePenetrazione: 1,
    gittata: 1,
    tag: const ['Tagliente', 'Brutale'],
    valore: 25,
    rarita: Rarita.nonComune,
  ),
  ArmaMischia(
    nome: 'Martello',
    abilitaAssociata: AbilitaArma.mischiaPesante,
    danno: 6,
    // Peso e impatto: fisico puro.
    tipoDanno: TipoDanno.fisico,
    dadiExtra: 1,
    valorePenetrazione: 2,
    gittata: 2,
    tratti: [listaTratti[2]],
    tag: const ['Duro', 'Massivo'],
    valore: 20,
    rarita: Rarita.comune,
  ),
  ArmaMischia(
    nome: 'Ascia Energetica',
    abilitaAssociata: AbilitaArma.mischiaPesante,
    danno: 7,
    // La lama è avvolta da un campo di energia: è quello a ferire, non
    // il metallo.
    tipoDanno: TipoDanno.energetico,
    dadiExtra: 2,
    valorePenetrazione: 3,
    gittata: 1,
    tag: const ['Ardente', 'Letale'],
    valore: 60,
    rarita: Rarita.rara,
  ),
];
