import 'package:flutter/material.dart';

import '../../enums/tipo_capacita.dart';
import '../../models/capacita.dart';
import '../../models/modificatore.dart';
import '../../widgets/sezione_collassabile.dart';

/// Dialog per aggiungere o sottrarre una quantità di PX, usato sia dalla
/// Creazione sia dall'Aumento del personaggio (in entrambi i casi si
/// parte da 0 o da un valore assegnato dal narratore, e questa è
/// l'unica via per farlo crescere).
Future<void> mostraDialogModificaPx({
  required BuildContext context,
  required int pxAttuali,
  required ValueChanged<int> onPxCambiati,
}) {
  final controller = TextEditingController();
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Modifica Punti Esperienza'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantità',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              final quantita = int.tryParse(controller.text) ?? 0;
              if (quantita > 0) {
                onPxCambiati((pxAttuali - quantita).clamp(0, 1 << 31));
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Sottrai'),
          ),
          TextButton(
            onPressed: () {
              final quantita = int.tryParse(controller.text) ?? 0;
              if (quantita > 0) {
                onPxCambiati(pxAttuali + quantita);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Aggiungi'),
          ),
        ],
      );
    },
  );
}

/// Tabella "Valore -> Costo in PX" mostrata nel Pulsante Info accanto ai
/// titoli "Caratteristiche" e "Abilità", sia in Creazione/Modifica sia in
/// Aumento.
class TabellaCosti extends StatelessWidget {
  final int valoreIniziale;
  final int valoreMassimo;
  final int Function(int valoreArrivo) costo;

  const TabellaCosti({
    super.key,
    required this.valoreIniziale,
    required this.valoreMassimo,
    required this.costo,
  });

