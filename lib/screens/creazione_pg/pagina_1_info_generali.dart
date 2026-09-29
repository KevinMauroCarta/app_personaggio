import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'creazione_pg_dati.dart';
import 'dettagli_modelli.dart';
import 'creazione_pg_widgets.dart';

/// Contenuto della Pagina 1 (Info Generali) del flusso di creazione
/// del personaggio: nome, razza, anni, genere, background, sistema e
/// pianeta di origine.
///
/// È un widget "stupido" (StatelessWidget): non gestisce lo stato al
/// proprio interno, riceve i valori attuali e notifica i cambiamenti
/// tramite callback al widget che lo usa (CharacterCreationPage).
class Pagina1InfoGenerali extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController anniController;
  final String? razzaSelezionata;
  final String? genereSelezionato;
  final String? backgroundSelezionato;
  final String? sistemaSelezionato;
  final String? pianetaSelezionato;

  final ValueChanged<String?> onRazzaChanged;
  final ValueChanged<String?> onGenereChanged;
  final ValueChanged<String?> onBackgroundChanged;
  final ValueChanged<String?> onSistemaChanged;
  final ValueChanged<String?> onPianetaChanged;
  final VoidCallback onAvanti;

  const Pagina1InfoGenerali({
    super.key,
    required this.nomeController,
    required this.anniController,
    required this.razzaSelezionata,
    required this.genereSelezionato,
    required this.backgroundSelezionato,
    required this.sistemaSelezionato,
    required this.pianetaSelezionato,
    required this.onRazzaChanged,
    required this.onGenereChanged,
    required this.onBackgroundChanged,
    required this.onSistemaChanged,
    required this.onPianetaChanged,
    required this.onAvanti,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome personaggio',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownConDettagli(
            label: 'Razza',
            valoreSelezionato: razzaSelezionata,
            opzioni: razzeOptions,
            descrizioni: razzeDescrizioni,
            contenutoInfo: (opzioni) =>
                DettagliRazza(razze: razzeDaNomi(opzioni)),
            onChanged: onRazzaChanged,
          ),
          if (razzaSelezionata != null) ...[
            const SizedBox(height: 16),
            _campoDipendente(
              TextField(
                controller: anniController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Anni',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _campoDipendente(
              DropdownButtonFormField<String>(
                initialValue: genereSelezionato,
                decoration: const InputDecoration(
                  labelText: 'Genere',
                  border: OutlineInputBorder(),
                ),
                items: genereOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: onGenereChanged,
              ),
            ),
          ],
          const SizedBox(height: 16),
          DropdownConDettagli(
            label: 'Background',
            valoreSelezionato: backgroundSelezionato,
            opzioni: backgroundOptions,
            descrizioni: backgroundDescrizioni,
            contenutoInfo: (opzioni) =>
                DettagliBackground(background: backgroundDaNomi(opzioni)),
            onChanged: onBackgroundChanged,
          ),
          const SizedBox(height: 16),
          DropdownConDettagli(
            label: 'Sistema di origine',
            valoreSelezionato: sistemaSelezionato,
            opzioni: sistemiOptions,
            descrizioni: sistemiDescrizioni,
            contenutoInfo: (opzioni) =>
                DettagliSistema(sistemi: sistemiDaNomi(opzioni)),
            onChanged: onSistemaChanged,
          ),
          if (sistemaSelezionato != null) ...[
            const SizedBox(height: 16),
            _campoDipendente(
              DropdownConDettagli(
                label: 'Pianeta di origine',
                valoreSelezionato: pianetaSelezionato,
                opzioni: pianetiPerSistema[sistemaSelezionato]!,
                // Niente descrizioni e niente Pulsante Info: il pianeta
                // discende dal sistema già scelto e i suoi dettagli non
                // cambiano la scelta, mentre un'icona in più su ogni
                // tendina rendeva la pagina confusa.
                descrizioni: const {},
                onChanged: onPianetaChanged,
              ),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onAvanti, child: const Text('Avanti')),
        ],
      ),
    );
  }

  /// Indenta un campo a destra con un bordo verticale a sinistra, per
  /// segnalare visivamente che dipende dal campo scelto subito sopra
  /// (es. Anni/Genere da Razza, Pianeta di origine da Sistema).
  Widget _campoDipendente(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey, width: 2)),
        ),
        child: child,
      ),
    );
  }
}
