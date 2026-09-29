import '../models/potenziamento.dart';

/// Lista/Potenziamenti + Regolamento/Potenziamenti
const List<Potenziamento> listaPotenziamenti = [
  Potenziamento(
    nome: 'Lama Mentale Potenziata',
    costo: 2,
    replicabile: true,
    effetto:
        'Aumenta la penetrazione del danno mentale, ignorando ulteriori '
        'difese psichiche.',
  ),
  Potenziamento(
    nome: 'Eco Psionico',
    costo: 1,
    replicabile: true,
    effetto:
        'Il potere genera un\'eco ritardata che ripete una versione '
        'ridotta dell\'effetto principale.',
  ),
  Potenziamento(
    nome: 'Sovraccarico Sinaptico',
    costo: 3,
    replicabile: false,
    effetto:
        'Il bersaglio subisce un collasso temporaneo delle sinapsi, '
        'riducendo drasticamente concentrazione e volontà.',
  ),
  Potenziamento(
    nome: 'Vortice Cognitivo',
    costo: 2,
    replicabile: true,
    effetto:
        'Crea un vortice mentale che trascina il bersaglio in un loop di '
        'pensieri distorti, rallentandone le azioni.',
  ),
  Potenziamento(
    nome: 'Sigillo dell\'Anima',
    costo: 4,
    replicabile: false,
    effetto:
        'Blocca temporaneamente una porzione dell\'essenza mentale del '
        'bersaglio, impedendo l\'uso di abilità psioniche.',
  ),
];