  @override
  Widget build(BuildContext context) {
    const stileIntestazione = TextStyle(fontWeight: FontWeight.bold);

    // Il costo è quello del singolo passaggio, non del totale: arrivare
    // a 4 non costa quanto dice la riga del 4, ma la somma di tutte le
    // righe fino a lì. È l'informazione che mancava, quindi la terza
    // colonna la mostra invece di lasciarla da calcolare a mente.
    var totale = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Ogni riga è il costo per salire di un punto. Per arrivare a '
            'un valore si paga la somma di tutti i passaggi.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('Per arrivare a', style: stileIntestazione),
                ),
                Text('Costo', style: stileIntestazione),
                Text('Totale', style: stileIntestazione),
              ],
            ),
            for (var valore = valoreIniziale; valore <= valoreMassimo; valore++)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('$valore'),
                  ),
                  Text('${costo(valore)} PE'),
                  Text('${totale += costo(valore)} PE'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// Bottone informativo generico: apre un dialog con titolo e contenuto,
/// usato da tutti i Pulsanti Info del flusso di creazione personaggio.
class InfoButton extends StatelessWidget {
  final String titolo;
  final WidgetBuilder contenutoBuilder;
  final String tooltip;
  final bool enabled;

  const InfoButton({
    super.key,
    required this.titolo,
    required this.contenutoBuilder,
    this.tooltip = 'Mostra dettagli',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: tooltip,
      onPressed: !enabled
          ? null
          : () => showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(titolo),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: contenutoBuilder(dialogContext),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Chiudi'),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Contenuto per il dialog "Dettagli" di un dropdown: elenco di nome +
/// descrizione per ciascuna opzione disponibile.
///
/// Se [etichetteSecondarie] contiene l'opzione, la sua etichetta (es. il
/// costo in PE di una Capacità) viene mostrata in fondo alla stessa riga
/// del nome, non sotto la descrizione.
class DettagliOpzioni extends StatelessWidget {
  final List<String> opzioni;
  final Map<String, String> descrizioni;
  final Map<String, String>? etichetteSecondarie;

  const DettagliOpzioni({
    super.key,
    required this.opzioni,
    required this.descrizioni,
    this.etichetteSecondarie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: opzioni.map((o) {
        final secondaria = etichetteSecondarie?[o];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SezioneCollassabile(
            titolo: o,
            // Con una voce sola non c'è niente da sfogliare: si apre già.
            apertaIniziale: opzioni.length == 1,
            stileTitolo: const TextStyle(fontWeight: FontWeight.bold),
            azione: secondaria == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      secondaria,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
            figli: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 2, bottom: 4),
                child: Text(descrizioni[o] ?? ''),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Contenuto del Pulsante Info per le Capacità: una scheda per ciascuna
/// capacità, nel formato
///
///     {nome}                                   Costo: {costo}
///     Tipo: {tipo}
///     Descrizione: {descrizione}
///     Effetto: {effetto}
///     {modificatoreCaratteristica.nome} +{valore}
///     {modificatoreAbilita.nome} +{valore}
///     [{tag}]
///
/// I modificatori compaiono solo se presenti e il loro valore ha sempre
/// il segno esplicito: sono i bonus che la capacità aggiunge al Valore
/// Bonus di quella Caratteristica/Abilità.
class DettagliCapacita extends StatelessWidget {
  final List<Capacita> capacita;

  const DettagliCapacita({super.key, required this.capacita});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: capacita
          .map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SezioneCollassabile(
                titolo: c.nome,
                // Con una capacità sola non c'è niente da sfogliare.
                apertaIniziale: capacita.length == 1,
                stileTitolo: const TextStyle(fontWeight: FontWeight.bold),
                azione: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _campo('Costo', '${c.costo}'),
                ),
                figli: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 2, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _campo('Tipo', c.tipo.label),
                        _campo('Descrizione', c.descrizione),
                        _campo('Effetto', c.effetto),
                        if (c.modificatoreCaratteristica != null)
                          Text(_modificatore(c.modificatoreCaratteristica!)),
                        if (c.modificatoreAbilita != null)
                          Text(_modificatore(c.modificatoreAbilita!)),
                        if (c.tag.isNotEmpty) Text('[${c.tag.join(', ')}]'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _campo(String etichetta, String valore) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87),
        children: [
          TextSpan(
            text: '$etichetta: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: valore),
        ],
      ),
    );
  }

  /// "{nome} +{valore}", con il segno sempre esplicito.
  String _modificatore(Modificatore m) =>
      '${m.nome} ${m.valore >= 0 ? '+' : '-'}${m.valore.abs()}';
}

/// Dropdown con, a fianco, un Pulsante Info e (opzionalmente) un bottone
/// "X" per azzerare la selezione corrente.
///
/// Il Pulsante Info mostra normalmente la descrizione di tutte le opzioni
/// disponibili, utile per decidere prima ancora di scegliere un valore. Se
/// [infoSoloOpzioneSelezionata] è true e un valore è già stato scelto, le
/// info mostrano solo quella singola opzione invece dell'intero elenco.
///
/// Se [onRimuovi] è fornito, il bottone "X" resta presente in layout (per
/// non far "saltare" la riga) ma è completamente invisibile finché non c'è
/// una selezione, così da non mostrare un'icona disabilitata/sbiadita per
/// un campo ancora vuoto.
class DropdownConDettagli extends StatelessWidget {
  final String label;
  final String? valoreSelezionato;
  final List<String> opzioni;
  final Map<String, String> descrizioni;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onRimuovi;
  final bool infoSoloOpzioneSelezionata;

  /// Testo secondario mostrato in fondo alla riga di ciascuna voce della
  /// tendina (es. "Costo: 2" per le Capacità Generiche). Compare solo
  /// nell'elenco aperto: a tendina chiusa resta il solo nome.
  final Map<String, String>? etichetteSecondarie;

  /// Contenuto alternativo per il Pulsante Info, costruito sulle opzioni
  /// effettivamente da mostrare. Serve alle Capacità, che hanno un
  /// formato proprio ([DettagliCapacita]) invece del semplice
  /// nome + descrizione di [DettagliOpzioni].
  final Widget Function(List<String> opzioni)? contenutoInfo;

  const DropdownConDettagli({
    super.key,
    required this.label,
    required this.valoreSelezionato,
    required this.opzioni,
    required this.descrizioni,
    required this.onChanged,
    this.onRimuovi,
    this.infoSoloOpzioneSelezionata = false,
    this.etichetteSecondarie,
    this.contenutoInfo,
  });

  @override
  Widget build(BuildContext context) {
    final opzioniInfo = infoSoloOpzioneSelezionata && valoreSelezionato != null
        ? [valoreSelezionato!]
        : opzioni;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: valoreSelezionato,
            // Senza isExpanded la tendina si dimensiona sulla voce più
            // lunga del catalogo e sfonda il campo su schermi stretti:
            // con questo resta larga quanto lo spazio disponibile e il
            // nome troppo lungo viene troncato con i puntini.
            isExpanded: true,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            items: opzioni
                .map(
                  (o) => DropdownMenuItem(
                    value: o,
                    child: _voceTendina(context, o),
                  ),
                )
                .toList(),
            // A tendina chiusa il campo mostra solo il nome: l'etichetta
            // secondaria (es. il costo) serve a scegliere, non a
            // rileggere ciò che è già stato scelto.
            selectedItemBuilder: etichetteSecondarie == null
                ? null
                : (_) => opzioni
                      .map(
                        (o) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(o, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
            onChanged: opzioni.isEmpty ? null : onChanged,
          ),
        ),
        InfoButton(
          titolo: label,
          enabled: opzioniInfo.isNotEmpty,
          contenutoBuilder: (_) =>
              contenutoInfo?.call(opzioniInfo) ??
              DettagliOpzioni(
                opzioni: opzioniInfo,
                descrizioni: descrizioni,
                etichetteSecondarie: etichetteSecondarie,
              ),
        ),
        if (onRimuovi != null)
          Visibility(
            visible: valoreSelezionato != null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Rimuovi selezione',
              onPressed: onRimuovi,
            ),
          ),
      ],
    );
  }

  /// Singola voce dell'elenco a tendina: il nome e, in fondo alla riga,
  /// l'eventuale etichetta secondaria (es. il costo in PE).
  Widget _voceTendina(BuildContext context, String opzione) {
    final secondaria = etichetteSecondarie?[opzione];
    if (secondaria == null) {
      return Text(opzione, overflow: TextOverflow.ellipsis);
    }

    return Row(
      children: [
        Expanded(child: Text(opzione, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 12),
        Text(
          secondaria,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Campo già compilato e non modificabile, con a fianco il Pulsante
/// Info: per le scelte che non c'è da fare perché arrivano con un'altra
/// (es. la Capacità di Background, una sola per ogni background).
///
/// Ha la forma di [DropdownConDettagli], così resta allineato alle
/// tendine vicine, ma al posto della freccia c'è un lucchetto.
class CampoFissoConDettagli extends StatelessWidget {
  final String label;
  final String valore;
  final WidgetBuilder contenutoInfo;

  const CampoFissoConDettagli({
    super.key,
    required this.label,
    required this.valore,
    required this.contenutoInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.lock_outline),
            ),
            // Lo stile del valore scelto nelle tendine: con quello di
            // base il campo veniva più basso e col testo più piccolo.
            child: Text(
              valore,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        InfoButton(titolo: label, contenutoBuilder: contenutoInfo),
      ],
    );
  }
}
