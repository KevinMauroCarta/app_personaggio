import '../models/abilita.dart';
import '../models/caratteristica.dart';
import 'lista_caratteristiche.dart';

Caratteristica _car(String nome) =>
    listaCaratteristiche.firstWhere((c) => c.nome == nome);

/// Lista/Abilità + Regolamento/Abilità
///
/// Nota: il flag [Abilita.addestramento] corrisponde alle abilità marcate
/// con asterisco (*) in Lista/Abilità (Regolamento/Abilità*: non
/// utilizzabili senza almeno 1 in Valore Base). Questo risolve il dubbio
/// precedentemente aperto sul significato degli asterischi.
///
/// Nota: nel documento originale la Caratteristica di alcune abilità
/// (Percezione, Tecnologia, Sopravvivenza, Astuzia) è riportata come
/// "Intelleto": corretta qui in "Intelletto" per coerenza con
/// Lista/Caratteristiche.
final List<Abilita> listaAbilita = [
  Abilita(
    nome: 'Atletica',
    descrizione:
        'Capacità di compiere sforzi fisici intensi: correre, saltare, '
        'arrampicarsi, sollevare pesi e resistere alla fatica.',
    caratteristica: _car('Forza'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Mischia Pesante',
    descrizione:
        'Combattere in corpo a corpo con armi basate sulla forza — '
        'martelli, mazze, asce pesanti.',
    caratteristica: _car('Forza'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Tempra',
    descrizione:
        'Resistenza fisica e mentale contro dolore, fatica, veleno, '
        'malattie e condizioni debilitanti.',
    caratteristica: _car('Resistenza'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Furtività',
    descrizione:
        'Capacità di muoversi silenziosamente, nascondersi ed evitare '
        'l\'attenzione.',
    caratteristica: _car('Agilità'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Mira',
    descrizione:
        'Uso di tutte le armi a distanza, incluse armi da fuoco, archi, '
        'balestre e armi tecnologiche.',
    caratteristica: _car('Agilità'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Pilotaggio',
    descrizione: 'Capacità di guidare veicoli terrestri, volanti o spaziali.',
    caratteristica: _car('Agilità'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Mischia Leggera',
    descrizione:
        'Combattere in corpo a corpo con armi basate sulla reattività — '
        'spade, pugnali, lame leggere.',
    caratteristica: _car('Iniziativa'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Comando',
    descrizione:
        'Capacità di impartire ordini, guidare gruppi, mantenere disciplina '
        'e ispirare alleati.',
    caratteristica: _car('Volontà'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Controllo Psionico',
    descrizione:
        'Manifestare poteri psionici e manipolare il Warp per alterare la '
        'realtà.',
    caratteristica: _car('Volontà'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Intimidazione',
    descrizione:
        'Incutere paura, pressione psicologica o rispetto attraverso tono, '
        'postura, minaccia o presenza.',
    caratteristica: _car('Volontà'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Investigazione',
    descrizione:
        'Raccogliere indizi, analizzare tracce, ricostruire eventi e '
        'scoprire informazioni nascoste.',
    caratteristica: _car('Intelletto'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Istruzione',
    descrizione:
        'Conoscenza accademica, teorica o formale: storia, scienze, '
        'cultura generale.',
    caratteristica: _car('Intelletto'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Medicae',
    descrizione:
        'Curare ferite, stabilizzare feriti, diagnosticare problemi fisici '
        'e utilizzare strumenti medici.',
    caratteristica: _car('Intelletto'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Percezione',
    descrizione:
        'Notare dettagli, ascoltare suoni, percepire movimenti e cogliere '
        'segnali ambientali.',
    caratteristica: _car('Intelletto'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Tecnologia',
    descrizione:
        'Comprendere, riparare, modificare e utilizzare dispositivi '
        'tecnologici, macchinari e sistemi complessi.',
    caratteristica: _car('Intelletto'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Sopravvivenza',
    descrizione:
        'Vivere in ambienti ostili: trovare cibo, acqua, riparo, '
        'orientarsi, evitare pericoli naturali e gestire emergenze.',
    caratteristica: _car('Intelletto'),
    addestramento: true,
  ),
  Abilita(
    nome: 'Astuzia',
    descrizione:
        'Pensare rapidamente, trovare soluzioni improvvisate, cogliere '
        'opportunità e sfruttare debolezze altrui.',
    caratteristica: _car('Intelletto'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Inganno',
    descrizione:
        'Mentire, manipolare, creare false impressioni e nascondere la '
        'verità.',
    caratteristica: _car('Socialità'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Intuizione',
    descrizione: 'Leggere emozioni, intenzioni e stati d\'animo altrui.',
    caratteristica: _car('Socialità'),
    addestramento: false,
  ),
  Abilita(
    nome: 'Persuasione',
    descrizione:
        'Convincere, negoziare, influenzare e ottenere consenso attraverso '
        'argomentazione, carisma o diplomazia.',
    caratteristica: _car('Socialità'),
    addestramento: false,
  ),
];
