import 'package:flutter/material.dart';

import 'scheda_dati.dart';

/// Tutti i dati di un oggetto, etichetta in grassetto e valore accanto.
///
/// Lo stesso elenco serve in due posti - dentro la riga della modale di
/// scelta e dentro il dialog che si apre toccando un oggetto già
/// posseduto - quindi sta qui invece che duplicato in entrambi.
class DettagliOggetto extends StatelessWidget {
  final String nome;

  const DettagliOggetto({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    final dati = datiOggetto(nome);
    if (dati.isEmpty) {
      return const Text('Nessun dato per questo oggetto.');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final campo in dati.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${campo.key}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: campo.value),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Apre i dati dell'oggetto [nome] in un dialog.
Future<void> mostraDettagliOggetto(BuildContext context, String nome) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(nome),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(child: DettagliOggetto(nome: nome)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Chiudi'),
        ),
      ],
    ),
  );
}
