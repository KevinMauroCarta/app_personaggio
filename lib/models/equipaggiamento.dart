import 'package:json_annotation/json_annotation.dart';

import 'armi/arma.dart';
import 'armatura.dart';

part 'equipaggiamento.g.dart';

/// Modello/Equipaggiamento
///
/// Sezione Equipaggiamento della scheda: Armi, Armatura indossata,
/// Oggetti (elenco libero) e Ricchezza.
///
/// L'Influenza non sta qui: è ricavata dalla Socialità e vive come
/// getter in Modello/Scheda, accanto a Grinta e Fermezza.
@JsonSerializable()
class Equipaggiamento {
  final List<Arma> armi;
  final Armatura? armatura;
  final List<String> oggetti;
  final int ricchezza;

  const Equipaggiamento({
    this.armi = const [],
    this.armatura,
    this.oggetti = const [],
    this.ricchezza = 0,
  });

  factory Equipaggiamento.fromJson(Map<String, dynamic> json) =>
      _$EquipaggiamentoFromJson(json);

  Map<String, dynamic> toJson() => _$EquipaggiamentoToJson(this);
}
