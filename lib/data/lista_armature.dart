import '../enums/rarita.dart';
import '../models/armatura.dart';
import 'lista_tratti.dart';

/// Lista/Armature
///
/// ATTENZIONE - dati segnaposto: come per Lista/Armi non esiste ancora un
/// "Regolamento/Armature". Le tre armature di template hanno il nome
/// valorizzato come `template-{nome campo}-armatura-{n}`, mentre [Armatura.pa]
/// e [Armatura.paEnergia] sono numerici (entrano nel calcolo di
/// Scheda.resilienzaFisica/resilienzaEnergetica) e portano il solo numero
/// progressivo. I Tratti vengono da Lista/Tratti_Armatura, a sua volta
/// segnaposto. Valore e Rarità sono tarati sui PA e sulla scala dei
/// prezzi di Lista/Armi.
///
/// Da sostituire integralmente quando il regolamento sarà disponibile.
final List<Armatura> listaArmature = [
  Armatura(
    nome: 'template-nome-armatura-3',
    pa: 1,
    paEnergia: 1,
    tratti: [tratto('Scudo', '1')],
    valore: 15,
    rarita: Rarita.comune,
  ),
  Armatura(
    nome: 'template-nome-armatura-0',
    pa: 2,
    paEnergia: 2,
    tratti: [tratto('Massiccia', '1')],
    valore: 35,
    rarita: Rarita.nonComune,
  ),
  Armatura(
    nome: 'template-nome-armatura-6',
    pa: 3,
    paEnergia: 3,
    tratti: [tratto('Ingombrante'), tratto('Potenziata', '1')],
    valore: 70,
    rarita: Rarita.rara,
  ),
];
