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
class Tag {
  final String nome;
  final String descrizione;

  const Tag({required this.nome, required this.descrizione});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'nome': nome, 'descrizione': descrizione};
}
