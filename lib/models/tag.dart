import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

/// Modello/Tag
///
/// Un Tag è una parola che qualifica qualcosa - un personaggio, una
/// razza, un pianeta, un'arma - e su cui le regole possono fare
/// riferimento: il Tag "Psionico", per esempio, è quello che permette di
/// scegliere i Poteri Psionici.
///
/// I Tag non si scrivono a mano nei modelli: si prendono da Lista/Tag
/// (data/lista_tag.dart). Prima erano stringhe libere, e due punti del
/// gioco potevano riferirsi allo stesso tag scrivendolo in due modi
/// diversi senza che niente lo segnalasse.
@JsonSerializable()
class Tag {
  final String nome;
  @JsonKey(defaultValue: '')
  final String descrizione;

  const Tag({required this.nome, required this.descrizione});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
