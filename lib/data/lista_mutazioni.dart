import '../models/mutazione.dart';
import '../models/modificatore.dart';

/// Lista/Mutazioni + Regolamento/Mutazioni
const List<Mutazione> listaMutazioni = [
  Mutazione(
    nome: 'Occhio Demoniaco',
    descrizione:
        'Un occhio aggiuntivo, pulsante di energia innaturale, che vede '
        'oltre il reale.',
    effetto:
        '+1 ai test di percezione e capacità di individuare presenze '
        'occulte.',
    modificatoreCaratteristica: Modificatore(nome: 'Iniziativa', valore: 1),
  ),
  Mutazione(
    nome: 'Braccio Artigliato',
    descrizione:
        'L\'arto si deforma in una massa di tendini e artigli ossei '
        'affilati.',
    effetto:
        '+1 ai danni corpo a corpo e possibilità di ignorare armature '
        'leggere.',
    modificatoreCaratteristica: Modificatore(nome: 'Forza', valore: 1),
  ),
  Mutazione(
    nome: 'Pelle Chitinosa',
    descrizione:
        'La pelle si indurisce in placche simili a carapace, resistenti ai '
        'colpi.',
    effetto:
        '+1 alla resistenza fisica e riduzione del danno subito da armi '
        'leggere.',
    modificatoreCaratteristica: Modificatore(nome: 'Resistenza', valore: 1),
  ),
  Mutazione(
    nome: 'Sangue Corrosivo',
    descrizione:
        'Il sangue diventa acido, bruciando ciò che lo tocca quando viene '
        'versato.',
    effetto:
        'Chi infligge danno al mutato subisce 1 danno automatico da '
        'corrosione.',
  ),
  Mutazione(
    nome: 'Voce Innaturale',
    descrizione:
        'Le corde vocali si deformano, producendo un suono che vibra '
        'nella mente.',
    effetto:
        '+1 ai test sociali intimidatori e possibilità di spaventare '
        'creature deboli.',
    modificatoreCaratteristica: Modificatore(nome: 'Socialità', valore: 1),
  ),
];
