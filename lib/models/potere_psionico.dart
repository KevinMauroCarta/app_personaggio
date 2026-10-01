import 'package:json_annotation/json_annotation.dart';

import '../enums/scuola_psionica.dart';
import '../enums/tipo_azione.dart';
import 'durata.dart';
import 'potenziamento.dart';

part 'potere_psionico.g.dart';

/// Modello/Potere_Psionico
///
/// [cd], [attivazione], [durata], [gittata] e [multiBersaglio] alimentano
/// le colonne omonime della tabella Poteri Psionici della scheda, oltre a
/// [nome] per la colonna Potere ed [effetto] per la colonna Effetto.
@JsonSerializable()
class PoterePsionico {
  final String nome;
  final ScuolaPsionica scuola;
  final String descrizione;
  final String effetto;

  final Potenziamento? potenziamento1;
  final Potenziamento? potenziamento2;

  /// Classe Difficoltà del test per attivare il potere.
  final int cd;

  /// Che tipo di azione costa attivare il potere.
  final TipoAzione attivazione;

  final Durata durata;

  final int gittata;

  /// True se il potere colpisce più di un bersaglio.
  final bool multiBersaglio;

  /// Costo in PE per apprendere il potere.
  final int costo;

  const PoterePsionico({
    required this.nome,
    required this.scuola,
    required this.descrizione,
    required this.effetto,
    required this.cd,
    required this.attivazione,
    required this.durata,
    required this.gittata,
    required this.multiBersaglio,
    required this.costo,
    this.potenziamento1,
    this.potenziamento2,
  });

  factory PoterePsionico.fromJson(Map<String, dynamic> json) =>
      _$PoterePsionicoFromJson(json);

  Map<String, dynamic> toJson() => _$PoterePsionicoToJson(this);
}
