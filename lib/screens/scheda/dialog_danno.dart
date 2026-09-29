import 'package:flutter/material.dart';

import '../../enums/tipo_danno.dart';

/// Quello che si è segnato sulla modale delle Ferite: un colpo incassato
/// o una cura. Con [cura] a true, [tipo] non vuol dire niente - una cura
/// non è fisica né energetica.
typedef EsitoFerite = ({int quantita, TipoDanno tipo, bool cura});

/// Quello che si è segnato sulla modale dello Shock.
typedef EsitoShock = ({int quantita, bool cura});

/// Modale delle Ferite, divisa in due schede: "Danni" e "Cure".
///
/// In Danni il colpo si sceglie con una barra scorrevole invece che
/// scrivendolo: al tavolo si legge un numero sui dadi e lo si riporta, e
/// trascinare è più rapido che aprire la tastiera. Il tipo parte da
/// Fisico, il caso di gran lunga più comune, e sotto il conto è già
/// fatto - danno meno la Resilienza che gli si oppone - così si vede
/// prima di confermare se il colpo passa o si ferma sull'armatura.
///
/// In Cure c'è il solo valore: una cura non incontra Resilienza e non ha
/// un tipo, quindi non c'è altro da decidere.
class DialogDanno extends StatefulWidget {
  final int resilienzaFisica;
  final int resilienzaEnergetica;

  /// Ferite già prese e Ferite Massime: servono a dire, prima di
  /// confermare, quanto del colpo verrà segnato davvero e quanto si può
  /// curare.
  final int feriteAttuali;
  final int feriteMassime;

  /// Il massimo selezionabile sulla barra dei danni.
  final int dannoMassimo;

  const DialogDanno({
    super.key,
    required this.resilienzaFisica,
    required this.resilienzaEnergetica,
    required this.feriteAttuali,
    required this.feriteMassime,
    this.dannoMassimo = 30,
  });

  @override
  State<DialogDanno> createState() => _DialogDannoState();
}

