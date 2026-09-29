import '../enums/rarita.dart';
import '../models/oggetto.dart';

/// Lista/Oggetti
///
/// L'equipaggiamento che non è né un'arma né un'armatura: quello che un
/// personaggio si porta dietro e che non ha valori di combattimento.
///
/// ATTENZIONE - dati non ufficiali: non esiste ancora un documento
/// "Regolamento/Oggetti". Questi sono oggetti plausibili per il tipo di
/// gioco, messi perché la scelta degli Oggetti in Scheda avesse qualcosa
/// da offrire oltre ad armi e armature. Valore e Rarità sono tarati su
/// quelli di Lista/Armi, così i prezzi stanno sulla stessa scala. Da
/// sostituire quando ci sarà l'elenco vero.
final List<Oggetto> listaOggetti = [
  Oggetto(
    nome: 'Razioni',
    descrizione: 'Cibo conservato per qualche giorno di viaggio.',
    valore: 2,
    rarita: Rarita.comune,
  ),
  Oggetto(
    nome: 'Corda',
    descrizione:
        'Una matassa robusta, abbastanza lunga da calarsi di un piano.',
    valore: 3,
    rarita: Rarita.comune,
  ),
  Oggetto(
    nome: 'Kit Medico',
    descrizione: 'Bende, disinfettante e strumenti per una prima cura.',
    valore: 15,
    rarita: Rarita.comune,
  ),
  Oggetto(
    nome: 'Torcia',
    descrizione: 'Luce direzionale, utile dove l\'illuminazione manca.',
    valore: 4,
    rarita: Rarita.comune,
  ),
  Oggetto(
    nome: 'Auspex',
    descrizione:
        'Scanner portatile: rileva movimento e fonti di calore vicine.',
    valore: 40,
    rarita: Rarita.rara,
  ),
  Oggetto(
    nome: 'Rampino',
    descrizione: 'Gancio e cavo per salire dove non ci sono appigli.',
    valore: 12,
    rarita: Rarita.nonComune,
  ),
  Oggetto(
    nome: 'Maschera Respiratoria',
    descrizione: 'Filtra polveri e gas per qualche ora.',
    valore: 10,
    rarita: Rarita.comune,
  ),
  Oggetto(
    nome: 'Attrezzi da Lavoro',
    descrizione: 'Il minimo per aprire, riparare o forzare qualcosa.',
    valore: 8,
    rarita: Rarita.comune,
  ),
];

/// L'Oggetto di nome [nome], o null se non è un oggetto generico (può
/// essere un'arma o un'armatura, che hanno i loro cataloghi).
Oggetto? oggettoDaNome(String nome) {
  for (final oggetto in listaOggetti) {
    if (oggetto.nome == nome) return oggetto;
  }
  return null;
}
