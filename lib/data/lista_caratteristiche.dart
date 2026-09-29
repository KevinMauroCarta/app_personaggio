import '../models/caratteristica.dart';

/// Lista/Caratteristiche + Regolamento/Caratteristiche
const List<Caratteristica> listaCaratteristiche = [
  Caratteristica(
    nome: 'Forza',
    descrizione:
        'La Forza indica la pura potenza fisica. Influisce sulle capacità '
        'atletiche del Personaggio, su quali armi può sollevare e usare e '
        'quanto Danno infligge in mischia.',
  ),
  Caratteristica(
    nome: 'Resistenza',
    descrizione:
        'La Resistenza è la capacità di sopportare tossine e malattie. '
        'Determina quanti Danni si possono ignorare o incassare prima di '
        'morire.',
  ),
  Caratteristica(
    nome: 'Agilità',
    descrizione:
        'L\'Agilità è destrezza e coordinazione. Influisce sulla precisione '
        'con le armi a distanza, sull\'uso di macchinari complessi e sul '
        'controllo motorio generale.',
  ),
  Caratteristica(
    nome: 'Iniziativa',
    descrizione:
        'L\'Iniziativa misura riflessi e tempi di reazione. Influisce sulla '
        'capacità di prendere decisioni lampo in situazioni di stress.',
  ),
  Caratteristica(
    nome: 'Volontà',
    descrizione:
        'La Volontà è autocontrollo e forza mentale. Determina quanto il '
        'Personaggio resiste alle tentazioni, domina o respinge i poteri '
        'del Warp e si mantiene freddo in battaglia.',
  ),
  Caratteristica(
    nome: 'Intelletto',
    descrizione:
        'L\'Intelletto è la capacità di memorizzare, elaborare e utilizzare '
        'le informazioni. Influisce sull\'osservazione, la risoluzione di '
        'problemi e la memoria.',
  ),
  Caratteristica(
    nome: 'Socialità',
    descrizione:
        'La Socialità indica la forza della personalità. Determina la '
        'capacità di persuadere, mescolarsi alla folla, affascinare, '
        'mentire e notare le bugie.',
  ),
];
