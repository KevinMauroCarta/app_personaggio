import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/sezione_collassabile.dart';
import 'criteri_catalogo.dart';
import 'dettagli_oggetto.dart';
import 'scheda_dati.dart';

/// Modale per scegliere una voce da un catalogo della Scheda: gli
/// Oggetti da mettere nello zaino, l'Arma o l'Armatura da indossare.
///
/// Una riga per voce: il nome a sinistra apre e chiude i suoi dati,
/// il pulsante a destra la sceglie e chiude la modale. I cataloghi sono
/// lunghi, quindi in cima c'è la sezione Ricerca:
/// - "Cerca per" sceglie il campo (Nome, Danno, Tipo... vedi
///   [CriterioCatalogo]) e sotto compare dove indicare il valore: un
///   campo di testo, o una tendina se il campo ha valori fissi;
/// - "Aggiungi filtro" salva la ricerca, e solo allora l'elenco cambia.
///
/// Non ci sono chip per categoria (Mischia/Distanza, Oggetti/Armi): lo
/// stesso lavoro lo fa un filtro sul Tipo.
///
/// I filtri salvati si sommano (Nome "Ascia" E Danno 7) e stanno sotto
/// la Ricerca, sempre in vista anche a sezione chiusa: ognuno è un chip
/// con la sua X per toglierlo.
///
/// Accanto al titolo della Lista c'è come ordinarla: il riquadro "Ordina
/// per" e la freccia per il verso. Finché non si sceglie, è per nome.
///
/// Si chiude restituendo il nome scelto, o null se si annulla.
class DialogSceltaCatalogo extends StatefulWidget {
  final String titolo;

  /// I nomi fra cui scegliere. L'ordine non conta: li ordina la modale.
  final List<String> opzioni;

  /// I campi per cui si può cercare e ordinare. Il primo è quello di
  /// partenza per entrambi, e deve essere ordinabile.
  final List<CriterioCatalogo> criteri;

  /// Cosa scrivere quando la ricerca non trova niente.
  final String testoVuoto;

  /// Il pulsante che sceglie la voce: "+" per aggiungere un oggetto,
  /// una spunta per indossare un'arma.
  final IconData iconaScelta;

  /// Il tooltip del pulsante, a partire dal nome della voce.
  final String Function(String nome) tooltipScelta;

  const DialogSceltaCatalogo({
    super.key,
    required this.titolo,
    required this.opzioni,
    required this.criteri,
    required this.testoVuoto,
    required this.iconaScelta,
    required this.tooltipScelta,
  });

  /// La modale di "Aggiungi oggetto": oggetti, armi e armature insieme.
  factory DialogSceltaCatalogo.oggetti({required List<String> opzioni}) {
    return DialogSceltaCatalogo(
      titolo: 'Aggiungi oggetto',
      opzioni: opzioni,
      criteri: criteriOggetti,
      testoVuoto: 'Nessun oggetto trovato.',
      iconaScelta: Icons.add_circle_outline,
      tooltipScelta: (nome) => 'Aggiungi $nome',
    );
  }

  @override
  State<DialogSceltaCatalogo> createState() => _DialogSceltaCatalogoState();
}

class _DialogSceltaCatalogoState extends State<DialogSceltaCatalogo> {
  final TextEditingController _ricerca = TextEditingController();

  late CriterioCatalogo _cercaPer = widget.criteri.first;

  /// Il campo per cui si ordina, o null finché non se ne sceglie uno: il
  /// riquadro mostra "Ordina per" e l'elenco è in ordine di nome.
  CriterioCatalogo? _ordinaPer;
  bool _crescente = true;

  /// Le ricerche salvate con "Aggiungi filtro": una voce resta
  /// nell'elenco solo se le soddisfa tutte.
  final List<FiltroCatalogo> _filtri = [];

  /// Il valore scelto nella tendina, per i campi a scelta.
  String? _valoreScelto;

  /// Cambia a ogni filtro aggiunto e a ogni cambio di campo: fa ripartire
  /// da vuota la tendina dei valori, che altrimenti terrebbe la scelta
  /// di prima.
  int _versioneValore = 0;

  @override
  void dispose() {
    _ricerca.dispose();
    super.dispose();
  }

  /// Il valore pronto da salvare come filtro, o null se non c'è niente
  /// (e il pulsante resta spento).
  String? get _valoreDaCercare {
    if (_cercaPer.aScelta) return _valoreScelto;
    final testo = _ricerca.text.trim();
    return testo.isEmpty ? null : testo;
  }

