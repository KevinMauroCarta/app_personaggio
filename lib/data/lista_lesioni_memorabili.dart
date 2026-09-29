import '../models/lesione_memorabile.dart';

/// Lista/Lesioni_Memorabili + Regolamento/Lesioni_Memorabili
const List<LesioneMemorabile> listaLesioniMemorabili = [
  LesioneMemorabile(
    nome: 'Mano Rotta',
    descrizione:
        'Frattura dolorosa che limita la presa e la manipolazione fine.',
    effetto: '-2 a tutte le prove che richiedono destrezza manuale.',
  ),
  LesioneMemorabile(
    nome: 'Spalla Lussata',
    descrizione:
        'Articolazione fuori sede che riduce forza e mobilità del braccio.',
    effetto: '-2 ai test di forza e -1 ai test di attacco con armi a una mano.',
  ),
  LesioneMemorabile(
    nome: 'Costola Incrinata',
    descrizione: 'Dolore acuto che ostacola respirazione e movimento.',
    effetto: '-1 ai test di resistenza e -1 ai test fisici prolungati.',
  ),
  LesioneMemorabile(
    nome: 'Ginocchio Distorto',
    descrizione: 'Lesione ai legamenti che compromette stabilità e corsa.',
    effetto: '-2 ai test di movimento e -1 ai test di schivata.',
  ),
  LesioneMemorabile(
    nome: 'Caviglia Slogata',
    descrizione:
        'Articolazione instabile che rende difficile camminare o correre.',
    effetto: '-2 ai test di agilità basati sulle gambe.',
  ),
  LesioneMemorabile(
    nome: 'Taglio Profondo al Braccio',
    descrizione:
        'Ferita sanguinante che riduce precisione e forza del braccio.',
    effetto: '-1 ai test di attacco e -1 ai test di manipolazione.',
  ),
  LesioneMemorabile(
    nome: 'Contusione alla Testa',
    descrizione: 'Trauma che causa vertigini e difficoltà di concentrazione.',
    effetto: '-1 ai test mentali e -1 ai test di percezione.',
  ),
];