class _DialogDannoState extends State<DialogDanno>
    with SingleTickerProviderStateMixin {
  late final TabController _schede = TabController(length: 2, vsync: this)
    // Il pulsante "Applica" cambia significato da una scheda all'altra:
    // deve ridisegnarsi quando si passa da Danni a Cure.
    ..addListener(() => setState(() {}));

  int _danno = 0;
  int _cura = 0;
  TipoDanno _tipo = TipoDanno.fisico;

  @override
  void dispose() {
    _schede.dispose();
    super.dispose();
  }

  bool get _inCure => _schede.index == 1;

  int get _resilienza => _tipo == TipoDanno.fisico
      ? widget.resilienzaFisica
      : widget.resilienzaEnergetica;

  /// Le Ferite che il colpo lascerebbe: un colpo che non supera la
  /// Resilienza non ne lascia nessuna.
  int get _ferite => (_danno - _resilienza).clamp(0, _danno);

  /// Quante se ne segnerebbero davvero: le Attuali non superano le
  /// Massime, e quello che avanza si perde.
  int get _segnate =>
      (widget.feriteMassime - widget.feriteAttuali).clamp(0, _ferite);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ferite'),
      content: SizedBox(
        width: double.maxFinite,
        height: 360,
        child: Column(
          children: [
            TabBar(
              controller: _schede,
              tabs: const [
                Tab(text: 'Danni'),
                Tab(text: 'Cure'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _schede,
                children: [_buildDanni(), _buildCure()],
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
        TextButton(
          onPressed: (_inCure ? _cura : _danno) == 0
              ? null
              : () => Navigator.of(context).pop((
                  quantita: _inCure ? _cura : _danno,
                  tipo: _tipo,
                  cura: _inCure,
                )),
          child: const Text('Applica'),
        ),
      ],
    );
  }

  Widget _buildDanni() {
    final colori = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$_danno',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Slider(
            value: _danno.toDouble(),
            max: widget.dannoMassimo.toDouble(),
            divisions: widget.dannoMassimo,
            label: '$_danno',
            onChanged: (valore) => setState(() => _danno = valore.round()),
          ),
          const SizedBox(height: 8),
          Center(
            child: SegmentedButton<TipoDanno>(
              // Senza la spunta sul segmento scelto: comparendo si
              // prende lo spazio dell'etichetta, e su un telefono
              // stretto "Energetico" ci finiva a capo per una lettera.
              // Quale dei due sia attivo si vede già dal colore.
              showSelectedIcon: false,
              segments: [
                for (final tipo in TipoDanno.values)
                  ButtonSegment(value: tipo, label: Text(tipo.label)),
              ],
              selected: {_tipo},
              onSelectionChanged: (scelta) =>
                  setState(() => _tipo = scelta.first),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Danno $_danno - Resilienza ${_tipo.labelFemminile} $_resilienza',
            style: TextStyle(color: colori.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            switch (_ferite) {
              0 => 'Nessuna ferita: il colpo non passa.',
              _ when _segnate == 0 =>
                'Ferite già al massimo '
                    '(${widget.feriteAttuali}/${widget.feriteMassime}): '
                    'il colpo non aggiunge niente.',
              _ when _segnate < _ferite =>
                'Ferite segnate: $_segnate di $_ferite, fino al massimo '
                    '(${widget.feriteMassime}). Le altre si perdono.',
              _ => 'Ferite segnate: $_ferite',
            },
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _segnate == 0 ? colori.onSurfaceVariant : colori.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCure() {
    if (widget.feriteAttuali == 0) {
      return const Center(child: Text('Nessuna ferita da curare.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('$_cura', style: Theme.of(context).textTheme.headlineMedium),
          // Non si cura più di quanto si è ferito: il massimo della
          // barra è quello che c'è da guarire.
          Slider(
            value: _cura.toDouble(),
            max: widget.feriteAttuali.toDouble(),
            divisions: widget.feriteAttuali,
            label: '$_cura',
            onChanged: (valore) => setState(() => _cura = valore.round()),
          ),
          const SizedBox(height: 8),
          Text(
            'Ferite: ${widget.feriteAttuali} -> ${widget.feriteAttuali - _cura}'
            ' su ${widget.feriteMassime}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Modale dello Shock, divisa come quella delle Ferite in "Danni" e
/// "Cure".
///
/// Qui non c'è tipo né Resilienza: lo Shock non lo ferma l'armatura,
/// quindi quello che si sceglie è quello che si segna. Quello che non ci
/// sta però non si perde: diventa danno diretto (vedi Scheda).
class DialogShock extends StatefulWidget {
  final int shockMassimo;
  final int shockAttuale;

  const DialogShock({
    super.key,
    required this.shockMassimo,
    required this.shockAttuale,
  });

  @override
  State<DialogShock> createState() => _DialogShockState();
}

class _DialogShockState extends State<DialogShock>
    with SingleTickerProviderStateMixin {
  late final TabController _schede = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));

  int _shock = 0;
  int _cura = 0;

  @override
  void dispose() {
    _schede.dispose();
    super.dispose();
  }

  bool get _inCure => _schede.index == 1;

  /// Quanto Shock non ci sta nella barra: diventerà danno diretto.
  int get _eccesso {
    final spazio = (widget.shockMassimo - widget.shockAttuale).clamp(
      0,
      widget.shockMassimo,
    );
    return _shock > spazio ? _shock - spazio : 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Shock'),
      content: SizedBox(
        width: double.maxFinite,
        height: 280,
        child: Column(
          children: [
            TabBar(
              controller: _schede,
              tabs: const [
                Tab(text: 'Danni'),
                Tab(text: 'Cure'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _schede,
                children: [_buildDanni(), _buildCure()],
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
        TextButton(
          onPressed: (_inCure ? _cura : _shock) == 0
              ? null
              : () => Navigator.of(context)
                    .pop((quantita: _inCure ? _cura : _shock, cura: _inCure)),
          child: const Text('Applica'),
        ),
      ],
    );
  }

  Widget _buildDanni() {
    // Almeno dieci tacche anche con uno Shock Massimo basso, così la
    // barra resta usabile.
    final massimo = widget.shockMassimo < 10 ? 10 : widget.shockMassimo;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('$_shock', style: Theme.of(context).textTheme.headlineMedium),
          Slider(
            value: _shock.toDouble(),
            max: massimo.toDouble(),
            divisions: massimo,
            label: '$_shock',
            onChanged: (valore) => setState(() => _shock = valore.round()),
          ),
          const SizedBox(height: 8),
          Text(
            _eccesso == 0
                ? 'Shock ${widget.shockAttuale + _shock} '
                      'su ${widget.shockMassimo}'
                : 'Shock al massimo: $_eccesso danni diretti, '
                      'non riducibili dalla Resilienza.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _eccesso == 0
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCure() {
    if (widget.shockAttuale == 0) {
      return const Center(child: Text('Nessuno Shock da recuperare.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('$_cura', style: Theme.of(context).textTheme.headlineMedium),
          Slider(
            value: _cura.toDouble(),
            max: widget.shockAttuale.toDouble(),
            divisions: widget.shockAttuale,
            label: '$_cura',
            onChanged: (valore) => setState(() => _cura = valore.round()),
          ),
          const SizedBox(height: 8),
          Text(
            'Shock: ${widget.shockAttuale} -> ${widget.shockAttuale - _cura}'
            ' su ${widget.shockMassimo}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