  /// Salva la ricerca scritta come filtro e svuota il campo per la
  /// prossima.
  ///
  /// Un filtro sullo stesso campo prende il posto di quello di prima:
  /// "Tipo: Mischia" e "Tipo: Distanza" insieme non darebbero mai
  /// niente, e chi sceglie un nuovo valore vuole cambiare quello vecchio.
  void _aggiungiFiltro() {
    final valore = _valoreDaCercare;
    if (valore == null) return;
    setState(() {
      _filtri
        ..removeWhere((f) => identical(f.criterio, _cercaPer))
        ..add(FiltroCatalogo(_cercaPer, valore));
      _svuotaValore();
    });
  }

  void _svuotaValore() {
    _ricerca.clear();
    _valoreScelto = null;
    _versioneValore++;
  }

  /// Le voci da mostrare, già ordinate.
  ///
  /// Quello che si sta scrivendo non conta: la ricerca parte solo
  /// quando diventa un filtro.
  ///
  /// Chi non ha il campo per cui si ordina (un oggetto generico,
  /// ordinando per Danno) va in fondo in ordine di nome, in qualunque
  /// verso: in cima coprirebbe proprio le voci che si stanno cercando.
  /// A parità di valore decide il nome, così l'ordine non cambia da
  /// un'apertura all'altra.
  List<String> get _risultati {
    final ordinaPer = _ordinaPer ?? criterioNome;
    final filtrate = widget.opzioni.where(
      (o) => _filtri.every((f) => f.corrisponde(o)),
    );

    final conValore = filtrate.where(ordinaPer.haValore).toList()
      ..sort((a, b) {
        final confronto = ordinaPer.confronta(a, b);
        if (confronto != 0) return _crescente ? confronto : -confronto;
        return confrontaNomi(a, b);
      });
    final senzaValore = filtrate.where((o) => !ordinaPer.haValore(o)).toList()
      ..sort(confrontaNomi);

    return [...conValore, ...senzaValore];
  }

