import 'package:json_annotation/json_annotation.dart';

import '../enums/rarita.dart';

part 'oggetto.g.dart';

/// Modello/Oggetto
///
/// Quello che un personaggio si porta dietro e che non è né un'arma né
/// un'armatura: non ha valori di combattimento, ma ha un prezzo e una
/// Rarità come tutto il resto dell'equipaggiamento, perché anche questa
/// roba va procurata da qualche parte.
///
/// Prima gli Oggetti erano nome e descrizione e basta, e in scheda non
/// si poteva sapere quanto costasse quello che si aveva addosso.
@JsonSerializable()
class Oggetto {
  final String nome;
  @JsonKey(defaultValue: '')
  final String descrizione;

  /// Quanto costa procurarselo, sulla stessa scala di Modello/Armi/Arma.
  @JsonKey(defaultValue: 0)
  final int valore;

  @JsonKey(defaultValue: Rarita.comune)
  final Rarita rarita;

  const Oggetto({
    required this.nome,
    required this.descrizione,
    required this.valore,
    required this.rarita,
  });

  factory Oggetto.fromJson(Map<String, dynamic> json) =>
      _$OggettoFromJson(json);

  Map<String, dynamic> toJson() => _$OggettoToJson(this);
}
