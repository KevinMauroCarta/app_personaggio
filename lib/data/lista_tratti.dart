import '../enums/ambito_tratto.dart';
import '../models/tratto.dart';

/// Lista/Tratti
///
/// Catalogo unico dei Tratti di Armi e Armature: dove un tratto si
/// applica lo dice [Tratto.ambiti], non la lista in cui si trova.
///
/// ATTENZIONE - dati segnaposto: l'elenco reale non esiste ancora. I tre
/// tratti di template hanno ogni campo valorizzato come
/// `template-{nome campo}-tratto-{n}` e coprono di proposito i tre casi
/// possibili (solo arma, solo armatura, entrambi), così da poterli
/// provare tutti. Da sostituire in blocco quando il regolamento sarà
/// disponibile.
const List<Tratto> listaTratti = [
  Tratto(
    nome: 'Furtiva',
    descrizione: 'questa arma è silenziosa e non fa rumore',
    effetto: 'quando si attacca di sorpresa, il bersaglio non può reagire',
    ambiti: [AmbitoTratto.arma],
  ),
  Tratto(
    nome: 'AntiBalistica',
    descrizione: 'è efficente nel proteggere da danni fisici',
    effetto: 'il danno subito da armi con tipologia Fisica è ridotto di 1',
    ambiti: [AmbitoTratto.armatura],
  ),
  Tratto(
    nome: 'Pesante',
    descrizione: 'è un oggetto pesante che rallenta chi lo porta',
    effetto: 'Quando si effettua uno scatto, si considera di avere Velocità -1',
    ambiti: [AmbitoTratto.arma, AmbitoTratto.armatura],
  ),
];

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
