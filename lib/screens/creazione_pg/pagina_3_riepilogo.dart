import 'package:flutter/material.dart';

import '../../widgets/sezione_collassabile.dart';
import 'creazione_pg_dati.dart';

/// Contenuto della Pagina 3 (Riepilogo) del flusso di creazione del
/// personaggio: mostra tutti i dati raccolti nelle pagine precedenti
/// e offre i bottoni "Indietro" e "CREA".
class Pagina3Riepilogo extends StatelessWidget {
  final String nome;
  final String razza;
  final String anni;
  final String genere;
  final String background;
  final String sistemaOrigine;
  final String pianetaOrigine;
  final int pxDisponibili;
  final Map<String, int> valoriCaratteristiche;
  final Map<String, int> valoriAbilita;
  final String? talentoSelezionato;
  final String? capacitaRazzaSelezionata;
  final String? capacitaSistemaSelezionata;
  final String? capacitaBackgroundSelezionata;
  final List<String> capacitaGeneriche;

  /// Vuota se il personaggio non ha il Tag Psionico: in quel caso la
  /// sezione non compare nel riepilogo.
  final List<String> poteriPsionici;

  final VoidCallback onIndietro;
  final VoidCallback onCrea;
  final String etichettaBottoneCrea;

  const Pagina3Riepilogo({
    super.key,
    required this.nome,
    required this.razza,
    required this.anni,
    required this.genere,
    required this.background,
    required this.sistemaOrigine,
    required this.pianetaOrigine,
    required this.pxDisponibili,
    required this.valoriCaratteristiche,
    required this.valoriAbilita,
    required this.talentoSelezionato,
    required this.capacitaRazzaSelezionata,
    required this.capacitaSistemaSelezionata,
    required this.capacitaBackgroundSelezionata,
    required this.capacitaGeneriche,
    required this.poteriPsionici,
    required this.onIndietro,
    required this.onCrea,
    this.etichettaBottoneCrea = 'CREA',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Dati generali', [
            _RigaRiepilogo('Nome personaggio', nome),
            _RigaRiepilogo('Razza', razza),
            _RigaRiepilogo('Anni', anni),
            _RigaRiepilogo('Genere', genere),
            _RigaRiepilogo('Background', background),
            _RigaRiepilogo('Sistema di origine', sistemaOrigine),
            _RigaRiepilogo('Pianeta di origine', pianetaOrigine),
            _RigaRiepilogo('PX disponibili', '$pxDisponibili'),
          ]),
          const SizedBox(height: 16),
          _buildSezione(
            'Caratteristiche',
            valoriCaratteristiche.entries
                .map((e) => _RigaRiepilogo(e.key, '${e.value}'))
                .toList(),
            pxSpesi: pxSpesiCaratteristiche(valoriCaratteristiche),
          ),
          const SizedBox(height: 16),
          _buildSezione(
            'Abilità',
            valoriAbilita.entries
                .map(
                  (e) => _RigaRiepilogo(
                    abilitaDaNome(e.key).addestramento ? '${e.key}*' : e.key,
                    '${e.value}',
                  ),
                )
                .toList(),
            pxSpesi: pxSpesiAbilita(valoriAbilita),
            sottotitolo: legendaAsteriscoAbilita,
          ),
          const SizedBox(height: 16),
          _buildSezione('Talento', [
            _RigaRiepilogo('Talento', talentoSelezionato ?? '-'),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Capacità di Razza', [
            _RigaRiepilogo(
              'Capacità di Razza',
              capacitaRazzaSelezionata ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Capacità di Sistema', [
            _RigaRiepilogo(
              'Capacità di Sistema',
              capacitaSistemaSelezionata ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Capacità di Background', [
            _RigaRiepilogo(
              'Capacità di Background',
              capacitaBackgroundSelezionata ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildSezione(
            'Capacità Generiche',
            capacitaGeneriche.isEmpty
                ? [_RigaRiepilogo('Capacità Generiche', '-')]
                : capacitaGeneriche
                      .map(
                        (nome) =>
                            _RigaRiepilogo(nome, '${costoCapacita(nome)} PE'),
                      )
                      .toList(),
            pxSpesi: pxSpesiCapacitaGeneriche(capacitaGeneriche),
          ),
          if (poteriPsionici.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSezione(
              'Poteri Psionici',
              poteriPsionici.map((p) => _RigaRiepilogo(p, '')).toList(),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onIndietro,
                  child: const Text('Indietro'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCrea,
                  child: Text(etichettaBottoneCrea),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sezione del riepilogo. Se [pxSpesi] è fornito, accanto al titolo
  /// viene mostrato quanto si sta spendendo in quella categoria.
  Widget _buildSezione(
    String titolo,
    List<_RigaRiepilogo> righe, {
    int? pxSpesi,
    String? sottotitolo,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SezioneCollassabile(
          titolo: titolo,
          sottotitolo: sottotitolo,
          stileTitolo: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          azione: pxSpesi == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '$pxSpesi PE spesi',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          divisore: true,
          figli: righe
              .map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(r.etichetta)),
                      Text(
                        r.valore,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Semplice coppia etichetta/valore usata nella pagina di riepilogo.
class _RigaRiepilogo {
  final String etichetta;
  final String valore;

  const _RigaRiepilogo(this.etichetta, this.valore);
}
