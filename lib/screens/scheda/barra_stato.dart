import 'package:flutter/material.dart';

/// Barra che mostra quanto si è incassato: Ferite e Shock.
///
/// Parte tutta del colore acceso e si riempie di quello scuro man mano
/// che [attuali] sale verso [massimi]: la parte scura è il danno preso,
/// e la barra tutta scura vuol dire che non c'è più spazio. Il numero
/// scritto sopra è "attuali / massimi", come si segna sulla scheda di
/// carta.
///
/// I due colori sono la stessa tinta - rosso per le Ferite, blu per lo
/// Shock - in due intensità: così si capisce a colpo d'occhio di quale
/// barra si tratta anche senza leggere l'etichetta, e allo stesso tempo
/// si vede quanta ne resta.
class BarraStato extends StatelessWidget {
  final String etichetta;
  final int attuali;
  final int massimi;

  /// La tinta accesa: quanto si ha ancora da incassare.
  final Color coloreLibero;

  /// La tinta scura: quanto si è già incassato.
  final Color colorePreso;

  /// Se fornito, la barra si può toccare (es. per segnare il danno).
  final VoidCallback? onTap;

  /// Riga in piccolo sotto la barra, per i valori che servono a
  /// leggerla (es. le Resilienze sotto le Ferite).
  final String? sottotitolo;

  const BarraStato({
    super.key,
    required this.etichetta,
    required this.attuali,
    required this.massimi,
    required this.coloreLibero,
    required this.colorePreso,
    this.onTap,
    this.sottotitolo,
  });

  /// Quanta barra è colorata, da 0 a 1: cresce col valore. A massimi 0
  /// la barra resta vuota, perché dividere per zero non si può.
  double get quotaRiempita {
    if (massimi <= 0) return 0;
    return (attuali / massimi).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    final barra = Stack(
      alignment: Alignment.center,
      children: [
        // Il fondo è la parte ancora libera; sopra ci va quella presa.
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: coloreLibero,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorePreso),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: quotaRiempita,
                child: Container(color: colorePreso),
              ),
            ),
          ),
        ),
        // Bianco con un'ombra: il numero passa sopra a entrambe le
        // tinte, e nessuna delle due è abbastanza chiara da reggere il
        // testo scuro né abbastanza scura da reggere il bianco liscio.
        Text(
          '$attuali / $massimi',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              etichetta,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              Icon(Icons.touch_app, size: 14, color: colori.primary),
            ],
          ],
        ),
        const SizedBox(height: 4),
        if (onTap == null)
          barra
        else
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: barra,
          ),
        if (sottotitolo != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              sottotitolo!,
              style: TextStyle(fontSize: 12, color: colori.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
