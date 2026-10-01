import 'package:json_annotation/json_annotation.dart';

import '../enums/ambito_tratto.dart';

part 'tratto.g.dart';

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
@JsonSerializable()
class Tratto {
  final String nome;
  final String descrizione;
  final String effetto;

  /// Dove si applica il tratto. Contiene entrambi i valori se il tratto
  /// vale sia per le armi sia per le armature.
  @JsonKey(defaultValue: <AmbitoTratto>[])
  final List<AmbitoTratto> ambiti;

  const Tratto({
    required this.nome,
    required this.descrizione,
    required this.effetto,
    required this.ambiti,
  });

  bool get valePerArmi => ambiti.contains(AmbitoTratto.arma);

  bool get valePerArmature => ambiti.contains(AmbitoTratto.armatura);

  factory Tratto.fromJson(Map<String, dynamic> json) => _$TrattoFromJson(json);

  Map<String, dynamic> toJson() => _$TrattoToJson(this);
}
