import '../enums/ambito_tratto.dart';
import '../enums/bersaglio.dart';
import '../models/modificatore.dart';
import '../models/tratto.dart';

/// Lista/Tratti
///
/// Catalogo unico dei Tratti di Armi e Armature: dove un tratto si
/// applica lo dice [Tratto.ambiti], non la lista in cui si trova.
///
/// I tratti con un valore fra parentesi ("Scudo (X)") hanno qui il solo
/// [Tratto.segnaposto]: il valore lo decide ogni arma o armatura, che li
/// prende con [tratto] (es. `tratto('Scudo', '2')`).
///
/// Hanno [Tratto.modificatori] solo i tratti con un effetto senza
/// condizioni (Scudo, Massiccia, Potenziata). Quelli che valgono solo in
/// certi casi - Parata contro la mischia, Psichica per chi è Psionico -
/// restano nel testo dell'effetto.
const List<Tratto> listaTratti = [
  Tratto(
    nome: 'A Fiamma',
    descrizione:
        'Queste armi scagliano getti di liquido in fiamme, un vero torrente '
        'di fuoco che può essere diretto per incendiare numerosi nemici.',
    effetto:
        'Gli attacchi di un\'arma A Fiamma ignorano le coperture. Se '
        'l\'attacco colpisce, il liquido incandescente ricopre tutto ciò che '
        'si trova lungo una linea retta tra il Personaggio e il bersaglio. '
        'Durante un attacco con queste armi è possibile Scambiare per '
        'dirigere il getto in un arco di liquido fiammeggiante lungo un '
        'numero di metri pari alla Mira del Personaggio. Tutto ciò che si '
        'trova in quest\'arco viene colpito. Questo Scambio può essere '
        'effettuato più volte. Il danno viene sempre tirato una volta sola e '
        'applicato a tutti i bersagli colpiti. Le vittime possono ridurre i '
        'Danni usando le regole per Schivare un\'Area d\'Effetto (pag. 186). '
        'Un\'arma con il Tratto A Fiamma è considerata avere anche il Tratto '
        'Infligge (In Fiamme).',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Ad Arco',
    descrizione:
        'Le terribili scariche elettriche delle armi Ad Arco mandano in '
        'cortocircuito i sistemi dei veicoli.',
    effetto:
        'Un\'arma Ad Arco che colpisce un veicolo o robot ottiene un numero '
        'di DE pari al valore di questo Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Affidabile',
    descrizione: 'Un\'arma robusta e facile da mantenere.',
    effetto:
        'In ogni Scena, il Personaggio può ignorare la prima Complicazione '
        'legata all\'arma. Le Prove per ripararla o mantenerla efficiente '
        'ricevono +1 dado bonus.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Assalto',
    descrizione:
        'Quest\'arma è progettata per sparare mentre si corre verso il '
        'nemico.',
    effetto:
        'Le armi d\'Assalto possono essere usate durante uno Scatto '
        '(pag. 180), ma ciò impone una penalità di +2 CD all\'attacco.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Brutale',
    descrizione: 'Le armi Brutali infliggono ferite spaventose.',
    effetto:
        'Quando si tira un Dado di Danno Extra per un\'arma Brutale si '
        'applicano i seguenti risultati: 1 e 2 aggiungono 0 Danni; 3 e 4 '
        'aggiungono 1 Danno; 5 e 6 aggiungono 2 Danni.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Cadenza Rapida',
    descrizione:
        'Queste armi sono capaci di scaricare raffiche letali a distanza '
        'ravvicinata.',
    effetto:
        'Quando un\'arma a Cadenza Rapida colpisce a Gittata Corta ottiene '
        'un numero di DE pari al punteggio del Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Campo di Forza',
    descrizione:
        'Un campo di forza è una meraviglia archeotech, che avvolge chi lo '
        'usa in una barriera di energia.',
    effetto:
        'Le armature con questo tratto permettono di usare Grinta contro le '
        'Ferite Mortali.',
    ambiti: [AmbitoTratto.armatura],
  ),
  Tratto(
    nome: 'Cecchino',
    descrizione:
        'Quest\'arma è calibrata per un tiro preciso a lunga distanza.',
    effetto:
        'Quando si Mira con un\'arma da Cecchino, si ottiene +1 dado bonus '
        'alla Prova d\'Attacco e un numero di DE pari al punteggio del '
        'Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Da Lancio',
    descrizione: 'Quest\'arma è progettata per essere lanciata.',
    effetto:
        'Con quest\'arma è possibile effettuare l\'attacco usando la sua '
        'riserva di dadi contro un bersaglio fino a distanza Forza x 4. '
        'L\'arma viene levata dall\'inventario.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Dilaniante',
    descrizione: 'Queste potenti armi sfondano le armature.',
    effetto:
        'Quando si Scambia un\'Icona Gloriosa durante un attacco con '
        'quest\'arma, il VP dell\'arma aumenta del punteggio del Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Dispersione',
    descrizione:
        'Quest\'arma di grosso calibro causa terribili danni a gruppi di '
        'avversari.',
    effetto:
        'Quando viene usata a Gittata Corta, un\'arma a Dispersione può '
        'colpire un qualsiasi numero di avversari in un raggio di 3 m. Se '
        'impiegata contro un\'Unità ottiene +3 dadi bonus.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Esplosione',
    descrizione:
        'Un\'arma esplosiva può distruggere molti nemici con un solo colpo.',
    effetto:
        'Le armi ad area (come granate, missili e altri esplosivi) hanno il '
        'Tratto Esplosione (X). Possono colpire qualsiasi punto bersaglio '
        'entro la loro gittata (anche un Personaggio) con una Prova di Mira '
        '(A) CD 3. Si applicano i normali modificatori per la Gittata '
        '(pag. 184), eccetto per le armi da lancio (pag. 208), come le '
        'granate. In caso di fallimento, l\'attacco manca e Devia '
        '(pag. 186), altrimenti il centro dell\'esplosione si trova proprio '
        'sul bersaglio scelto. Per chi usa le misure precise, il grado '
        'dell\'esplosione è pari al suo raggio in metri. Se, invece, si '
        'attacca un\'Unità o si usa il teatro della mente, il numero di '
        'individui colpiti è pari a metà del grado dell\'esplosione. Non è '
        'possibile Scambiare per aumentare i danni di un\'Esplosione. Chi '
        'ottiene un Colpo Critico usando un\'arma con Esplosione lo applica a '
        'tutti i bersagli coinvolti.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Infligge',
    descrizione:
        'Quest\'arma è progettata per danneggiare il bersaglio in modi '
        'insoliti e crudeli.',
    effetto:
        'Se causa almeno 1 Ferita, provoca anche la Condizione indicata. Se '
        'il Tratto include anche un numero, questo determina la CD di tutte '
        'le Prove per rimuovere la Condizione.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'Condizione',
  ),
  Tratto(
    nome: 'Ingombrante',
    descrizione: 'Le armature più grandi possono limitare i movimenti.',
    effetto: 'Non è possibile Correre o Scattare con un\'armatura Ingombrante.',
    ambiti: [AmbitoTratto.armatura],
  ),
  Tratto(
    nome: 'Invulnerabile',
    descrizione:
        'Le armature invulnerabili sono progettate per non essere perforate.',
    effetto:
        'Chi indossa un\'Armatura Invulnerabile ignora gli effetti della VP.',
    ambiti: [AmbitoTratto.armatura],
  ),
  Tratto(
    nome: 'Massiccia',
    descrizione:
        'Questo tratto è tipico delle armature più pesanti o che limitano i '
        'movimenti.',
    effetto:
        'La Velocità di chi le indossa è ridotta di un numero di metri pari '
        'al valore indicato.',
    ambiti: [AmbitoTratto.armatura],
    segnaposto: 'X',
    modificatori: [Modificatore(bersaglio: Bersaglio.velocita, valore: -1)],
  ),
  Tratto(
    nome: 'Parata',
    descrizione: 'Quest\'arma può essere usata per deflettere i colpi nemici.',
    effetto:
        'Chi impugna un\'arma con il Tratto Parata aggiunge +1 Difesa contro '
        'gli attacchi in mischia.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Pesante',
    descrizione:
        'Queste armi sono grosse e ingombranti, difficili da usare con '
        'precisione.',
    effetto:
        'Per utilizzare normalmente un\'arma Pesante bisogna avere Forza pari '
        'al valore di questo Tratto; chi non ha Forza sufficiente viene '
        'gettato Prono se subisce una Complicazione nell\'usarla, oltre agli '
        'altri effetti. In ogni caso, tutti gli attacchi subiscono una '
        'penalità di +2 CD. Usare l\'Azione Piazzare (pag. 189) o montare '
        'l\'arma su un treppiede o altro supporto nega questo Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Pistola',
    descrizione:
        'Un\'arma costruita per essere estratta rapidamente e usata anche in '
        'corpo a corpo.',
    effetto:
        'Un\'arma costruita per essere estratta rapidamente e usata anche in '
        'corpo a corpo.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Potenziata',
    descrizione:
        'Questa armatura è progettata per aumentare la forza di chi la usa, '
        'grazie a meccanismi meravigliosi.',
    effetto:
        'Mentre indossa questa corazza, il Personaggio somma il valore del '
        'Tratto alla propria Forza; inoltre, non può cadere Prono quando usa '
        'un\'arma Pesante senza Piazzarla.',
    ambiti: [AmbitoTratto.armatura],
    segnaposto: 'X',
    modificatori: [Modificatore(bersaglio: Bersaglio.forza, valore: 1)],
  ),
  Tratto(
    nome: 'Psichica',
    descrizione:
        'Gli Psionici possono incanalare i poteri del Warp nei circuiti '
        'eterici e nei materiali psicoreattivi di queste armi.',
    effetto:
        'Chi ha la Keyword PSIONICO può aggiungere metà della sua Volontà al '
        'Danno di queste armi; chi è privo di questa Keyword, invece, ne '
        'riduce il Danno di 2.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Radioattiva',
    descrizione:
        'Il materiale radioattivo sparato da quest\'arma danneggia '
        'inevitabilmente la carne.',
    effetto:
        'Quando si tirano i Dadi di Danno Extra per un\'arma Radioattiva, si '
        'somma il punteggio del Tratto al risultato di ogni singolo dado.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Scomoda',
    descrizione:
        'Alcune armi sono sbilanciate, troppo grosse o difficili da usare.',
    effetto:
        'La CD degli attacchi effettuati con un\'arma Scomoda aumenta del '
        'punteggio del Tratto.',
    ambiti: [AmbitoTratto.arma],
    segnaposto: 'X',
  ),
  Tratto(
    nome: 'Scudo',
    descrizione:
        'Gli scudi vengono impugnati, non indossati, e si usano per '
        'deflettere gli attacchi.',
    effetto: 'Un\'armatura con questo Tratto aggiunge X alla Difesa.',
    ambiti: [AmbitoTratto.armatura],
    segnaposto: 'X',
    modificatori: [Modificatore(bersaglio: Bersaglio.difesa, valore: 1)],
  ),
  Tratto(
    nome: 'Silenziosa',
    descrizione: 'Queste armi sono progettate per uccidere senza far rumore.',
    effetto:
        'Attaccare con un\'arma Silenziosa riduce la Riserva Furtiva solo '
        'di 2.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Sovralimentata',
    descrizione:
        'Il plasma surriscaldato sparato da quest\'arma può essere '
        'Sovralimentato per ottenere risultati assolutamente devastanti... '
        'spesso anche per chi la impugna.',
    effetto:
        'Un\'arma con questo Tratto può essere usata in modalità '
        'Sovralimentata: in questo caso, se colpisce ottiene +3 DE, ma con '
        'una Complicazione infligge 1d6 Ferite Mortali a chi la impugna.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Straziante',
    descrizione:
        'L\'arma è progettata per infliggere il massimo dolore, danneggiando '
        'la mente e il morale quanto il corpo.',
    effetto:
        'Ogni Ferita causata da un\'arma Straziante infligge anche 1 Shock.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Termica',
    descrizione:
        'Le scariche sub-atomiche di queste armi sciolgono carne e armature.',
    effetto:
        'Quando si tira un Dado di Danno Extra per un\'arma Termica usata a '
        'Gittata Corta si applicano i seguenti risultati: 1 e 2 aggiungono '
        '0 Danni; 3 e 4 aggiungono 1 Danno; 5 e 6 aggiungono 2 Danni. Se il '
        'bersaglio entro Gittata Corta è una struttura o un veicolo si '
        'applicano, invece, questi risultati: 1, 2 e 3 aggiungono 1 Danno; '
        '4, 5 e 6 aggiungono 2 Danni.',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'Warp',
    descrizione:
        'Ben pochi possono affrontare queste armi alimentate da potenti '
        'energie psioniche, dalla xenotech o dal potere puro del Caos.',
    effetto:
        'Il Danno di un\'arma Warp è pari alla Resilienza totale del '
        'bersaglio -4, a meno che il valore indicato nel profilo non sia più '
        'alto.',
    ambiti: [AmbitoTratto.arma],
  ),
];

