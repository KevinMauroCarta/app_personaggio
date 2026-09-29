import '../enums/scuola_psionica.dart';
import '../enums/tipo_azione.dart';
import 'durata.dart';
import 'potenziamento.dart';

/// Modello/Potere_Psionico
///
/// [cd], [attivazione], [durata], [gittata] e [multiBersaglio] alimentano
/// le colonne omonime della tabella Poteri Psionici della scheda, oltre a
/// [nome] per la colonna Potere ed [effetto] per la colonna Effetto.
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

  factory PoterePsionico.fromJson(Map<String, dynamic> json) {
    return PoterePsionico(
      nome: json['nome'] as String,
      scuola: ScuolaPsionica.values.byName(json['scuola'] as String),
      descrizione: json['descrizione'] as String,
      effetto: json['effetto'] as String,
      potenziamento1: json['potenziamento1'] == null
          ? null
          : Potenziamento.fromJson(
              json['potenziamento1'] as Map<String, dynamic>,
            ),
      potenziamento2: json['potenziamento2'] == null
          ? null
          : Potenziamento.fromJson(
              json['potenziamento2'] as Map<String, dynamic>,
            ),
      cd: json['cd'] as int,
      attivazione: TipoAzione.values.byName(json['attivazione'] as String),
      durata: Durata.fromJson(json['durata'] as Map<String, dynamic>),
      gittata: json['gittata'] as int,
      multiBersaglio: json['multiBersaglio'] as bool,
      costo: json['costo'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'scuola': scuola.name,
    'descrizione': descrizione,
    'effetto': effetto,
    'potenziamento1': potenziamento1?.toJson(),
    'potenziamento2': potenziamento2?.toJson(),
    'cd': cd,
    'attivazione': attivazione.name,
    'durata': durata.toJson(),
    'gittata': gittata,
    'multiBersaglio': multiBersaglio,
    'costo': costo,
  };
}
