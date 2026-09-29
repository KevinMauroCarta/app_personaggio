import 'armi/arma.dart';
import 'armatura.dart';

/// Modello/Equipaggiamento
///
/// Sezione Equipaggiamento della scheda: Armi, Armatura indossata,
/// Oggetti (elenco libero) e Ricchezza.
///
/// L'Influenza non sta qui: è ricavata dalla Socialità e vive come
/// getter in Modello/Scheda, accanto a Grinta e Fermezza.
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

  factory Equipaggiamento.fromJson(Map<String, dynamic> json) {
    return Equipaggiamento(
      armi: (json['armi'] as List<dynamic>? ?? [])
          .map((e) => Arma.fromJson(e as Map<String, dynamic>))
          .toList(),
      armatura: json['armatura'] == null
          ? null
          : Armatura.fromJson(json['armatura'] as Map<String, dynamic>),
      oggetti: (json['oggetti'] as List<dynamic>? ?? []).cast<String>(),
      ricchezza: json['ricchezza'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'armi': armi.map((a) => a.toJson()).toList(),
    'armatura': armatura?.toJson(),
    'oggetti': oggetti,
    'ricchezza': ricchezza,
  };
}
