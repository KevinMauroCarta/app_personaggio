import '../enums/tipo_capacita.dart';
import '../models/capacita.dart';
import '../models/modificatore.dart';

/// Lista/Capacità + Regolamento/Capacità
///
/// Per ogni capacità, [Capacita.descrizione] racconta cosa permette di
/// fare e [Capacita.effetto] dice come si traduce in meccanica: l'effetto
/// riporta sempre e solo i Modificatori della capacità stessa, così il
/// testo non può discostarsi dal bonus che viene poi applicato davvero
/// (services/effetti_personaggio.dart).
///
/// [Capacita.costo] è il prezzo in PE della capacità: sceglierla in
/// Creazione/Modifica/Aumento scala quei PE, toglierla li restituisce.
/// Solo le Capacità Generiche si pagano: quelle di Razza, di Sistema e di
/// Background costano SEMPRE 0, perché arrivano da scelte già fatte
/// (la razza, il sistema di origine, il background) e non da una spesa.
/// Qui hanno tutte costo 0, e un test lo verifica.
///
/// Nota: il documento non specifica i Tag per queste Capacità, campo
/// obbligatorio in Modello/Capacità: portano un segnaposto
/// `template-tag-capacita-{n}` in attesa dei dati veri.
final List<Capacita> listaCapacita = [
  Capacita(
    nome: 'Impeto Fisico',
    tipo: TipoCapacita.generica,
    descrizione:
        'Il tuo corpo trova una riserva di potenza che non sapevi di '
        'avere: sollevi ciò che non dovresti e sfondi ciò che dovrebbe '
        'reggere.',
    effetto: 'Forza +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Forza', valore: 1),
    costo: 2,
    tag: const ['Brutale'],
  ),
  Capacita(
    nome: 'Vista Acuta',
    tipo: TipoCapacita.razza,
    descrizione:
        'Distingui un movimento sospetto in fondo a un corridoio buio e '
        'leggi da lontano ciò che per gli altri è solo una macchia.',
    effetto: 'Intelletto +1, Percezione +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Percezione', valore: 1),
    costo: 0,
    tag: const ['Vigile'],
  ),
  Capacita(
    nome: 'Disciplina Mentale',
    tipo: TipoCapacita.sistema,
    descrizione:
        'Tieni la mente sgombra anche quando tutto intorno crolla: paura '
        'e rabbia restano fuori dalla porta finché non decidi tu.',
    effetto: 'Volontà +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Volontà', valore: 1),
    costo: 0,
    tag: const ['Disciplinato'],
  ),
  Capacita(
    nome: 'Addestramento Militare',
    tipo: TipoCapacita.background,
    descrizione:
        'Ti muovi e spari come chi lo ha fatto per mestiere: coperture, '
        'ricariche e linee di tiro ti vengono automatiche.',
    effetto: 'Agilità +1, Mira +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Mira', valore: 1),
    costo: 0,
    tag: const ['Militare'],
  ),
  Capacita(
    nome: 'Resistenza Innata',
    tipo: TipoCapacita.razza,
    descrizione:
        'Il tuo organismo incassa ciò che metterebbe a terra chiunque '
        'altro: veleni, freddo, fatica e colpi ti segnano meno.',
    effetto: 'Resistenza +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Resistenza',
      valore: 1,
    ),
    costo: 0,
    tag: const ['Resistente'],
  ),
  Capacita(
    nome: 'Conoscenza Tecnologica',
    tipo: TipoCapacita.background,
    descrizione:
        'Davanti a una macchina sconosciuta capisci da dove si apre, cosa '
        'la alimenta e cosa succede se tocchi il cavo sbagliato.',
    effetto: 'Intelletto +1, Tecnologia +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Tecnologia', valore: 1),
    costo: 0,
    tag: const ['Tecnico'],
  ),
  Capacita(
    nome: 'Istinto di Sopravvivenza',
    tipo: TipoCapacita.generica,
    descrizione:
        'Il tuo corpo si sposta prima che la mente abbia registrato il '
        'pericolo: ti ritrovi al riparo senza ricordare di esserti mosso.',
    effetto: 'Agilità +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    costo: 2,
    tag: const ['Istintivo'],
  ),
  Capacita(
    nome: 'Autorità Naturale',
    tipo: TipoCapacita.generica,
    descrizione:
        'Quando parli la stanza si zittisce, e i tuoi ordini vengono '
        'eseguiti prima che a qualcuno venga in mente di discuterli.',
    effetto: 'Socialità +1, Comando +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Socialità',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Comando', valore: 1),
    costo: 3,
    tag: const ['Dominante'],
  ),
  Capacita(
    nome: 'Precisione Letale',
    tipo: TipoCapacita.sistema,
    descrizione:
        'Non spari al bersaglio: spari al punto esatto del bersaglio che '
        'lo farà smettere di essere un problema.',
    effetto: 'Agilità +1, Mira +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Mira', valore: 1),
    costo: 0,
    tag: const ['Preciso'],
  ),
  Capacita(
    nome: 'Memoria Fotografica',
    tipo: TipoCapacita.generica,
    descrizione:
        'Ti basta un\'occhiata a una mappa, a un volto o a una sequenza '
        'di numeri per riaverli davanti agli occhi giorni dopo.',
    effetto: 'Intelletto +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    costo: 3,
    // Seconda via al tag Psionico, oltre ad "Addestramento Psichico":
    // essendo una Capacità Generica è alla portata di chiunque, senza
    // dipendere dal sistema di origine scelto.
    tag: const ['Psionico'],
  ),
  Capacita(
    nome: 'Tenacia Ferrea',
    tipo: TipoCapacita.sistema,
    descrizione:
        'Continui ad andare avanti quando chiunque altro si sarebbe già '
        'seduto ad aspettare la fine.',
    effetto: 'Volontà +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Volontà', valore: 1),
    costo: 0,
    tag: const ['Tenace'],
  ),
  Capacita(
    nome: 'Empatia Sociale',
    tipo: TipoCapacita.background,
    descrizione:
        'Capisci cosa vuole davvero chi ti sta di fronte, e glielo offri '
        'con le parole che si aspetta di sentire.',
    effetto: 'Socialità +1, Persuasione +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Socialità',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Persuasione', valore: 1),
    costo: 0,
    tag: const ['Diplomatico'],
  ),
  Capacita(
    nome: 'Addestramento Psichico',
    tipo: TipoCapacita.generica,
    descrizione:
        'Hai imparato a incanalare l\'energia mentale invece di subirla: '
        'la dirigi dove serve senza che ti si ritorca contro.',
    effetto: 'Volontà +1, Controllo Psionico +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Volontà', valore: 1),
    modificatoreAbilita: const Modificatore(
      nome: 'Controllo Psionico',
      valore: 1,
    ),
    costo: 8,
    // È questo tag a sbloccare la scelta dei Poteri Psionici in
    // creazione (services/effetti_personaggio.dart, tagPsionico).
    tag: const ['Psionico'],
  ),
  Capacita(
    nome: 'Mobilità Avanzata',
    tipo: TipoCapacita.generica,
    descrizione:
        'Attraversi terreni impraticabili come se fossero una strada: '
        'salti, ti arrampichi e atterri senza perdere il ritmo.',
    effetto: 'Agilità +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    costo: 2,
    tag: const ['Mobile'],
  ),
  Capacita(
    nome: 'Conoscenza Storica',
    tipo: TipoCapacita.background,
    descrizione:
        'Riconosci simboli, rovine e macchinari di civiltà scomparse, e '
        'sai a cosa serviva davvero l\'oggetto che hai in mano.',
    effetto: 'Intelletto +1, Tecnologia +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Tecnologia', valore: 1),
    costo: 0,
    tag: const ['Erudito'],
  ),
  Capacita(
    nome: 'Ferocia Primordiale',
    tipo: TipoCapacita.razza,
    descrizione:
        'Quando parte la carica smetti di calcolare: addosso, con tutto '
        'il peso, finché una delle due parti non resta a terra.',
    effetto: 'Forza +1, Mischia Pesante +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Forza', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Mischia Pesante', valore: 1),
    costo: 0,
    tag: const ['Feroce'],
  ),
  Capacita(
    nome: 'Calcolo Strategico',
    tipo: TipoCapacita.sistema,
    descrizione:
        'Vedi lo scontro dall\'alto mentre ci sei dentro: sai chi colpire '
        'per primo e da che parte arriverà il prossimo.',
    effetto: 'Intelletto +1, Mischia Leggera +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Mischia Leggera', valore: 1),
    costo: 0,
    tag: const ['Strategico'],
  ),
  Capacita(
    nome: 'Addestramento Medico',
    tipo: TipoCapacita.background,
    descrizione:
        'Sai fermare un\'emorragia con quello che hai in tasca, e capire '
        'guardando un ferito quanto tempo gli resta.',
    effetto: 'Intelletto +1, Medicae +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Medicae', valore: 1),
    costo: 0,
    tag: const ['Medico'],
  ),
  Capacita(
    nome: 'Percezione del Pericolo',
    tipo: TipoCapacita.generica,
    descrizione:
        'Senti l\'imboscata un attimo prima che scatti, e quell\'attimo '
        'è tuo: sei già in movimento quando gli altri capiscono.',
    effetto: 'Iniziativa +1, Mischia Leggera +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Iniziativa',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Mischia Leggera', valore: 1),
    costo: 2,
    tag: const ['Vigile'],
  ),
  Capacita(
    nome: 'Nato in Microgravità',
    tipo: TipoCapacita.background,
    descrizione:
        'Senza un basso e un alto ti orienti meglio di chiunque altro: ti '
        'spingi da una parete all\'altra e arrivi dove volevi.',
    effetto: 'Agilità +1, Atletica +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Atletica', valore: 1),
    costo: 0,
    tag: const ['Spaziale'],
  ),
  Capacita(
    nome: 'Tempra di Frontiera',
    tipo: TipoCapacita.background,
    descrizione:
        'Hai vissuto dove niente è garantito: razioni corte, aria cattiva '
        'e notti al freddo non ti tolgono più lucidità.',
    effetto: 'Resistenza +1, Tempra +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Resistenza',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Tempra', valore: 1),
    costo: 0,
    tag: const ['Duro'],
  ),
  // ---- Capacità di Razza dedicate -------------------------------------
  // ATTENZIONE - inventate: Regolamento/Razze non esiste ancora, quindi
  // di Solari, Mondriani, Tetramari e Aeleidari si conosce solo il nome.
  // Nome, descrizione ed effetto qui sotto sono una proposta costruita
  // sul nome della razza, da rivedere quando ci saranno i dati veri.
  Capacita(
    nome: 'Riverbero Solare',
    tipo: TipoCapacita.razza,
    descrizione:
        'La tua pelle trattiene la luce e la restituisce: al buio sei un '
        'punto di riferimento, in pieno sole sei difficile da guardare.',
    effetto: 'Socialità +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Socialità',
      valore: 1,
    ),
    costo: 0,
    tag: const ['Luminoso'],
  ),
  Capacita(
    nome: 'Passo Saldo',
    tipo: TipoCapacita.razza,
    descrizione:
        'Hai un rapporto con il peso e l\'equilibrio che gli altri non '
        'hanno: nessuna spinta e nessun terremoto ti stacca da dove stai.',
    effetto: 'Resistenza +1, Atletica +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Resistenza',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Atletica', valore: 1),
    costo: 0,
    tag: const ['Solido'],
  ),
  Capacita(
    nome: 'Respiro Profondo',
    tipo: TipoCapacita.razza,
    descrizione:
        'Trattieni il fiato per tempi che agli altri sembrano impossibili '
        'e sopporti la pressione senza che il corpo protesti.',
    effetto: 'Resistenza +1, Tempra +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Resistenza',
      valore: 1,
    ),
    modificatoreAbilita: const Modificatore(nome: 'Tempra', valore: 1),
    costo: 0,
    tag: const ['Profondo'],
  ),
  Capacita(
    nome: 'Memoria Lunga',
    tipo: TipoCapacita.razza,
    descrizione:
        'Porti con te ricordi che superano la durata di una vita umana, e '
        'riconosci schemi che si ripetono da generazioni.',
    effetto: 'Intelletto +1',
    modificatoreCaratteristica: const Modificatore(
      nome: 'Intelletto',
      valore: 1,
    ),
    costo: 0,
    tag: const ['Antico'],
  ),
  Capacita(
    nome: 'Passo Silenzioso',
    tipo: TipoCapacita.razza,
    descrizione:
        'Ti muovi senza spostare l\'aria: chi ti sta accanto si accorge di '
        'te solo quando decidi di farti notare.',
    effetto: 'Agilità +1, Furtività +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Agilità', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Furtività', valore: 1),
    costo: 0,
    tag: const ['Silenzioso'],
  ),
  Capacita(
    nome: 'Sangue Freddo',
    tipo: TipoCapacita.sistema,
    descrizione:
        'Più la situazione degenera, più la tua voce resta ferma e le tue '
        'mani smettono di tremare.',
    effetto: 'Volontà +1, Tempra +1',
    modificatoreCaratteristica: const Modificatore(nome: 'Volontà', valore: 1),
    modificatoreAbilita: const Modificatore(nome: 'Tempra', valore: 1),
    costo: 0,
    tag: const ['Freddo'],
  ),

  // Capacità da Impianto: non si comprano, le concede un impianto
  // installato (Lista/ChipNeurali, Lista/Protesi). Segnaposto come gli
  // impianti che le danno.
  Capacita(
    nome: 'Poliglotta',
    tipo: TipoCapacita.impianto,
    descrizione:
        'Ogni voce arriva già tradotta, e le parole giuste nella lingua '
        'dell\'altro ti salgono alle labbra senza cercarle.',
    effetto: 'Persuasione +1',
    modificatoreAbilita: const Modificatore(nome: 'Persuasione', valore: 1),
    costo: 0,
    tag: const ['Diplomatico'],
  ),
  Capacita(
    nome: 'Visione Notturna',
    tipo: TipoCapacita.impianto,
    descrizione:
        'Il buio non è più buio: vedi forme e movimenti dove gli altri '
        'vedono solo ombra.',
    effetto: 'Percezione +1',
    modificatoreAbilita: const Modificatore(nome: 'Percezione', valore: 1),
    costo: 0,
    tag: const ['Intuitivo'],
  ),
  Capacita(
    nome: 'Presa d\'Acciaio',
    tipo: TipoCapacita.impianto,
    descrizione:
        'Quello che afferri non ti scappa: la stretta dei pistoni non si '
        'allenta finché non lo decidi tu.',
    effetto: 'Mischia Pesante +1',
    modificatoreAbilita: const Modificatore(nome: 'Mischia Pesante', valore: 1),
    costo: 0,
    tag: const ['Forte'],
  ),
];

/// La Capacità di nome [nome] (lancia se non esiste): per i cataloghi
/// che ne concedono una, come gli Impianti.
Capacita capacitaDaNome(String nome) =>
    listaCapacita.firstWhere((c) => c.nome == nome);
