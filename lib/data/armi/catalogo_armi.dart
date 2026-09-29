import '../../models/armi/arma.dart';
import 'lista_armi_distanza.dart';
import 'lista_armi_mischia.dart';

export 'lista_armi_distanza.dart';
export 'lista_armi_mischia.dart';

/// Lista/Armi
///
/// Il catalogo completo: le armi da mischia (Lista/Armi/Mischia) seguite
/// da quelle a distanza (Lista/Armi/Distanza). Qui non c'è nessuna arma
/// scritta: le armi stanno nei due file a fianco, ed è lì che si va per
/// aggiungerne o correggerne una.
///
/// Questo file serve a chi le vuole tutte insieme, senza distinzione di
/// tipo - per esempio le tendine dell'Equipaggiamento in Scheda - e
/// riesporta i due elenchi, così un solo import basta a tutti e tre.
///
/// Chi ha bisogno di un tipo solo usa direttamente `listaArmiMischia` o
/// `listaArmiDistanza` e si tiene il tipo preciso
/// ([ArmaMischia]/[ArmaDistanza]) invece di [Arma].
final List<Arma> listaArmi = [...listaArmiMischia, ...listaArmiDistanza];