/// Il tratto [nome] del catalogo, pronto da mettere su un'arma o
/// un'armatura. Se il tratto prende un valore fra parentesi, [valore] è
/// obbligatorio (`tratto('Scudo', '2')`); se non lo prende, è vietato.
Tratto tratto(String nome, [String? valore]) {
  final base = listaTratti.firstWhere(
    (t) => t.nome == nome,
    orElse: () => throw ArgumentError('Tratto "$nome" non in catalogo'),
  );
  if ((base.segnaposto == null) != (valore == null)) {
    throw ArgumentError(
      base.segnaposto == null
          ? 'Il Tratto "$nome" non prende un valore'
          : 'Il Tratto "$nome" vuole un valore (${base.segnaposto})',
    );
  }
  return valore == null ? base : base.conValore(valore);
}

/// I soli tratti assegnabili a un'Arma. È questo filtro - e non un
/// controllo del compilatore, che con un modello unico non c'è - a
/// impedire di mettere su un'arma un tratto da armatura: le tendine di
/// scelta vanno popolate da qui.
final List<Tratto> trattiArma = listaTratti
    .where((t) => t.valePerArmi)
    .toList();

/// I soli tratti assegnabili a un'Armatura. Vedi [trattiArma].
final List<Tratto> trattiArmatura = listaTratti
    .where((t) => t.valePerArmature)
    .toList();