  void _cambiaCercaPer(CriterioCatalogo criterio) {
    setState(() {
      _cercaPer = criterio;
      // Cambiando campo il valore riparte da vuoto: un nome non vale
      // come Danno, e la tendina del Tipo non ha i valori della Rarità.
      _svuotaValore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final risultati = _risultati;
    // Accanto al nome si scrive il valore per cui si ordina: ordinare
    // per Danno senza vedere il Danno non servirebbe a molto.
    final ordinaPer = _ordinaPer;
    final mostraValore =
        ordinaPer != null && !identical(ordinaPer, criterioNome);

    return AlertDialog(
      title: Text(widget.titolo),
      content: SizedBox(
        width: double.maxFinite,
        // Altezza fissa: la modale deve restare della stessa dimensione
        // mentre si filtra, altrimenti "salta" a ogni lettera digitata.
        // È una parte dello schermo e non un numero: con la Ricerca
        // aperta, su un telefono alto l'elenco ha così più righe.
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // La Ricerca si chiude per lasciare all'elenco tutta
            // l'altezza della modale, una volta impostati i filtri.
            //
            // Al massimo metà della modale, e se non ci sta scorre: su
            // un telefono basso, con la Ricerca aperta, l'elenco sotto
            // resterebbe altrimenti senza spazio.
            Flexible(
              child: SingleChildScrollView(
                child: SezioneCollassabile(
                  titolo: 'Ricerca',
                  stileTitolo: _stileSezione,
                  figli: [const SizedBox(height: 8), _buildRicerca()],
                ),
              ),
            ),
            // I filtri stanno fuori dalla Ricerca: si vedono anche a
            // sezione chiusa, e si tolgono senza doverla riaprire.
            if (_filtri.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildFiltriAttivi(),
            ],
            const Divider(height: 16),
            // La Lista non si chiude: senza elenco la modale non
            // servirebbe a niente. Accanto al titolo, come si ordina.
            Row(
              children: [
                const Text('Lista', style: _stileSezione),
                const SizedBox(width: 12),
                Expanded(child: _buildOrdinaPer()),
                IconButton(
                  icon: Icon(
                    _crescente ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  tooltip: _crescente ? 'Crescente' : 'Decrescente',
                  onPressed: () => setState(() => _crescente = !_crescente),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: risultati.isEmpty
                  ? Center(child: Text(widget.testoVuoto))
                  : ListView.separated(
                      itemCount: risultati.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, indice) => _RigaCatalogo(
                        nome: risultati[indice],
                        valore: mostraValore
                            ? ordinaPer.testoValore(risultati[indice])
                            : null,
                        icona: widget.iconaScelta,
                        tooltip: widget.tooltipScelta(risultati[indice]),
                        onScegli: () =>
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

  static const _stileSezione = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  /// Il contenuto della sezione Ricerca: "Cerca per", il valore da
  /// cercare e "Aggiungi filtro".
  Widget _buildRicerca() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _menuCriteri(
          etichetta: 'Cerca per',
          valore: _cercaPer,
          criteri: widget.criteri,
          onChanged: _cambiaCercaPer,
        ),
        const SizedBox(height: 8),
        _cercaPer.aScelta ? _buildTendinaValori() : _buildCampoTesto(),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _valoreDaCercare == null ? null : _aggiungiFiltro,
          icon: const Icon(Icons.filter_alt),
          label: const Text('Aggiungi filtro'),
        ),
      ],
    );
  }

  /// Il valore da cercare per un campo libero (Nome, Danno...). Invio
  /// vale come "Aggiungi filtro".
  Widget _buildCampoTesto() {
    return TextField(
      controller: _ricerca,
      autofocus: true,
      keyboardType: _cercaPer.numerico
          ? TextInputType.number
          : TextInputType.text,
      inputFormatters: _cercaPer.numerico
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Cerca per ${_cercaPer.etichetta}',
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
      // Solo per accendere o spegnere il pulsante: l'elenco non cambia
      // finché il testo non diventa un filtro.
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => _aggiungiFiltro(),
    );
  }

  /// Il valore da cercare per un campo a scelta (Tipo, Rarità...): una
  /// tendina con i valori che le voci del catalogo hanno davvero.
  Widget _buildTendinaValori() {
    return DropdownButtonFormField<String>(
      key: ValueKey('valore-$_versioneValore'),
      initialValue: _valoreScelto,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Cerca per ${_cercaPer.etichetta}',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final valore in _cercaPer.valoriPossibili(widget.opzioni))
          DropdownMenuItem(
            value: valore,
            child: Text(valore, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (valore) => setState(() => _valoreScelto = valore),
    );
  }

  /// I filtri salvati, uno per chip: la X ne toglie uno, "Rimuovi
  /// tutti" riparte dal catalogo intero.
  Widget _buildFiltriAttivi() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final filtro in _filtri)
          InputChip(
            label: Text(filtro.etichetta),
            deleteButtonTooltipMessage: 'Togli ${filtro.etichetta}',
            onDeleted: () => setState(() => _filtri.remove(filtro)),
          ),
        if (_filtri.length > 1)
          TextButton(
            onPressed: () => setState(_filtri.clear),
            child: const Text('Rimuovi tutti'),
          ),
      ],
    );
  }

  /// Il riquadro "Ordina per" accanto al titolo della Lista.
  ///
  /// Finché non si sceglie niente dice "Ordina per"; scelto un campo,
  /// mostra quello, tagliato con i puntini se non ci sta. Tratti e Tag
  /// non ci sono: sono elenchi, e non hanno un "prima" e un "dopo".
  Widget _buildOrdinaPer() {
    final criteri = widget.criteri.where((c) => c.ordinabile).toList();
    Widget testo(String t) =>
        Text(t, maxLines: 1, overflow: TextOverflow.ellipsis);

    return DropdownButtonFormField<CriterioCatalogo>(
      initialValue: _ordinaPer,
      isExpanded: true,
      isDense: true,
      hint: testo('Ordina per'),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      items: [
        for (final criterio in criteri)
          DropdownMenuItem(value: criterio, child: testo(criterio.etichetta)),
      ],
      selectedItemBuilder: (_) => [
        for (final criterio in criteri) testo(criterio.etichetta),
      ],
      onChanged: (c) => setState(() => _ordinaPer = c),
    );
  }

  Widget _menuCriteri({
    required String etichetta,
    required CriterioCatalogo valore,
    required List<CriterioCatalogo> criteri,
    required ValueChanged<CriterioCatalogo> onChanged,
  }) {
    return DropdownButtonFormField<CriterioCatalogo>(
      initialValue: valore,
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        labelText: etichetta,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
      ),
      items: [
        for (final criterio in criteri)
          DropdownMenuItem(
            value: criterio,
            child: Text(criterio.etichetta, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (c) {
        if (c != null) onChanged(c);
      },
    );
  }
}

/// Riga della modale: nome a sinistra (apre i dati), pulsante a destra
/// e, se si ordina per un campo diverso dal nome, il suo valore.
class _RigaCatalogo extends StatelessWidget {
  final String nome;
  final String? valore;
  final IconData icona;
  final String tooltip;
  final VoidCallback onScegli;

  const _RigaCatalogo({
    required this.nome,
    required this.valore,
    required this.icona,
    required this.tooltip,
    required this.onScegli,
  });

  @override
  Widget build(BuildContext context) {
    return SezioneCollassabile(
      titolo: nome,
      apertaIniziale: false,
      stileTitolo: const TextStyle(fontWeight: FontWeight.w600),
      azione: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Largo al massimo un terzo della riga: una Descrizione intera
          // spingerebbe fuori il nome.
          if (valore != null)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width / 3,
              ),
              child: Text(
                valore!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          IconButton(icon: Icon(icona), tooltip: tooltip, onPressed: onScegli),
        ],
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
