import '../enums/rarita.dart';
import 'lista_capacita.dart';
import '../models/chip_neurale.dart';
import '../models/modificatore.dart';

/// Lista/ChipNeurali
///
/// ATTENZIONE - dati segnaposto: non esiste ancora un
/// "Regolamento/ChipNeurali". Questi chip servono solo a provare la
/// pagina degli Impianti in Scheda: nomi, effetti, Modificatori, Valore e
/// Rarità sono inventati, sulla scala dei prezzi di Lista/Armi.
///
/// Chi concede una Capacità da Impianto la prende da Lista/Capacità per
/// nome: per questo l'elenco è `final` e non `const`.
///
/// Da sostituire integralmente quando il regolamento sarà disponibile.
final List<ChipNeurale> listaChipNeurali = [
  ChipNeurale(
    nome: 'Chip Riflessi Sinaptici',
    descrizione:
        'Accorcia il tragitto fra occhio e muscolo: il corpo reagisce '
        'prima che la mente se ne accorga.',
    effetto: 'Iniziativa +1.',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Iniziativa',
      valore: 1,
    ),
    valore: 40,
    rarita: Rarita.nonComune,
  ),
  ChipNeurale(
    nome: 'Chip Balistico',
    descrizione:
        'Calcola traiettoria, vento e rinculo e li proietta sulla vista '
        'come una linea sottile.',
    effetto: 'Mira +1.',
    modificatoreAbilita: const Modificatore(nome: 'Mira', valore: 1),
    valore: 35,
    rarita: Rarita.nonComune,
  ),
  ChipNeurale(
    nome: 'Chip Mnemonico',
    descrizione:
        'Archivia tutto quello che il personaggio legge o ascolta, e lo '
        'richiama a comando.',
    effetto: 'Istruzione +1.',
    modificatoreAbilita: const Modificatore(nome: 'Istruzione', valore: 1),
    valore: 30,
    rarita: Rarita.comune,
  ),
  ChipNeurale(
    nome: 'Chip Traduttore Universale',
    descrizione:
        'Un archivio di lingue e dialetti che traduce in tempo reale '
        'quello che si sente.',
    effetto:
        'Il personaggio capisce e parla qualunque lingua umana diffusa. '
        'Le lingue rare o antiche richiedono comunque un test di '
        'Istruzione. Concede la Capacità Poliglotta.',
    capacita: capacitaDaNome('Poliglotta'),
    valore: 50,
    rarita: Rarita.rara,
  ),
];
