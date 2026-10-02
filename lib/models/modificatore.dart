import 'package:json_annotation/json_annotation.dart';

import '../enums/bersaglio.dart';

part 'modificatore.g.dart';

/// Modello/Modificatore: cambia di [valore] (anche negativo) il
/// [bersaglio], che può essere una Caratteristica, un'Abilità o un valore
/// della Scheda (es. Ferite Massime, Velocità).
///
/// Lo portano Capacità, Background, Mutazioni, Chip Neurali e Protesi,
/// ognuno in una lista `modificatori`: quanti ne servono, su qualunque
/// bersaglio.
@JsonSerializable()
class Modificatore {
  @JsonKey(readValue: _leggiBersaglio)
  final Bersaglio bersaglio;
  final int valore;

  const Modificatore({required this.bersaglio, required this.valore});

  /// "Forza +1", "Velocità -2": con il segno sempre esplicito, come sulla
  /// scheda cartacea.
  String get testo => '${bersaglio.label} ${valore >= 0 ? '+' : ''}$valore';

  factory Modificatore.fromJson(Map<String, dynamic> json) =>
      _$ModificatoreFromJson(json);

  Map<String, dynamic> toJson() => _$ModificatoreToJson(this);
}

/// I Modificatori salvati prima del catalogo dei Bersagli avevano solo il
/// `nome` della Caratteristica o dell'Abilità: lo si traduce nel Bersaglio
/// che porta quel nome.
Object? _leggiBersaglio(Map<dynamic, dynamic> json, String chiave) =>
    json[chiave] ?? Bersaglio.daLabel(json['nome'] as String? ?? '')?.name;

/// Legge la lista `modificatori` di un modello salvato. Nei salvataggi di
/// prima c'erano al suo posto i due campi singoli
/// `modificatoreCaratteristica` e `modificatoreAbilita`: se la lista
/// manca, la si ricompone da quelli.
///
/// Da usare come `readValue` del campo `modificatori` dei modelli che ne
/// hanno uno.
Object? leggiModificatori(Map<dynamic, dynamic> json, String chiave) =>
    json[chiave] ??
    [
      for (final vecchio in [
        'modificatoreCaratteristica',
        'modificatoreAbilita',
      ])
        ?json[vecchio],
    ];
