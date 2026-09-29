import '../enums/taglia.dart';
import '../models/capacita.dart';
import '../models/razza.dart';
import 'lista_capacita.dart';

Capacita _cap(String nome) => listaCapacita.firstWhere((c) => c.nome == nome);

/// Lista/Razze
///
/// ATTENZIONE - dati incompleti: non esiste ancora un documento
/// "Regolamento/Razze". Del gioco reale si conoscono solo i nomi delle
/// quattro razze; le Capacità di Razza qui associate e la descrizione
/// sono una proposta costruita sul nome, da rivedere quando i dati veri
/// saranno disponibili.
///
/// [Razza.tag] è per convenzione il nome della razza stessa, così il tag
/// compare fra quelli del personaggio (services/effetti_personaggio.dart).
/// [Razza.taglia] è al momento Media per tutte, non essendoci un dato che
/// dica quali razze siano Piccole.
final List<Razza> listaRazze = [
  Razza(
    nome: 'Solari',
    descrizione:
        'Nati vicino alle stelle, hanno pelle che trattiene la luce e una '
        'presenza difficile da ignorare.',
    capacita: [_cap('Riverbero Solare'), _cap('Vista Acuta')],
    tag: 'Solari',
    taglia: Taglia.media,
  ),
  Razza(
    nome: 'Mondriani',
    descrizione:
        'Gente di mondi pesanti, costruita per reggere: lenta a cedere e '
        'difficile da spostare.',
    capacita: [_cap('Passo Saldo'), _cap('Resistenza Innata')],
    tag: 'Mondriani',
    taglia: Taglia.media,
  ),
  Razza(
    nome: 'Tetramari',
    descrizione:
        'Cresciuti tra acque e profondità, sopportano pressioni che '
        'schiaccerebbero chiunque altro e non arretrano mai per primi.',
    capacita: [_cap('Respiro Profondo'), _cap('Ferocia Primordiale')],
    tag: 'Tetramari',
    taglia: Taglia.media,
  ),
  Razza(
    nome: 'Aeleidari',
    descrizione:
        'Longevi e silenziosi, conservano ricordi più lunghi di una vita '
        'e si muovono senza lasciare traccia.',
    capacita: [_cap('Memoria Lunga'), _cap('Passo Silenzioso')],
    tag: 'Aeleidari',
    taglia: Taglia.media,
  ),
];
