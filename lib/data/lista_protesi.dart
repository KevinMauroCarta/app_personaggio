import '../enums/parte_corpo.dart';
import '../enums/rarita.dart';
import 'lista_capacita.dart';
import '../enums/tipo_protesi.dart';
import '../models/modificatore.dart';
import '../models/protesi.dart';

/// Lista/Protesi
///
/// ATTENZIONE - dati segnaposto: non esiste ancora un
/// "Regolamento/Protesi". Queste protesi servono solo a provare la pagina
/// degli Impianti in Scheda: nomi, effetti, Modificatori, Valore e Rarità
/// sono inventati, sulla scala dei prezzi di Lista/Armi.
///
/// I Sostitutivi rimpiazzano una parte mancante e di solito non danno
/// bonus (al più una Capacità da Impianto): il loro effetto è riportare
/// il personaggio a funzionare. Gli Esoscheletri potenziano una parte
/// sana, e portano un Modificatore.
///
/// Chi concede una Capacità da Impianto la prende da Lista/Capacità per
/// nome: per questo l'elenco è `final` e non `const`.
///
/// Da sostituire integralmente quando il regolamento sarà disponibile.
final List<Protesi> listaProtesi = [
  // Sostitutivi
  Protesi(
    nome: 'Braccio Meccanico',
    tipo: TipoProtesi.sostitutivo,
    parte: ParteCorpo.braccio,
    descrizione:
        'Un braccio di acciaio e cavi, grezzo ma affidabile, collegato '
        'ai nervi della spalla.',
    effetto:
        'Sostituisce un braccio perduto: il personaggio lo usa come '
        'quello che aveva.',
    valore: 30,
    rarita: Rarita.comune,
  ),
  Protesi(
    nome: 'Occhio Ottico',
    tipo: TipoProtesi.sostitutivo,
    parte: ParteCorpo.occhio,
    descrizione:
        'Una lente in un bulbo di metallo, che ronza piano quando mette '
        'a fuoco.',
    effetto:
        'Sostituisce un occhio perduto e annulla le penalità di vista '
        'dovute alla sua mancanza. Concede la Capacità Visione Notturna.',
    capacita: capacitaDaNome('Visione Notturna'),
    valore: 25,
    rarita: Rarita.comune,
  ),
  Protesi(
    nome: 'Cuore Sintetico',
    tipo: TipoProtesi.sostitutivo,
    parte: ParteCorpo.cuore,
    descrizione:
        'Una pompa silenziosa al posto del cuore, alimentata da una '
        'batteria sotto lo sterno.',
    effetto:
        'Tiene in vita un personaggio che ha perso il cuore. La batteria '
        'va ricaricata una volta al mese.',
    valore: 60,
    rarita: Rarita.rara,
  ),
  // Esoscheletri
  Protesi(
    nome: 'Esoscheletro da Carico',
    tipo: TipoProtesi.esoscheletro,
    parte: ParteCorpo.corpo,
    descrizione:
        'Un telaio di pistoni che segue il corpo dalla schiena alle '
        'caviglie e ne regge il peso.',
    effetto: 'Forza +1. Concede la Capacità Presa d\'Acciaio.',
    modificatoreCaratteristica: const Modificatore(nome: 'Forza', valore: 1),
    capacita: capacitaDaNome('Presa d\'Acciaio'),
    valore: 55,
    rarita: Rarita.nonComune,
  ),
  Protesi(
    nome: 'Tutore Servoassistito',
    tipo: TipoProtesi.esoscheletro,
    parte: ParteCorpo.gamba,
    descrizione:
        'Una struttura leggera fissata alla gamba, che spinge a ogni passo '
        'insieme al muscolo.',
    effetto: 'Atletica +1.',
    modificatoreAbilita: const Modificatore(nome: 'Atletica', valore: 1),
    valore: 35,
    rarita: Rarita.comune,
  ),
  Protesi(
    nome: 'Guanto Stabilizzatore',
    tipo: TipoProtesi.esoscheletro,
    parte: ParteCorpo.mano,
    descrizione:
        'Un guanto di placche e giroscopi che smorza il tremore della mano '
        'nei colpi precisi.',
    effetto: 'Mischia Leggera +1.',
    modificatoreAbilita: const Modificatore(nome: 'Mischia Leggera', valore: 1),
    valore: 30,
    rarita: Rarita.nonComune,
  ),
];
