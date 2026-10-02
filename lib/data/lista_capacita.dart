import '../enums/tipo_capacita.dart';
import '../models/capacita.dart';
import '../enums/bersaglio.dart';
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
/// Solo le Capacità Generiche si pagano: quelle di Razza, di Sistema, del
/// Pianeta e di Background costano SEMPRE 0, perché arrivano da scelte già
/// fatte (la razza, il sistema e il pianeta di origine, il background) e
/// non da una spesa. Qui hanno tutte costo 0, e un test lo verifica. Per
/// lo stesso motivo una Generica offerta da un sistema (Addestramento
/// Psichico) non si paga quando è presa come Capacità di Sistema: si paga
/// solo comprandola come Generica.
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
    modificatori: const [Modificatore(bersaglio: Bersaglio.forza, valore: 1)],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.percezione, valore: 1),
    ],
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
    modificatori: const [Modificatore(bersaglio: Bersaglio.volonta, valore: 1)],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.mira, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.tecnologia, valore: 1),
    ],
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
    modificatori: const [Modificatore(bersaglio: Bersaglio.agilita, valore: 1)],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
      Modificatore(bersaglio: Bersaglio.comando, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.mira, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
    ],
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
    modificatori: const [Modificatore(bersaglio: Bersaglio.volonta, valore: 1)],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
      Modificatore(bersaglio: Bersaglio.persuasione, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.controlloPsionico, valore: 1),
    ],
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
    modificatori: const [Modificatore(bersaglio: Bersaglio.agilita, valore: 1)],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.tecnologia, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.forza, valore: 1),
      Modificatore(bersaglio: Bersaglio.mischiaPesante, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.mischiaLeggera, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.medicae, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.iniziativa, valore: 1),
      Modificatore(bersaglio: Bersaglio.mischiaLeggera, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.atletica, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.tempra, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.atletica, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.tempra, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.furtivita, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.tempra, valore: 1),
    ],
    costo: 0,
    tag: const ['Freddo'],
  ),

  // ---- Capacità del Pianeta --------------------------------------------
  // Ogni pianeta ne offre tre (Lista/Pianeti): quella della sua tipologia,
  // uguale per tutti i pianeti di quel tipo, e due che si apprendono su
  // di lui, scelte qui fra quelle che seguono e che più pianeti possono
  // avere in comune.
  //
  // ATTENZIONE - inventate: nome, descrizione ed effetto sono una proposta
  // costruita sulla tipologia e sui tag dei pianeti, da rivedere quando ci
  // saranno i dati veri.

  // Una per tipologia (Roccioso, Gassoso, Acquatico).
  Capacita(
    nome: 'Ossa di Pietra',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'La gravità piena di un mondo di roccia ti ha dato ossa dense e '
        'muscoli abituati al peso: reggi fatiche e urti che piegherebbero '
        'chiunque altro.',
    effetto: 'Forza +1, Tempra +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.forza, valore: 1),
      Modificatore(bersaglio: Bersaglio.tempra, valore: 1),
    ],
    costo: 0,
    tag: const ['Solido'],
  ),
  Capacita(
    nome: 'Senso delle Correnti',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto fra le nubi di un gigante gassoso, su piattaforme '
        'sospese e navette sempre in volo: senti il vento cambiare prima '
        'che cambi, e ci guidi dentro.',
    effetto: 'Agilità +1, Pilotaggio +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.pilotaggio, valore: 1),
    ],
    costo: 0,
    tag: const ['Mobile'],
  ),
  Capacita(
    nome: 'Figlio delle Maree',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Su un mondo d\'acqua hai imparato a nuotare prima che a '
        'camminare: correnti, onde e freddo degli abissi non ti fanno più '
        'paura.',
    effetto: 'Resistenza +1, Atletica +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.atletica, valore: 1),
    ],
    costo: 0,
    tag: const ['Fluido'],
  ),

  // Apprese su un pianeta.
  Capacita(
    nome: 'Abituato al Gelo',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto dove il freddo non dà tregua: sai coprirti, '
        'razionare il calore e restare lucido anche quando le dita non '
        'rispondono più.',
    effetto: 'Resistenza +1, Sopravvivenza +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.sopravvivenza, valore: 1),
    ],
    costo: 0,
    tag: const ['Freddo'],
  ),
  Capacita(
    nome: 'Cercatore di Vene',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Hai passato l\'infanzia fra trivelle e gallerie: sai dove la '
        'roccia cede, dove nasconde il metallo e come far ripartire una '
        'macchina inceppata.',
    effetto: 'Forza +1, Tecnologia +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.forza, valore: 1),
      Modificatore(bersaglio: Bersaglio.tecnologia, valore: 1),
    ],
    costo: 0,
    tag: const ['Minerario'],
  ),
  Capacita(
    nome: 'Polmoni Temprati',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'L\'aria del tuo mondo è densa, pesante e a tratti velenosa: i '
        'tuoi polmoni ne ricavano il necessario e il tuo corpo ha smesso '
        'di lamentarsi.',
    effetto: 'Resistenza +1, Tempra +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.resistenza, valore: 1),
      Modificatore(bersaglio: Bersaglio.tempra, valore: 1),
    ],
    costo: 0,
    tag: const ['Resistente'],
  ),
  Capacita(
    nome: 'Pelle Arsa',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sotto un sole che brucia hai imparato a muoverti nelle ore '
        'giuste, a trovare l\'acqua dove non sembra esserci e a non cedere '
        'alla sete.',
    effetto: 'Volontà +1, Sopravvivenza +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.sopravvivenza, valore: 1),
    ],
    costo: 0,
    tag: const ['Ardente'],
  ),
  Capacita(
    nome: 'Crocevia di Popoli',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto fra cento lingue e mille usanze: capisci al volo '
        'chi hai davanti e trovi sempre un modo per farti capire.',
    effetto: 'Socialità +1, Intuizione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
      Modificatore(bersaglio: Bersaglio.intuizione, valore: 1),
    ],
    costo: 0,
    tag: const ['Diversificato'],
  ),
  Capacita(
    nome: 'Spirito Pioniere',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Vieni da un mondo ancora da costruire: dove manca qualcosa ti '
        'rimbocchi le maniche e lo fai, prima che qualcuno te lo chieda.',
    effetto: 'Iniziativa +1, Atletica +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.iniziativa, valore: 1),
      Modificatore(bersaglio: Bersaglio.atletica, valore: 1),
    ],
    costo: 0,
    tag: const ['Coloniale'],
  ),
  Capacita(
    nome: 'Occhio della Tempesta',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Hai visto tempeste grandi come continenti e hai imparato a '
        'passarci attraverso: quando tutto si agita, tu tieni la rotta.',
    effetto: 'Volontà +1, Pilotaggio +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.pilotaggio, valore: 1),
    ],
    costo: 0,
    tag: const ['Tempestoso'],
  ),
  Capacita(
    nome: 'Etichetta di Corte',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto fra ricevimenti, inchini e alleanze sussurrate: sai '
        'cosa dire, a chi dirlo e soprattutto cosa tacere.',
    effetto: 'Socialità +1, Astuzia +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
      Modificatore(bersaglio: Bersaglio.astuzia, valore: 1),
    ],
    costo: 0,
    tag: const ['Elegante'],
  ),
  Capacita(
    nome: 'Abitudine al Silenzio',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo mondo il rumore è un lusso o un pericolo: ti muovi piano, '
        'ascolti tutto e senti arrivare gli altri molto prima che loro '
        'sentano te.',
    effetto: 'Iniziativa +1, Furtività +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.iniziativa, valore: 1),
      Modificatore(bersaglio: Bersaglio.furtivita, valore: 1),
    ],
    costo: 0,
    tag: const ['Silenzioso'],
  ),
  Capacita(
    nome: 'Custode di Segreti',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Dove sei nato ogni parola ha un prezzo: sai tenere un segreto, '
        'riconoscere una menzogna e raccontarne una quando serve.',
    effetto: 'Intelletto +1, Inganno +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.inganno, valore: 1),
    ],
    costo: 0,
    tag: const ['Segreto'],
  ),
  Capacita(
    nome: 'Scuola Tattica',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo pianeta anche i giochi dei bambini sono manovre: leggi un '
        'campo di battaglia al primo sguardo e sai dove mettere ognuno.',
    effetto: 'Intelletto +1, Comando +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.comando, valore: 1),
    ],
    costo: 0,
    tag: const ['Tattico'],
  ),
  Capacita(
    nome: 'Vita di Regole',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto fra orari, gerarchie e regolamenti scritti: studi '
        'con metodo e non molli un lavoro finché non è fatto come si deve.',
    effetto: 'Volontà +1, Istruzione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.istruzione, valore: 1),
    ],
    costo: 0,
    tag: const ['Rigoroso'],
  ),
  Capacita(
    nome: 'Calma degli Abissi',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Le profondità del tuo mondo ti hanno insegnato a restare immobile '
        'e attento: nel buio e nel silenzio cogli quello che agli altri '
        'sfugge.',
    effetto: 'Volontà +1, Percezione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.percezione, valore: 1),
    ],
    costo: 0,
    tag: const ['Profondo'],
  ),
  Capacita(
    nome: 'Mente Analitica',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo mondo si ragiona prima di agire: scomponi ogni problema in '
        'pezzi, trovi quello che non torna e lo segui fino in fondo.',
    effetto: 'Intelletto +1, Investigazione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.investigazione, valore: 1),
    ],
    costo: 0,
    tag: const ['Analitico'],
  ),
  Capacita(
    nome: 'Mani da Tecnico',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto fra officine e laboratori: le tue dita trovano da '
        'sole il cavo giusto e rimettono in funzione ciò che altri '
        'butterebbero.',
    effetto: 'Agilità +1, Tecnologia +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.tecnologia, valore: 1),
    ],
    costo: 0,
    tag: const ['Tecnico'],
  ),
  Capacita(
    nome: 'Riflessi Taglienti',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Dove sei cresciuto vince chi colpisce per primo: reagisci prima di '
        'pensare, e la tua lama arriva sempre un attimo prima dell\'altra.',
    effetto: 'Iniziativa +1, Mischia Leggera +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.iniziativa, valore: 1),
      Modificatore(bersaglio: Bersaglio.mischiaLeggera, valore: 1),
    ],
    costo: 0,
    tag: const ['Rapido'],
  ),
  Capacita(
    nome: 'Come l\'Acqua',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Il tuo mondo cambia di continuo e tu con lui: ti adatti a persone, '
        'luoghi e situazioni nuove come se ci fossi sempre stato.',
    effetto: 'Agilità +1, Intuizione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.intuizione, valore: 1),
    ],
    costo: 0,
    tag: const ['Adattivo'],
  ),
  Capacita(
    nome: 'Orgoglio Indomito',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Il tuo popolo non si inchina a nessuno: il portamento che hai '
        'ereditato basta a far abbassare lo sguardo a chi ti sta di fronte.',
    effetto: 'Forza +1, Intimidazione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.forza, valore: 1),
      Modificatore(bersaglio: Bersaglio.intimidazione, valore: 1),
    ],
    costo: 0,
    tag: const ['Fiero'],
  ),
  Capacita(
    nome: 'Risonanza Mistica',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo mondo il confine fra percezione e presagio è sottile: '
        'senti le intenzioni degli altri e l\'eco dei luoghi prima ancora '
        'di vederli.',
    effetto: 'Volontà +1, Intuizione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.volonta, valore: 1),
      Modificatore(bersaglio: Bersaglio.intuizione, valore: 1),
    ],
    costo: 0,
    tag: const ['Mistico'],
  ),
  Capacita(
    nome: 'Equilibrio Perfetto',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo mondo tutto è misura e bilanciamento, anche il corpo: non '
        'perdi mai l\'equilibrio, né sui piedi né in una discussione.',
    effetto: 'Agilità +1, Atletica +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.atletica, valore: 1),
    ],
    costo: 0,
    tag: const ['Equilibrato'],
  ),
  Capacita(
    nome: 'Mediatore Nato',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sei cresciuto dove ogni lite si risolve parlando: trovi il punto '
        'd\'incontro fra due posizioni prima ancora che le parti lo '
        'cerchino.',
    effetto: 'Socialità +1, Persuasione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.socialita, valore: 1),
      Modificatore(bersaglio: Bersaglio.persuasione, valore: 1),
    ],
    costo: 0,
    tag: const ['Diplomatico'],
  ),
  Capacita(
    nome: 'Viandante',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'La tua gente non resta mai a lungo nello stesso posto: sai sempre '
        'dove dormire, cosa mangiare e quando è il momento di ripartire.',
    effetto: 'Iniziativa +1, Sopravvivenza +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.iniziativa, valore: 1),
      Modificatore(bersaglio: Bersaglio.sopravvivenza, valore: 1),
    ],
    costo: 0,
    tag: const ['Errante'],
  ),
  Capacita(
    nome: 'Memoria degli Antichi',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Il tuo mondo è più vecchio della sua storia scritta: sei cresciuto '
        'fra rovine, archivi e racconti che altrove nessuno ricorda più.',
    effetto: 'Intelletto +1, Istruzione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.intelletto, valore: 1),
      Modificatore(bersaglio: Bersaglio.istruzione, valore: 1),
    ],
    costo: 0,
    tag: const ['Antico'],
  ),
  Capacita(
    nome: 'Cacciatore nel Buio',
    tipo: TipoCapacita.pianeta,
    descrizione:
        'Sul tuo mondo la luce è poca e sopravvive chi sa cacciare: vedi '
        'nel buio quanto basta e sai aspettare il momento giusto per '
        'colpire.',
    effetto: 'Agilità +1, Percezione +1',
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.agilita, valore: 1),
      Modificatore(bersaglio: Bersaglio.percezione, valore: 1),
    ],
    costo: 0,
    tag: const ['Oscuro'],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.persuasione, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.percezione, valore: 1),
    ],
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
    modificatori: const [
      Modificatore(bersaglio: Bersaglio.mischiaPesante, valore: 1),
    ],
    costo: 0,
    tag: const ['Forte'],
  ),
];

/// La Capacità di nome [nome] (lancia se non esiste): per i cataloghi
/// che ne concedono una, come gli Impianti.
Capacita capacitaDaNome(String nome) =>
    listaCapacita.firstWhere((c) => c.nome == nome);
