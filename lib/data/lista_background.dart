import '../models/background.dart';
import '../models/capacita.dart';
import 'lista_capacita.dart';

Capacita _cap(String nome) => listaCapacita.firstWhere((c) => c.nome == nome);

/// Lista/Background + Regolamento/Background
///
/// Ogni background ha una e una sola Capacità di Background
/// (Modello/Background.capacitaDiBackground), scelta fra quelle di Tipo =
/// Background di Lista/Capacità: il legame è uno a uno, nessuna capacità
/// è condivisa fra due background e nessuna resta senza.
///
/// Nota: Modificatore Caratteristica/Abilità non sono presenti nel
/// documento originale e restano a null, essendo campi opzionali. Il Tag,
/// obbligatorio in Modello/Background, porta un segnaposto
/// `template-tag-background-{n}` in attesa dei dati veri.
final List<Background> listaBackground = [
  Background(
    nome: 'Nato tra le Stelle',
    descrizione:
        'Cresciuto su navi generazionali, abituato a microgravità, corridoi '
        'metallici e discipline di bordo.',
    capacitaDiBackground: _cap('Nato in Microgravità'),
    tag: 'Spaziale',
  ),
  Background(
    nome: 'Colono di Frontiera',
    descrizione:
        'Proveniente da mondi giovani e ostili, dove ogni giorno è una '
        'lotta contro ambiente e scarsità.',
    capacitaDiBackground: _cap('Tempra di Frontiera'),
    tag: 'Coloniale',
  ),
  Background(
    nome: 'Discendente del Nucleo',
    descrizione:
        'Nato in sistemi centrali ricchi, con educazione avanzata e '
        'accesso a tecnologie rare.',
    capacitaDiBackground: _cap('Empatia Sociale'),
    tag: 'Centrale',
  ),
  Background(
    nome: 'Addestrato nelle Accademie Orbitali',
    descrizione:
        'Formazione militare o scientifica in stazioni accademiche, con '
        'protocolli rigidi e simulazioni estreme.',
    capacitaDiBackground: _cap('Addestramento Militare'),
    tag: 'Addestrato',
  ),
  Background(
    nome: 'Figlio delle Lune Minerarie',
    descrizione:
        'Cresciuto tra cantieri, trivelle e tute pressurizzate; corpo '
        'temprato e mente pragmatica.',
    capacitaDiBackground: _cap('Conoscenza Tecnologica'),
    tag: 'Minerario',
  ),
  Background(
    nome: 'Custode dell\'Arca Dati',
    descrizione:
        'Membro di un ordine dedicato alla conservazione di conoscenze '
        'antiche e protocolli di civiltà scomparse.',
    capacitaDiBackground: _cap('Conoscenza Storica'),
    tag: 'Archivista',
  ),
  Background(
    nome: 'Sopravvissuto alla Fascia di Guerra',
    descrizione:
        'Proveniente da sistemi devastati da conflitti interstellari, con '
        'traumi, disciplina e una feroce resilienza.',
    capacitaDiBackground: _cap('Addestramento Medico'),
    tag: 'Veterano',
  ),
];
