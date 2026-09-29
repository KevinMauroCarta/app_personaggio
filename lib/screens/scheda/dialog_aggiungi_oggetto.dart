import 'package:flutter/material.dart';

import '../../widgets/sezione_collassabile.dart';
import 'dettagli_oggetto.dart';

/// Modale per aggiungere un oggetto all'Equipaggiamento.
///
/// Una riga per oggetto: il nome a sinistra apre e chiude i suoi dati,
/// il "+" a destra lo aggiunge e chiude la modale. Il catalogo è lungo -
/// oggetti, armi e armature insieme - quindi in cima c'è un campo di
/// ricerca che filtra per nome mentre si scrive.
///
/// Si chiude restituendo il nome scelto, o null se si annulla.
class DialogAggiungiOggetto extends StatefulWidget {
  /// I nomi fra cui scegliere, di solito [oggettiOptions].
  final List<String> opzioni;

  const DialogAggiungiOggetto({super.key, required this.opzioni});

  @override
  State<DialogAggiungiOggetto> createState() => _DialogAggiungiOggettoState();
}

class _DialogAggiungiOggettoState extends State<DialogAggiungiOggetto> {
  final TextEditingController _ricerca = TextEditingController();

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  List<String> get _risultati {
    final cercato = _ricerca.text.trim().toLowerCase();
    if (cercato.isEmpty) return widget.opzioni;
    return widget.opzioni
        .where((o) => o.toLowerCase().contains(cercato))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final risultati = _risultati;

    return AlertDialog(
      title: const Text('Aggiungi oggetto'),
      content: SizedBox(
        width: double.maxFinite,
        // Altezza fissa: la modale deve restare della stessa dimensione
        // mentre si filtra, altrimenti "salta" a ogni lettera digitata.
        height: 420,
        child: Column(
          children: [
            TextField(
              controller: _ricerca,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Cerca',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _ricerca.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Pulisci',
                        onPressed: () => setState(_ricerca.clear),
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: risultati.isEmpty
                  ? const Center(child: Text('Nessun oggetto trovato.'))
                  : ListView.separated(
                      itemCount: risultati.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, indice) => _RigaOggetto(
                        nome: risultati[indice],
                        onAggiungi: () =>
                            Navigator.of(context).pop(risultati[indice]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
      ],
    );
  }
}

/// Riga della modale: nome a sinistra (apre i dati), "+" a destra.
class _RigaOggetto extends StatelessWidget {
  final String nome;
  final VoidCallback onAggiungi;

  const _RigaOggetto({required this.nome, required this.onAggiungi});

  @override
  Widget build(BuildContext context) {
    return SezioneCollassabile(
      titolo: nome,
      apertaIniziale: false,
      stileTitolo: const TextStyle(fontWeight: FontWeight.w600),
      azione: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        tooltip: 'Aggiungi $nome',
        onPressed: onAggiungi,
      ),
      figli: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: DettagliOggetto(nome: nome),
        ),
      ],
    );
  }
}
