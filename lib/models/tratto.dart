import '../enums/ambito_tratto.dart';

/// Modello/Tratto
///
/// Tratto di un'Arma o di un'Armatura. È un modello unico per entrambe,
/// con [ambiti] a dire dove si applica: stesso schema di
/// Modello/Capacità, che con TipoCapacita distingue capacità di tipi
/// diversi senza duplicare il modello.
///
/// Il motivo è che alcuni tratti valgono sia per le armi sia per le
/// armature: tenerli separati significherebbe scriverne il testo due
/// volte, con il rischio che le due copie divergano.
class Tratto {
  final String nome;
  final String descrizione;
  final String effetto;

  /// Dove si applica il tratto. Contiene entrambi i valori se il tratto
  /// vale sia per le armi sia per le armature.
  final List<AmbitoTratto> ambiti;

  const Tratto({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    required this.ambiti,
  });

  bool get valePerArmi => ambiti.contains(AmbitoTratto.arma);

  bool get valePerArmature => ambiti.contains(AmbitoTratto.armatura);

  factory Tratto.fromJson(Map<String, dynamic> json) {
    return Tratto(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
      ambiti: (json['ambiti'] as List<dynamic>? ?? [])
          .map((e) => AmbitoTratto.values.byName(e as String))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'effetto': effetto,
    'ambiti': ambiti.map((a) => a.name).toList(),
  };
}
