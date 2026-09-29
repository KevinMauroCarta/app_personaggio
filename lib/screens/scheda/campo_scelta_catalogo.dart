import 'package:flutter/material.dart';

import '../creazione_pg/creazione_pg_widgets.dart' show InfoButton;
import 'dialog_scelta_catalogo.dart';

/// Campo di scelta di un'Arma o dell'Armatura nella pagina Equip.
///
/// Ha l'aspetto dei dropdown del resto dell'app (etichetta, bordo,
/// Pulsante Info e "X" per togliere la scelta), ma toccandolo si apre
/// [DialogSceltaCatalogo]: un elenco a tendina non si può filtrare, e
/// con il catalogo delle armi che cresce scorrerlo tutto per trovarne
/// una era diventato scomodo.
class CampoSceltaCatalogo extends StatelessWidget {
  final String label;
  final String? valoreSelezionato;

  /// La modale che si apre toccando il campo: restituisce il nome
  /// scelto, o null se si annulla.
  final DialogSceltaCatalogo Function() modale;

  /// I dati della voce scelta, per il Pulsante Info.
  final Widget Function(String nome) contenutoInfo;

  final ValueChanged<String> onChanged;
  final VoidCallback onRimuovi;

  const CampoSceltaCatalogo({
    super.key,
    required this.label,
    required this.valoreSelezionato,
    required this.modale,
    required this.contenutoInfo,
    required this.onChanged,
    required this.onRimuovi,
  });

  Future<void> _apri(BuildContext context) async {
    final scelto = await showDialog<String>(
      context: context,
      builder: (_) => modale(),
    );
    if (scelto != null) onChanged(scelto);
  }

  @override
  Widget build(BuildContext context) {
    final valore = valoreSelezionato;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _apri(context),
            child: InputDecorator(
              isEmpty: valore == null,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
              child: Text(valore ?? '', overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        // A campo vuoto le Info non hanno niente da mostrare: per
        // guardare il catalogo c'è la modale, che apre i dati di ogni voce.
        InfoButton(
          titolo: label,
          enabled: valore != null,
          contenutoBuilder: (_) => contenutoInfo(valore!),
        ),
        Visibility(
          visible: valore != null,
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
}
