import 'package:flutter/material.dart';

/// Sezione con titolo cliccabile che mostra/nasconde il proprio
/// contenuto, usata da tutte le schermate a sezioni (Creazione,
/// Modifica, Aumento, Scheda) così che il comportamento sia identico
/// ovunque. Le sezioni partono aperte.
///
/// Il widget rende solo intestazione + contenuto: l'eventuale
/// contenitore (es. la Card usata da Scheda e Riepilogo) resta a carico
/// di chi la usa.
class SezioneCollassabile extends StatefulWidget {
  final String titolo;
  final List<Widget> figli;

  /// Widget opzionale a fianco del titolo, es. un Pulsante Info. Resta
  /// fuori dall'area cliccabile del titolo, così premerlo apre le info
  /// invece di chiudere la sezione.
  final Widget? azione;

  /// Testo esplicativo mostrato sotto il titolo quando la sezione è
  /// aperta (es. le restrizioni di Avanzamento/Abilità).
  final String? sottotitolo;

  final TextStyle stileTitolo;

  /// Se true, inserisce un Divider tra intestazione e contenuto (stile
  /// delle sezioni dentro una Card).
  final bool divisore;

  /// Le sezioni partono aperte. Chi elenca molte voci di dettaglio (es.
  /// i singoli Talenti e Capacità nella Scheda) le fa invece partire
  /// chiuse, così l'elenco resta leggibile e si apre una voce alla volta.
  final bool apertaIniziale;

  const SezioneCollassabile({
    super.key,
    required this.titolo,
    required this.figli,
    this.azione,
    this.sottotitolo,
    this.stileTitolo = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.divisore = false,
    this.apertaIniziale = true,
  });

  @override
  State<SezioneCollassabile> createState() => _SezioneCollassabileState();
}

class _SezioneCollassabileState extends State<SezioneCollassabile> {
  late bool _aperta = widget.apertaIniziale;

  @override
  Widget build(BuildContext context) {
    // Aperta o chiusa si deve capire senza provare a toccarla: la
    // freccia punta in basso quando la sezione è aperta e a destra
    // quando è chiusa, e il titolo si colora solo da aperta.
    final coloreAperta = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _aperta = !_aperta),
                child: Row(
                  children: [
                    Icon(
                      _aperta ? Icons.expand_more : Icons.chevron_right,
                      size: (widget.stileTitolo.fontSize ?? 18) + 4,
                      color: _aperta ? coloreAperta : null,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.titolo,
                        style: _aperta
                            ? widget.stileTitolo.copyWith(color: coloreAperta)
                            : widget.stileTitolo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.azione != null) widget.azione!,
          ],
        ),
        if (_aperta) ...[
          if (widget.sottotitolo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.sottotitolo!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (widget.divisore) const Divider(),
          ...widget.figli,
        ],
      ],
    );
  }
}
