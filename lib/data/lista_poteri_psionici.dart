import '../enums/scuola_psionica.dart';
import '../enums/tipo_azione.dart';
import '../models/durata.dart';
import '../models/potere_psionico.dart';

/// Lista/Poteri_Psionici + Regolamento/Poteri_Psionici
///
/// ATTENZIONE - incoerenza da chiarire con il game designer:
/// Regolamento/Poteri_Psionici descrive, per ogni potere, due righe nel
/// formato "dado / soglia raggiunta (sì/no) / effetto", mentre
/// Modello/Potere_Psionico si aspetta due riferimenti a Potenziamento
/// (Lista/Potenziamenti). Le due strutture non corrispondono. In attesa di
/// chiarimento, [potenziamento1] e [potenziamento2] sono lasciati a null e
/// le informazioni sui dadi sono riportate per intero nel campo [effetto].
///
/// ATTENZIONE - valori inventati: CD, attivazione, durata, gittata e
/// multi-bersaglio non sono nel documento originale, ma sono obbligatori
/// nel modello. Quelli qui sotto sono una proposta coerente con l'effetto
/// di ciascun potere, da rivedere quando ci saranno i dati veri.
const List<PoterePsionico> listaPoteriPsionici = [
  PoterePsionico(
    nome: 'Lancia Mentale',
    scuola: ScuolaPsionica.telepatia,
    descrizione:
        'Un proiettile di pura energia psichica perfora la mente del '
        'bersaglio.',
    effetto:
        'Infligge danno mentale diretto ignorando armature fisiche. 2d6: '
        'danno mentale aggiuntivo. 1d6 (fallito): stordimento per un '
        'turno.',
    cd: 3,
    attivazione: TipoAzione.standard,
    durata: Durata.istantanea(),
    gittata: 12,
    multiBersaglio: false,
    costo: 10,
  ),
  PoterePsionico(
    nome: 'Occhio dell\'Abisso',
    scuola: ScuolaPsionica.divinazione,
    descrizione:
        'Un occhio etereo si apre nella realtà, rivelando verità proibite.',
    effetto:
        'Il psionico vede creature nascoste, illusioni e presenze '
        'ultraterrene. 1d6: individuazione di entità occulte. 2d4 '
        '(fallito): penalità mentale al bersaglio osservato.',
    cd: 4,
    attivazione: TipoAzione.completa,
    durata: Durata.per(10, UnitaDurata.minuti),
    gittata: 20,
    multiBersaglio: false,
    costo: 10,
  ),
  PoterePsionico(
    nome: 'Fiamma Psichica',
    scuola: ScuolaPsionica.distruzione,
    descrizione:
        'Un fuoco invisibile avvolge il bersaglio, bruciando la sua '
        'essenza.',
    effetto:
        'Infligge danno energetico che ignora coperture e ostacoli. 3d4: '
        'danno energetico continuo. 1d6 (fallito): panico o fuga '
        'immediata.',
    cd: 5,
    attivazione: TipoAzione.standard,
    durata: Durata.per(3, UnitaDurata.round),
    gittata: 8,
    multiBersaglio: true,
    costo: 10,
  ),
  PoterePsionico(
    nome: 'Frattura della Volontà',
    scuola: ScuolaPsionica.dominazione,
    descrizione:
        'Il psionico spezza la determinazione del bersaglio, piegandone la '
        'mente.',
    effetto:
        'Il bersaglio subisce penalità ai test mentali e può obbedire a '
        'comandi semplici. 2d4: riduzione della volontà. 1d6 (fallito): '
        'confusione totale per un turno.',
    cd: 5,
    attivazione: TipoAzione.completa,
    durata: Durata.per(1, UnitaDurata.ore),
    gittata: 6,
    multiBersaglio: false,
    costo: 10,
  ),
  PoterePsionico(
    nome: 'Velo dell\'Ombra',
    scuola: ScuolaPsionica.illusione,
    descrizione:
        'Un mantello psichico avvolge il psionico, distorcendo la '
        'percezione altrui.',
    effetto:
        'Il psionico diventa difficile da individuare e i nemici '
        'falliscono attacchi contro di lui. 2d6: penalità ai test di '
        'percezione dei nemici. 1d4 (fallito): invisibilità parziale per '
        'un turno.',
    cd: 4,
    attivazione: TipoAzione.veloce,
    durata: Durata.per(5, UnitaDurata.round),
    gittata: 0,
    multiBersaglio: false,
    costo: 10,
  ),
];
