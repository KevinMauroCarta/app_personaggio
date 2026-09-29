import '../models/lesione_traumatica.dart';

/// Lista/Lesioni_Traumatiche + Regolamento/Lesioni_Traumatiche
const List<LesioneTraumatica> listaLesioniTraumatiche = [
  LesioneTraumatica(
    nome: 'Perdita della Mano',
    descrizione:
        'Amputazione traumatica che elimina completamente la capacità di '
        'presa.',
    effetto:
        '-5 a tutte le prove che richiedono manipolazione fine o uso di '
        'una mano.',
  ),
  LesioneTraumatica(
    nome: 'Spalla Gravemente Danneggiata',
    descrizione:
        'Lesione severa che riduce drasticamente mobilità e forza del '
        'braccio.',
    effetto:
        '-3 ai test di forza del braccio e -2 ai test di attacco con armi '
        'a una mano.',
  ),
  LesioneTraumatica(
    nome: 'Costola Fratturata con Danno Interno',
    descrizione:
        'Frattura profonda che compromette respirazione e causa dolore '
        'acuto.',
    effetto: '-3 ai test di resistenza e -2 ai test fisici prolungati.',
  ),
  LesioneTraumatica(
    nome: 'Ginocchio con Legamenti Strappati',
    descrizione:
        'Instabilità grave che rende difficile correre, saltare o '
        'sostenere peso.',
    effetto: '-3 ai test di movimento e -2 ai test di schivata.',
  ),
  LesioneTraumatica(
    nome: 'Caviglia Fratturata e Instabile',
    descrizione: 'Frattura complessa che compromette equilibrio e mobilità.',
    effetto: '-3 ai test di agilità basati sulle gambe.',
  ),
  LesioneTraumatica(
    nome: 'Lacerazione Profonda al Braccio con Tendini Compromessi',
    descrizione:
        'Ferita severa che riduce forza, precisione e capacità di '
        'afferrare.',
    effetto: '-2 ai test di attacco e -3 ai test di manipolazione.',
  ),
  LesioneTraumatica(
    nome: 'Trauma Cranico con Deficit Persistenti',
    descrizione:
        'Lesione alla testa che causa vertigini, difficoltà cognitive e '
        'sensibilità alla luce.',
    effetto: '-2 ai test mentali e -2 ai test di percezione.',
  ),
];
