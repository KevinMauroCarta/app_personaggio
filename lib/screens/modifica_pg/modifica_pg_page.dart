import '../../models/personaggio.dart';
import '../creazione_pg/creazione_pg_page.dart';

/// APP/Pagina/Modifica-PG
///
/// Permette di modificare tutti i valori inseriti in fase di creazione
/// (Modello/Personaggio): riusa [CharacterCreationPage] passandole
/// [personaggio] come valore iniziale, così ogni campo parte precompilato
/// invece che con i valori standard di creazione. Restituisce (tramite
/// Navigator.pop, come la creazione) il [Personaggio] aggiornato, o
/// niente se l'utente torna indietro senza salvare.
class ModificaPgPage extends CharacterCreationPage {
  const ModificaPgPage({super.key, required Personaggio personaggio})
    : super(personaggioIniziale: personaggio);
}
