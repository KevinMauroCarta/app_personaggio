import '../enums/rarita.dart';
import 'tratto.dart';

/// Modello/Armatura
///
/// Riga Armatura della sezione Equipaggiamento della scheda: nome, PA
/// (Punti Armatura fisici) e PA Energia (Punti Armatura contro danni
/// energetici), entrambi numerici perché entrano nel calcolo di
/// Scheda.resilienzaFisica/resilienzaEnergetica (e [pa] anche in
/// Scheda.difesaArmatura), e Tratti.
class Armatura {
  final String nome;
  final int pa;
  final int paEnergia;
  final List<Tratto> tratti;

  /// Tag dell'armatura, presi da Lista/Tag (come per le Armi).
  final List<String> tag;

  /// Quanto costa procurarsela, sulla stessa scala di
  /// Modello/Armi/Arma.valore.
  final int valore;

  final Rarita rarita;

  const Armatura({
    required this.nome,
    required this.pa,
    required this.paEnergia,
    this.tratti = const [],
    this.tag = const [],
    required this.valore,
    required this.rarita,
  });

  factory Armatura.fromJson(Map<String, dynamic> json) {
    return Armatura(
      nome: json['nome'] as String,
      pa: json['pa'] as int,
      paEnergia: json['paEnergia'] as int,
      tratti: (json['tratti'] as List<dynamic>? ?? [])
          .map((e) => Tratto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: (json['tag'] as List<dynamic>? ?? []).cast<String>(),
      // Le armature salvate prima che esistessero questi campi non li
      // hanno: valgono zero e Comune finché non si riscelgono.
      valore: json['valore'] as int? ?? 0,
      rarita: json['rarita'] == null
          ? Rarita.comune
          : Rarita.values.byName(json['rarita'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'pa': pa,
    'paEnergia': paEnergia,
    'tratti': tratti.map((t) => t.toJson()).toList(),
    'tag': tag,
    'valore': valore,
    'rarita': rarita.name,
  };
}
