import '../models/sistema.dart';
import '../models/capacita.dart';
import 'lista_capacita.dart';
import 'lista_pianeti.dart';

Capacita _cap(String nome) => listaCapacita.firstWhere((c) => c.nome == nome);

/// Lista/Sistemi + Regolamento/Sistemi
///
/// Nota: il campo "Mappa" (Modello/Sistema) non è ancora disponibile:
/// [Sistema.mappaAssetPath] resta a null per tutti i sistemi.
final List<Sistema> listaSistemi = [
  Sistema(
    nome: 'Sistema Solare',
    governo: 'Repubblica Federale',
    pianeti: pianetiSistemaSolare,
    capacitaDelSistema: [
      _cap('Disciplina Mentale'),
      _cap('Tenacia Ferrea'),
      _cap('Calcolo Strategico'),
    ],
    tag: 'Nodo Centrale',
  ),
  Sistema(
    nome: 'Sistema Ariete',
    governo: 'Oligarchia Militare',
    pianeti: pianetiSistemaAriete,
    capacitaDelSistema: [
      _cap('Precisione Letale'),
      _cap('Calcolo Strategico'),
      _cap('Sangue Freddo'),
    ],
    tag: 'Avanguardia',
  ),
  Sistema(
    nome: 'Sistema Toro',
    governo: 'Confederazione Mineraria',
    pianeti: pianetiSistemaToro,
    capacitaDelSistema: [
      _cap('Disciplina Mentale'),
      _cap('Tenacia Ferrea'),
      _cap('Sangue Freddo'),
    ],
    tag: 'Industriale',
  ),
  Sistema(
    nome: 'Sistema Gemelli',
    governo: 'Doppio Consiglio',
    pianeti: pianetiSistemaGemelli,
    capacitaDelSistema: [
      _cap('Calcolo Strategico'),
      _cap('Precisione Letale'),
      _cap('Disciplina Mentale'),
    ],
    tag: 'Strategico',
  ),
  Sistema(
    nome: 'Sistema Cancro',
    governo: 'Monarchia Tradizionale',
    pianeti: pianetiSistemaCancro,
    capacitaDelSistema: [
      _cap('Tenacia Ferrea'),
      _cap('Disciplina Mentale'),
      _cap('Sangue Freddo'),
    ],
    tag: 'Conservatore',
  ),
  Sistema(
    nome: 'Sistema Leone',
    governo: 'Dominio Solare',
    pianeti: pianetiSistemaLeone,
    capacitaDelSistema: [
      _cap('Precisione Letale'),
      _cap('Calcolo Strategico'),
      _cap('Addestramento Psichico'),
    ],
    tag: 'Dominante',
  ),
  Sistema(
    nome: 'Sistema Vergine',
    governo: 'Tecnocrazia',
    pianeti: pianetiSistemaVergine,
    capacitaDelSistema: [
      _cap('Calcolo Strategico'),
      _cap('Disciplina Mentale'),
      _cap('Addestramento Psichico'),
    ],
    tag: 'Analitico',
  ),
  Sistema(
    nome: 'Sistema Bilancia',
    governo: 'Assemblea Equilibrata',
    pianeti: pianetiSistemaBilancia,
    capacitaDelSistema: [
      _cap('Tenacia Ferrea'),
      _cap('Sangue Freddo'),
      _cap('Disciplina Mentale'),
    ],
    tag: 'Diplomatico',
  ),
  Sistema(
    nome: 'Sistema Scorpione',
    governo: 'Clan Segreti',
    pianeti: pianetiSistemaScorpione,
    capacitaDelSistema: [
      _cap('Precisione Letale'),
      _cap('Sangue Freddo'),
      _cap('Addestramento Psichico'),
    ],
    tag: 'Occulto',
  ),
  Sistema(
    nome: 'Sistema Sagittario',
    governo: 'Alleanza Nomade',
    pianeti: pianetiSistemaSagittario,
    capacitaDelSistema: [
      _cap('Calcolo Strategico'),
      _cap('Tenacia Ferrea'),
      _cap('Precisione Letale'),
    ],
    tag: 'Errante',
  ),
  Sistema(
    nome: 'Sistema Capricorno',
    governo: 'Direttorio Rigoroso',
    pianeti: pianetiSistemaCapricorno,
    capacitaDelSistema: [
      _cap('Disciplina Mentale'),
      _cap('Calcolo Strategico'),
      _cap('Tenacia Ferrea'),
    ],
    tag: 'Rigidità',
  ),
  Sistema(
    nome: 'Sistema Acquario',
    governo: 'Consorzio Scientifico',
    pianeti: pianetiSistemaAcquario,
    capacitaDelSistema: [
      _cap('Addestramento Psichico'),
      _cap('Calcolo Strategico'),
      _cap('Disciplina Mentale'),
    ],
    tag: 'Innovatore',
  ),
  Sistema(
    nome: 'Sistema Pesci',
    governo: 'Comunità Mistica',
    pianeti: pianetiSistemaPesci,
    capacitaDelSistema: [
      _cap('Addestramento Psichico'),
      _cap('Sangue Freddo'),
      _cap('Tenacia Ferrea'),
    ],
    tag: 'Spirituale',
  ),
];
