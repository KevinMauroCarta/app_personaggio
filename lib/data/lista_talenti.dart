import '../models/talento.dart';

/// Lista/Talenti + Regolamento/Talenti
///
/// Come per le Capacità, [Talento.descrizione] racconta cosa il talento
/// permette di fare e [Talento.effetto] dice come si traduce in
/// meccanica.
///
/// ATTENZIONE: a differenza di Modello/Capacità, Modello/Talento non ha
/// campi Modificatore, quindi l'effetto qui sotto è solo testo: non viene
/// applicato automaticamente al Valore Bonus di nessuna
/// Caratteristica/Abilità. Il Tag, obbligatorio e non presente nel
/// documento originale, resta un segnaposto.
final List<Talento> listaTalenti = [
  Talento(
    nome: 'Vista Quantica',
    descrizione:
        'Vedi la traiettoria prima che il colpo parta: il mondo rallenta '
        'quanto basta per capire dove andrà a finire.',
    effetto: 'Iniziativa +2',
    tag: 'Sentinella',
  ),
  Talento(
    nome: 'Protocollo Zenith',
    descrizione:
        'Richiami un addestramento che il corpo esegue da solo, spingendo '
        'oltre il limite ciò che dovrebbe già essere finito.',
    effetto: 'Forza +1, Resistenza +1',
    tag: 'Addestrato',
  ),
  Talento(
    nome: 'Tattica Singolare',
    descrizione:
        'In mezzo alla confusione di uno scontro trovi l\'unica mossa che '
        'lo chiude, e la vedi prima di chiunque altro.',
    effetto: 'Intelletto +2',
    tag: 'Tattico',
  ),
  Talento(
    nome: 'Impulso Stellare',
    descrizione:
        'Scarichi in un istante tutta l\'energia che hai: un solo scatto, '
        'fisico o mentale, che nessuno si aspetta così rapido.',
    effetto: 'Agilità +2',
    tag: 'Impulso Stellare',
  ),
  Talento(
    nome: 'Memoria d\'Arca',
    descrizione:
        'Attingi a frammenti di archivi antichi: nomi, mappe e procedure '
        'di civiltà che non esistono più ti tornano in mente al momento '
        'giusto.',
    effetto: 'Intelletto +1, Volontà +1',
    // Terza via al tag Psionico, dopo "Addestramento Psichico" e
    // "Memoria Fotografica": qui il tag arriva da un Talento.
    tag: 'Psionico',
  ),
];
