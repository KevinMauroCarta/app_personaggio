import '../enums/rarita.dart';

/// Modello/Oggetto
///
/// Quello che un personaggio si porta dietro e che non è né un'arma né
/// un'armatura: non ha valori di combattimento, ma ha un prezzo e una
/// Rarità come tutto il resto dell'equipaggiamento, perché anche questa
/// roba va procurata da qualche parte.
///
/// Prima gli Oggetti erano nome e descrizione e basta, e in scheda non
/// si poteva sapere quanto costasse quello che si aveva addosso.
class Oggetto {
  final String nome;
  final String descrizione;

  /// Quanto costa procurarselo, sulla stessa scala di Modello/Armi/Arma.
  final int valore;

  final Rarita rarita;

  const Oggetto({
    required this.nome,
    required this.descrizione,
    required this.valore,
    required this.rarita,
  });

  factory Oggetto.fromJson(Map<String, dynamic> json) {
    return Oggetto(
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String? ?? '',
      valore: json['valore'] as int? ?? 0,
      rarita: json['rarita'] == null
          ? Rarita.comune
          : Rarita.values.byName(json['rarita'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descrizione': descrizione,
    'valore': valore,
    'rarita': rarita.name,
  };
}
