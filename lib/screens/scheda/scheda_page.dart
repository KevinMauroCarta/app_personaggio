import 'package:flutter/material.dart';

import '../../data/lista_lesioni_memorabili.dart';
import '../../data/lista_lesioni_traumatiche.dart';
import '../../data/lista_mutazioni.dart';
import '../../enums/bersaglio.dart';
import '../../enums/abilita_arma.dart';
import '../../enums/grado_ferita.dart';
import '../../enums/scuola_psionica.dart';
import '../../enums/tipo_azione.dart';
import '../../enums/taglia.dart';
import '../../enums/tipo_capacita.dart';
import '../../enums/tipo_danno.dart';
import '../../models/caratteristica_personaggio.dart';
import '../../models/equipaggiamento.dart';
import '../../models/chip_neurale.dart';
import '../../models/ferite.dart';
import '../../models/impianti.dart';
import '../../models/protesi.dart';
import '../../enums/tipo_protesi.dart';
import '../../enums/parte_corpo.dart';
import '../../models/lesione_memorabile.dart';
import '../../models/lesione_traumatica.dart';
import '../../models/modificatore.dart';
import '../../models/mutazione.dart';
import '../../models/armi/arma_distanza.dart';
import '../../models/personaggio.dart';
import '../../models/scheda.dart';
import '../../models/tratto.dart';
import '../../services/effetti_personaggio.dart';
import '../../widgets/sezione_collassabile.dart';
import '../creazione_pg/creazione_pg_dati.dart' show legendaAsteriscoAbilita;
import '../creazione_pg/creazione_pg_widgets.dart';
import '../creazione_pg/dettagli_modelli.dart';
import 'barra_stato.dart';
import 'campo_scelta_catalogo.dart';
import 'criteri_catalogo.dart';
import 'dettagli_oggetto.dart';
import 'dialog_scelta_catalogo.dart';
import 'dialog_danno.dart';
import 'scheda_dati.dart';

/// APP/Pagina/Scheda
///
/// Visualizza la Scheda del personaggio su più pagine (le linguette di
/// [_pagine], navigabili anche con lo swipe):
/// - Info: Dati generali, Vari, Lesioni & Corruzione, Note. Da qui
///   si aggiornano i valori che cambiano durante il gioco: Ira, Riserva
///   Furtiva, Lesioni/Mutazioni/Corruzione.
/// - Abilità: Caratteristiche e Abilità (sola lettura: si cambiano in
///   Modifica e in Aumento)
/// - Equip: Armi e Armatura indossate. Si scelgono da un catalogo in
///   una modale con filtri che si sommano, ognuno su un campo a scelta
///   (nome, tipo, tratti, danno...), e si possono ripetere: due coltelli
///   sono due righe.
/// - Capacità: Talenti e Capacità. Ognuno si apre toccandone il nome,
///   mostrando descrizione, effetto, modificatori e tutto il resto.
/// - Poteri: i Poteri Psionici, che hanno una pagina loro perché si
///   consultano in mezzo a una scena e non si devono cercare in coda a
///   Talenti e Capacità.
/// - Stato: Difesa, Grinta, le barre di Ferite e Shock e il Grado
///   Ferita. È la pagina che si tiene aperta durante uno scontro.
/// - Punk (nome provvisorio): gli Impianti, cioè Chip Neurali e Protesi
///   (Sostitutivi ed Esoscheletri).
/// - Oggetti: Influenza, Ricchezza e quello che il personaggio si porta
///   dietro.
///
/// Equip, Punk e Oggetti stanno in fondo e vicini: sono le tre pagine
/// di quello che il personaggio ha addosso.
///
/// Le modifiche non hanno un pulsante "Salva": la [Scheda] aggiornata
/// viene restituita alla Home quando si torna indietro, ed è la Home a
/// persisterla.
///
/// Ogni pagina è organizzata in sezioni verticali invece di replicare il
/// layout grafico della scheda cartacea (stesso approccio "a sezioni"
/// già usato da Pagina3Riepilogo in Creazione, per coerenza visiva con
/// il resto dell'app).
///
/// NOTA: Velocità Bonus e Ferite Bonus non sono ancora modificabili da
/// nessuna schermata e restano ai valori di default.
/// Le pagine della Scheda, nell'ordine in cui compaiono fra le
/// linguette: [_BarraPagine] le intesta e il TabBarView le costruisce
/// nello stesso ordine.
const List<String> _pagine = [
  'Info',
  'Abilità',
  'Capacità',
  'Poteri',
  'Stato',
  'Equip',
  'Punk',
  'Oggetti',
];

class SchedaPage extends StatefulWidget {
  final Scheda scheda;

  /// Chiamata a ogni modifica con la Scheda aggiornata, perché venga
  /// salvata subito.
  final ValueChanged<Scheda> onModificata;

  const SchedaPage({
    super.key,
    required this.scheda,
    required this.onModificata,
  });

  @override
  State<SchedaPage> createState() => _SchedaPageState();
}

class _SchedaPageState extends State<SchedaPage> {
  late int _ira;
  late int _furtivitaPassiva;
  late int _corruzione;
  late List<LesioneTraumatica> _lesioniTraumatiche;
  late List<LesioneMemorabile> _lesioniMemorabili;
  late List<Mutazione> _mutazioni;

  late int _feriteAttuali;
  late int _shockAttuale;

  /// Da 0 a 3 (Modello/Ferite.gradoFerita). Oltre lo zero il personaggio
  /// guadagna la Condizione "Ferito" (Scheda.condizioni).
  late GradoFerita _gradoFerita;

  /// Armi scelte dal catalogo. Stesso pattern delle Capacità Generiche
  /// in Creazione: un campo libero in coda finché restano armi non
  /// scelte, "X" per togliere quella selezionata.
  late List<String?> _armiSelezionate;

  /// L'armatura indossata: una sola, quindi un dropdown singolo.
  late String? _armaturaSelezionata;

  /// Oggetti trasportati, uno per copia posseduta: lo stesso oggetto
  /// ripetuto due volte vale quantità 2 (vedi [_oggettiConQuantita]).
  late List<String> _oggetti;

  /// Gli Impianti installati (pagina "Punk"), nell'ordine in cui sono
  /// stati aggiunti. Lo stesso chip o la stessa protesi si può avere
  /// più volte: due braccia meccaniche sono due protesi.
  late List<ChipNeurale> _chipNeurali;
  late List<Protesi> _protesi;

  /// Le note scritte a mano dal giocatore, una per riga.
  late List<String> _note;

  /// La Ricchezza si muove di continuo durante il gioco, quindi si
  /// regola dalla Scheda (Modello/Equipaggiamento.ricchezza).
  late int _ricchezza;

  late final TextEditingController _furtivitaController;
  late final TextEditingController _notaController;

  @override
  void initState() {
    super.initState();
    final scheda = widget.scheda;
    _ira = scheda.iraAttuale;
    _furtivitaPassiva = scheda.furtivitaPassiva;
    _corruzione = scheda.personaggio.corruzione;
    _lesioniTraumatiche = List.of(scheda.personaggio.lesioniTraumatiche);
    _lesioniMemorabili = List.of(scheda.personaggio.lesioniMemorabili);
    _mutazioni = List.of(scheda.personaggio.mutazioni);
    _feriteAttuali = scheda.ferite.attuali;
    _shockAttuale = scheda.shockAttuale;
    _gradoFerita = scheda.ferite.gradoFerita;

    final armiPossedute = scheda.equipaggiamento.armi
        .map((a) => a.nome)
        .toList();
    _armiSelezionate = [...armiPossedute];
    if (_restanoArmi()) _armiSelezionate.add(null);
    _armaturaSelezionata = scheda.equipaggiamento.armatura?.nome;

    _oggetti = [...scheda.equipaggiamento.oggetti];
    _ricchezza = scheda.equipaggiamento.ricchezza;
    _chipNeurali = [...scheda.impianti.chipNeurali];
    _protesi = [...scheda.impianti.protesi];
    _note = [...scheda.note];

    _furtivitaController = TextEditingController(text: '$_furtivitaPassiva');
    _notaController = TextEditingController();
  }

  @override
  void dispose() {
    _furtivitaController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  /// Applica una modifica e la salva subito.
  ///
  /// Tutte le modifiche della pagina passano di qui - non si chiama mai
  /// setState direttamente - così nessuna può restare fuori dal
  /// salvataggio. Non si aspetta l'uscita dalla pagina perché l'app può
  /// essere chiusa (o la scheda ricaricata nel browser) mentre è ancora
  /// aperta, e quello che si segna durante il gioco andrebbe perso.
  void _modifica(VoidCallback cambiamento) {
    setState(cambiamento);
    widget.onModificata(_schedaCorrente);
  }

  /// La [Scheda] con lo stato corrente della pagina, restituita alla Home
  /// all'uscita.
  Scheda get _schedaCorrente => widget.scheda.copyWith(
    iraAttuale: _ira,
    furtivitaPassiva: _furtivitaPassiva,
    shockAttuale: _shockAttuale,
    ferite: Ferite(attuali: _feriteAttuali, gradoFerita: _gradoFerita),
    equipaggiamento: _equipaggiamentoCorrente,
    impianti: _impiantiCorrenti,
    personaggio: _personaggioCorrente,
    note: _note,
  );

  Equipaggiamento get _equipaggiamentoCorrente {
    return Equipaggiamento(
      armi: armiDaNomi(_armiSelezionate.whereType<String>().toList()),
      armatura: armaturaDaNome(_armaturaSelezionata),
      oggetti: _oggetti,
      ricchezza: _ricchezza,
    );
  }

  Impianti get _impiantiCorrenti =>
      Impianti(chipNeurali: _chipNeurali, protesi: _protesi);

  Personaggio get _personaggioCorrente {
    final p = widget.scheda.personaggio;

    // Il Valore Bonus va ricalcolato qui e non solo in
    // Creazione/Aumento: Mutazioni e Impianti si prendono da questa
    // pagina, e portano Modificatori. Senza ricalcolo un chip o una
    // mutazione comparirebbero in elenco senza alzare niente.
    return conEffettiRicalcolati(
      Personaggio(
        nome: p.nome,
        anni: p.anni,
        genere: p.genere,
        razza: p.razza,
        sistemaDiOrigine: p.sistemaDiOrigine,
        pianetaDiOrigine: p.pianetaDiOrigine,
        background: p.background,
        caratteristiche: p.caratteristiche,
        abilita: p.abilita,
        talenti: p.talenti,
        capacita: p.capacita,
        lesioniMemorabili: _lesioniMemorabili,
        lesioniTraumatiche: _lesioniTraumatiche,
        mutazioni: _mutazioni,
        corruzione: _corruzione,
        poteriPsionici: p.poteriPsionici,
        tag: p.tag,
        pxDisponibili: p.pxDisponibili,
      ),
      impianti: _impiantiCorrenti,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheda = _schedaCorrente;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_schedaCorrente);
      },
      child: DefaultTabController(
        length: _pagine.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Scheda - ${scheda.personaggio.nome}'),
            bottom: const _BarraPagine(_pagine),
          ),
          // I tasti di sistema in fondo al telefono stanno sopra
          // all'app: senza questo margine l'ultima riga di ogni
          // pagina finisce sotto di loro.
          body: SafeArea(
            top: false,
            child: TabBarView(
              // Nello stesso ordine di [_pagine].
              children: [
                _buildPaginaInfo(scheda),
                _buildPaginaAbilita(scheda),
                _buildPaginaCapacita(scheda.personaggio),
                _buildPaginaPoteri(scheda.personaggio),
                _buildPaginaStato(scheda),
                _buildPaginaEquip(scheda),
                _buildPaginaPunk(),
                _buildPaginaOggetti(scheda),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pagina Stato: quella che si tiene aperta durante uno scontro.
  ///
  /// In alto la Difesa e la barra delle Ferite, che si riempie di rosso
  /// scuro mentre si incassa; sotto le due Resilienze, il Grado Ferita
  /// e la barra dello Shock, uguale ma in blu. Toccando una barra si
  /// segna il colpo ricevuto.
  Widget _buildPaginaStato(Scheda scheda) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // In cima e affiancate: sono i due valori che si tirano più
          // spesso quando le cose si mettono male.
          Row(
            children: [
              Expanded(
                child: _valoreInRiquadro('Fermezza', '${scheda.fermezza}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _valoreInRiquadro(
                  'Risolutezza',
                  '${scheda.risolutezza}',
                ),
              ),
              // Le formule stanno qui: è la pagina dove si usano.
              const InfoButton(
                titolo: 'Come si calcolano',
                tooltip: 'Come si calcolano questi valori',
                contenutoBuilder: _formuleSopravvivenza,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _valoreInRiquadro('Difesa', '${scheda.difesaBase}'),
              const SizedBox(width: 12),
              Expanded(
                child: BarraStato(
                  etichetta: 'Ferite',
                  attuali: _feriteAttuali,
                  massimi: scheda.feriteMassime,
                  coloreLibero: Colors.red,
                  colorePreso: Colors.red.shade900,
                  onTap: () => _segnaDanno(scheda),
                  // Le Resilienze stanno sotto la barra perché è lì che
                  // servono: sono i due numeri che si sottraggono al
                  // colpo prima di segnarlo.
                  sottotitolo:
                      'Resilienza Fisica ${scheda.resilienzaFisica} · '
                      'Energetica ${scheda.resilienzaEnergetica}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _rigaContatore(
            etichetta: 'Grado Ferita',
            valore: _gradoFerita.index,
            // A grado zero non c'è niente da dire; sopra lo zero il
            // sottotitolo mostra la Condizione che ne deriva.
            sottotitolo: _gradoFerita == GradoFerita.zero
                ? null
                : 'Condizione: ${scheda.condizioni.first.etichetta}',
            onDiminuisci: _gradoFerita == GradoFerita.zero
                ? null
                : () => _cambiaGradoFerita(-1),
            onAumenta: _gradoFerita == GradoFerita.values.last
                ? null
                : () => _cambiaGradoFerita(1),
          ),
          const SizedBox(height: 16),
          // Grinta sta alla barra dello Shock come la Difesa sta a
          // quella delle Ferite: il valore che si oppone a quel tipo di
          // colpo, a fianco della barra che lo misura.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _valoreInRiquadro('Grinta', '${scheda.grinta}'),
              const SizedBox(width: 12),
              Expanded(
                child: BarraStato(
                  etichetta: 'Shock',
                  attuali: _shockAttuale,
                  massimi: scheda.shockMassimo,
                  coloreLibero: Colors.blue,
                  colorePreso: Colors.blue.shade900,
                  onTap: () => _segnaShock(scheda),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _avvisa(String messaggio) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(messaggio)));
  }

  /// Segna [quante] Ferite fermandosi alle Massime, e restituisce
  /// quante ne sono state segnate davvero.
  ///
  /// Le Ferite Attuali non superano mai le Massime: quello che
  /// avanzerebbe si perde. Con 3 ferite su 4, un colpo da 5 ne segna una
  /// sola e le altre quattro non lasciano traccia.
  int _segnaFerite(int quante, int massime) {
    final int segnate = (massime - _feriteAttuali).clamp(0, quante);
    if (segnate == 0) return 0;
    _modifica(() => _feriteAttuali += segnate);
    return segnate;
  }

  /// Un valore secco dentro un riquadro colorato: si legge di sfuggita
  /// senza doverlo cercare fra le righe.
  Widget _valoreInRiquadro(String etichetta, String valore) {
    final colori = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etichetta, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          height: 32,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colori.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            valore,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colori.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  /// Chiede il colpo ricevuto - o la cura - e aggiorna le Ferite.
  ///
  /// Un colpo lascia le Ferite che supera la Resilienza; una cura le
  /// toglie e basta, senza incontrare Resilienza.
  Future<void> _segnaDanno(Scheda scheda) async {
    final colpo = await showDialog<EsitoFerite>(
      context: context,
      builder: (_) => DialogDanno(
        resilienzaFisica: scheda.resilienzaFisica,
        resilienzaEnergetica: scheda.resilienzaEnergetica,
        feriteAttuali: _feriteAttuali,
        feriteMassime: scheda.feriteMassime,
      ),
    );
    if (colpo == null || !mounted) return;

    if (colpo.cura) {
      _modifica(
        () => _feriteAttuali = (_feriteAttuali - colpo.quantita).clamp(
          0,
          _feriteAttuali,
        ),
      );
      return;
    }

    final resilienza = colpo.tipo == TipoDanno.fisico
        ? scheda.resilienzaFisica
        : scheda.resilienzaEnergetica;
    final int ferite = (colpo.quantita - resilienza).clamp(0, colpo.quantita);
    if (ferite == 0) {
      _avvisa('Il colpo non supera la Resilienza: nessuna ferita.');
      return;
    }

    final segnate = _segnaFerite(ferite, scheda.feriteMassime);
    if (segnate == ferite) return;

    _avvisa(
      segnate == 0
          ? 'Ferite già al massimo: il colpo non aggiunge niente. Alza il '
                'Grado Ferita per ripartire da zero.'
          : 'Ferite al massimo: segnate $segnate di $ferite, le altre si '
                'perdono.',
    );
  }

  /// Chiede lo Shock subito - o il recupero - e lo segna.
  ///
  /// Lo Shock si ferma al massimo, e quello che non ci sta non si perde:
  /// diventa danno diretto, cioè Ferite che la Resilienza non ferma. Un
  /// recupero invece toglie Shock e basta.
  Future<void> _segnaShock(Scheda scheda) async {
    final esito = await showDialog<EsitoShock>(
      context: context,
      builder: (_) => DialogShock(
        shockMassimo: scheda.shockMassimo,
        shockAttuale: _shockAttuale,
      ),
    );
    if (esito == null || !mounted) return;

    if (esito.cura) {
      _modifica(
        () => _shockAttuale = (_shockAttuale - esito.quantita).clamp(
          0,
          _shockAttuale,
        ),
      );
      return;
    }

    final shock = esito.quantita;
    final spazio = (scheda.shockMassimo - _shockAttuale).clamp(
      0,
      scheda.shockMassimo,
    );
    final eccesso = shock > spazio ? shock - spazio : 0;

    _modifica(
      () =>
          _shockAttuale = (_shockAttuale + shock).clamp(0, scheda.shockMassimo),
    );
    if (eccesso == 0) return;

    final segnate = _segnaFerite(eccesso, scheda.feriteMassime);
    _avvisa(
      segnate == eccesso
          ? 'Shock al massimo: $eccesso danni diretti.'
          : 'Shock al massimo: $eccesso danni diretti, ma le Ferite si '
                'fermano al massimo: segnate $segnate.',
    );
  }

  /// Pagina Info: Dati generali, Vari, Lesioni & Corruzione, Note. È la
  /// pagina modificabile.
  Widget _buildPaginaInfo(Scheda scheda) {
    final personaggio = scheda.personaggio;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Dati generali', [
            _riga('Nome', personaggio.nome),
            _riga('Specie', personaggio.razza.nome),
            _riga('Background', personaggio.background.nome),
            _riga(
              'Origine',
              '${personaggio.pianetaDiOrigine.nome} '
                  '(${personaggio.sistemaDiOrigine.nome})',
            ),
            _riga('Taglia', scheda.taglia.label),
            _riga(
              'Velocità',
              '${scheda.velocitaTotale} (6 + ${scheda.velocitaBonus})',
            ),
            _riga('PX Attuali', '${scheda.peAttuali}'),
            _riga('Tag', _tag(scheda).isEmpty ? '-' : _tag(scheda).join(', ')),
          ]),
          const SizedBox(height: 16),
          _buildSezione(
            'Condizioni',
            _buildCondizioni(scheda),
            sottotitolo:
                'I malus e i bonus che il personaggio si porta dietro '
                'adesso. Si ricavano da com\'è messo - il Grado Ferita, '
                'per esempio - e cambiano da sé.',
          ),
          const SizedBox(height: 16),
          _buildSezione('Vari', [
            _riga('Percezione Passiva', '${scheda.percezionePassiva}'),
            _rigaContatore(
              etichetta: 'Ira',
              valore: _ira,
              onDiminuisci: _ira > 0 ? () => _modifica(() => _ira--) : null,
              onAumenta: () => _modifica(() => _ira++),
              onInfo: _mostraInfoIra,
            ),
            _rigaCampoNumerico(
              etichetta: 'Riserva Furtiva',
              controller: _furtivitaController,
              onCambiato: (valore) =>
                  _modifica(() => _furtivitaPassiva = valore),
              onDiminuisci: () => _impostaFurtivita(_furtivitaPassiva - 1),
              onAumenta: () => _impostaFurtivita(_furtivitaPassiva + 1),
            ),
            // Il campo qui sopra è la parte scritta a mano: se dei
            // Modificatori la cambiano, il valore che conta è il totale.
            if (scheda.bonusDaModificatori(Bersaglio.riservaFurtiva) != 0)
              _riga('Riserva Furtiva totale', '${scheda.riservaFurtivaTotale}'),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Lesioni & Corruzione', [
            _rigaElenco<LesioneTraumatica>(
              etichetta: 'Lesioni Traumatiche',
              elementi: _lesioniTraumatiche,
              nome: (l) => l.nome,
              onAggiungi: () => _aggiungiDaCatalogo<LesioneTraumatica>(
                titolo: 'Aggiungi Lesione Traumatica',
                catalogo: listaLesioniTraumatiche,
                giaPresenti: _lesioniTraumatiche,
                nome: (l) => l.nome,
                descrizione: (l) => l.effetto,
                onScelto: (l) => _modifica(() => _lesioniTraumatiche.add(l)),
              ),
              onRimuovi: (indice) =>
                  _modifica(() => _lesioniTraumatiche.removeAt(indice)),
              dettagli: (l) => _dettagliVoce(l.descrizione, l.effetto),
            ),
            _rigaElenco<LesioneMemorabile>(
              etichetta: 'Lesioni Memorabili',
              elementi: _lesioniMemorabili,
              nome: (l) => l.nome,
              onAggiungi: () => _aggiungiDaCatalogo<LesioneMemorabile>(
                titolo: 'Aggiungi Lesione Memorabile',
                catalogo: listaLesioniMemorabili,
                giaPresenti: _lesioniMemorabili,
                nome: (l) => l.nome,
                descrizione: (l) => l.effetto,
                onScelto: (l) => _modifica(() => _lesioniMemorabili.add(l)),
              ),
              onRimuovi: (indice) =>
                  _modifica(() => _lesioniMemorabili.removeAt(indice)),
              dettagli: (l) => _dettagliVoce(l.descrizione, l.effetto),
            ),
            _rigaElenco<Mutazione>(
              etichetta: 'Mutazioni',
              elementi: _mutazioni,
              nome: (m) => m.nome,
              onAggiungi: () => _aggiungiDaCatalogo<Mutazione>(
                titolo: 'Aggiungi Mutazione',
                catalogo: listaMutazioni,
                giaPresenti: _mutazioni,
                nome: (m) => m.nome,
                descrizione: (m) => m.effetto,
                onScelto: (m) => _modifica(() => _mutazioni.add(m)),
              ),
              onRimuovi: (indice) =>
                  _modifica(() => _mutazioni.removeAt(indice)),
              dettagli: (m) => _dettagliVoce(
                m.descrizione,
                m.effetto,
                modificatori: m.modificatori,
              ),
            ),
            // Due valori distinti: i Punti si segnano a mano, il Grado
            // viene da sé e per questo non ha bottoni.
            _rigaContatore(
              etichetta: 'Punti Corruzione',
              valore: _corruzione,
              onDiminuisci: _corruzione > 0
                  ? () => _abbassaCorruzione(scheda)
                  : null,
              onAumenta: _corruzione < Scheda.corruzioneMassima
                  ? () => _modifica(() => _corruzione++)
                  : null,
            ),
            _riga('Grado Corruzione', '${scheda.gradoCorruzione}'),
          ]),
          const SizedBox(height: 16),
          _buildSezione(
            'Note',
            [
              if (_note.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Nessuna nota.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                for (final voce in _note.asMap().entries)
                  _rigaNota(indice: voce.key, testo: voce.value),
            ],
            azione: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Aggiungi nota',
              onPressed: _aggiungiNota,
            ),
          ),
        ],
      ),
    );
  }

  void _impostaFurtivita(int nuovoValore) {
    final valore = nuovoValore < 0 ? 0 : nuovoValore;
    _modifica(() {
      _furtivitaPassiva = valore;
      _furtivitaController.text = '$valore';
    });
  }

  /// Campi di scelta delle Armi: uno per arma, con un campo libero in
  /// coda. Toccandoli si apre la modale con la ricerca.
  ///
  /// Ogni campo offre sempre il catalogo intero, anche le armi già
  /// scelte: due coltelli o due pistole sono cose normali da avere
  /// addosso, e prima l'elenco le toglieva rendendolo impossibile.
  List<Widget> _buildCampiArmi() {
    return List.generate(_armiSelezionate.length, (indice) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CampoSceltaCatalogo(
          label: 'Arma ${indice + 1}',
          valoreSelezionato: _armiSelezionate[indice],
          modale: () => DialogSceltaCatalogo(
            titolo: 'Scegli arma',
            opzioni: armiOptions,
            criteri: criteriArmi,
            testoVuoto: 'Nessuna arma trovata.',
            iconaScelta: Icons.check_circle_outline,
            tooltipScelta: (nome) => 'Scegli $nome',
          ),
          contenutoInfo: (nome) => DettagliArma(armi: armiDaNomi([nome])),
          onChanged: (valore) => _onArmaSelezionata(indice, valore),
          onRimuovi: () => _rimuoviArma(indice),
        ),
      );
    });
  }

  void _onArmaSelezionata(int indice, String? valore) {
    _modifica(() {
      _armiSelezionate[indice] = valore;
      final isUltimo = indice == _armiSelezionate.length - 1;
      if (isUltimo && valore != null && _restanoArmi()) {
        _armiSelezionate.add(null);
      }
    });
  }

  void _rimuoviArma(int indice) {
    _modifica(() {
      _armiSelezionate.removeAt(indice);
      if (_armiSelezionate.isEmpty) {
        _armiSelezionate.add(null);
        return;
      }
      if (_restanoArmi() && !_armiSelezionate.contains(null)) {
        _armiSelezionate.add(null);
      }
    });
  }

  /// Si può sempre aggiungere un'arma, anche una già presa: l'unico caso
  /// in cui non resta niente da scegliere è il catalogo vuoto.
  bool _restanoArmi() => armiOptions.isNotEmpty;

  /// Pagina Oggetti: Influenza e Ricchezza in alto, poi il pulsante per
  /// aggiungere e l'elenco di quello che si ha addosso.
  Widget _buildPaginaOggetti(Scheda scheda) {
    final quantita = _oggettiConQuantita;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sulla stessa riga: sono due numeri soli e messi in colonna
          // sprecherebbero mezza pagina.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _valoreInColonna(
                  'Influenza',
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 4),
                    child: Text('${scheda.influenza}'),
                  ),
                ),
              ),
              Expanded(
                child: _valoreInColonna(
                  'Ricchezza',
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: 'Togli ricchezza',
                        onPressed: _ricchezza > 0
                            ? () => _modifica(() => _ricchezza--)
                            : null,
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '$_ricchezza',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Aggiungi ricchezza',
                        onPressed: () => _modifica(() => _ricchezza++),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _mostraModaleAggiungiOggetto,
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi oggetto'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Il Mio Inventario',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (quantita.isEmpty)
            Text(
              'Nessun oggetto.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final voce in quantita.entries)
              _rigaOggetto(nome: voce.key, quantita: voce.value),
        ],
      ),
    );
  }

  /// Gli oggetti posseduti con la loro quantità, in ordine alfabetico.
  ///
  /// La quantità non è un campo: è quante volte lo stesso oggetto
  /// compare in Modello/Equipaggiamento.oggetti. Due razioni sono due
  /// voci nella lista, e questo evita di cambiare il modello e di dover
  /// convertire le schede già salvate.
  ///
  /// L'ordine è alfabetico e non quello in cui sono stati presi: con una
  /// borsa piena, ritrovare un oggetto conta più che ricordare quando lo
  /// si è raccolto.
  Map<String, int> get _oggettiConQuantita {
    final quantita = <String, int>{};
    for (final oggetto in _oggetti) {
      quantita[oggetto] = (quantita[oggetto] ?? 0) + 1;
    }

    final nomi = quantita.keys.toList()..sort(confrontaNomi);
    return {for (final nome in nomi) nome: quantita[nome]!};
  }

  /// Etichetta sopra e valore sotto: serve a mettere più valori su una
  /// riga sola, dove l'etichetta a sinistra ruberebbe troppo spazio.
  Widget _valoreInColonna(String etichetta, Widget valore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etichetta, style: const TextStyle(fontWeight: FontWeight.w600)),
        valore,
      ],
    );
  }

  /// Riga di un oggetto posseduto: `nome - quantità +`.
  ///
  /// Il nome è toccabile e apre i dati dell'oggetto, ed è colorato per
  /// farlo capire senza doverci provare.
  ///
  /// Un impianto (Chip Neurale o Protesi) ha in più il pulsante per
  /// installarlo: passa alla pagina Punk, e da lì dà i suoi effetti.
  /// È spento quando il suo Carico non entra in quello rimasto, e il
  /// tooltip dice perché.
  Widget _rigaOggetto({required String nome, required int quantita}) {
    final nonInstallabile = eImpianto(nome)
        ? _motivoNonInstallabile(_schedaCorrente, nome)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => mostraDettagliOggetto(context, nome),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  nome,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          if (eImpianto(nome))
            IconButton(
              icon: const Icon(Icons.memory),
              tooltip: nonInstallabile ?? 'Installa $nome',
              onPressed: nonInstallabile != null
                  ? null
                  : () => _installaDaOggetti(nome),
            ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: 'Togli un $nome',
            onPressed: () => _togliUnOggetto(nome),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantita',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Aggiungi un $nome',
            onPressed: () => _modifica(() => _oggetti.add(nome)),
          ),
        ],
      ),
    );
  }

  Future<void> _mostraModaleAggiungiOggetto() async {
    final scelto = await showDialog<String>(
      context: context,
      builder: (_) => DialogSceltaCatalogo.oggetti(opzioni: oggettiOptions),
    );
    if (scelto == null || !mounted) return;
    _modifica(() => _oggetti.add(scelto));
  }

  /// Toglie una sola copia dell'oggetto: quando finiscono, la riga
  /// sparisce da sé perché il nome non compare più nell'elenco.
  void _togliUnOggetto(String nome) {
    _modifica(() => _oggetti.remove(nome));
  }

  /// Pagina Punk (nome provvisorio): gli Impianti installati.
  ///
  /// Due sezioni, Chip Neurali e Protesi, ognuna con il suo Carico (quanto
  /// è occupato sul limite: Volontà per i chip, Resistenza per le protesi)
  /// e il suo pulsante per installare dal catalogo con la stessa modale di
  /// ricerca di Equip e Oggetti. Le Protesi sono divise nei loro due tipi:
  /// i Sostitutivi, che rimpiazzano una parte mancante, e gli
  /// Esoscheletri, che ne potenziano una sana.
  ///
  /// Quello che sta in questa pagina è installato e dà i suoi effetti.
  /// Disinstallato, un impianto finisce fra gli Oggetti, e da lì si può
  /// installare di nuovo.
  Widget _buildPaginaPunk() {
    final scheda = _schedaCorrente;
    final sostitutivi = _protesi
        .where((p) => p.tipo == TipoProtesi.sostitutivo)
        .toList();
    final esoscheletri = _protesi
        .where((p) => p.tipo == TipoProtesi.esoscheletro)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Chip Neurali', [
            _rigaCarico(
              usato: scheda.impianti.caricoChip,
              limite: scheda.limiteCaricoChip,
              caratteristica: 'Volontà',
            ),
            _pulsanteAggiungi('Aggiungi chip neurale', _aggiungiChipNeurale),
            if (_chipNeurali.isEmpty)
              _nessuno('Nessun chip neurale.')
            else
              for (final chip in _chipNeurali)
                _rigaImpianto(
                  nome: chip.nome,
                  dettaglio: _dettaglioImpianto(
                    'Chip Neurale',
                    chip.carico,
                    chip.modificatori,
                    chip.capacita?.nome,
                  ),
                  onDisinstalla: () => _modifica(() {
                    _chipNeurali.remove(chip);
                    _oggetti.add(chip.nome);
                  }),
                ),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Protesi', [
            _rigaCarico(
              usato: scheda.impianti.caricoProtesi,
              limite: scheda.limiteCaricoProtesi,
              caratteristica: 'Resistenza',
            ),
            _pulsanteAggiungi('Aggiungi protesi', _aggiungiProtesi),
            _sottoTitolo('Sostitutivi'),
            if (sostitutivi.isEmpty)
              _nessuno('Nessun sostitutivo.')
            else
              for (final p in sostitutivi) _rigaProtesi(p),
            _sottoTitolo('Esoscheletri'),
            if (esoscheletri.isEmpty)
              _nessuno('Nessun esoscheletro.')
            else
              for (final p in esoscheletri) _rigaProtesi(p),
          ]),
        ],
      ),
    );
  }

  /// "Carico  x/y", in cima alla sezione: quanto Carico è installato sul
  /// massimo che la [caratteristica] permette.
  ///
  /// Il limite può scendere sotto il Carico già installato - per esempio
  /// abbassando la caratteristica in Modifica - e gli impianti restano: in
  /// quel caso il numero diventa rosso e una riga spiega che non se ne
  /// installano altri finché non si torna sotto.
  Widget _rigaCarico({
    required int usato,
    required int limite,
    required String caratteristica,
  }) {
    final colori = Theme.of(context).colorScheme;
    final oltre = usato > limite;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Carico (limite: $caratteristica)')),
              Text(
                '$usato/$limite',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: oltre ? colori.error : colori.primary,
                ),
              ),
            ],
          ),
          if (oltre)
            Text(
              'Oltre il limite: disinstalla un impianto per installarne '
              'altri.',
              style: TextStyle(fontSize: 12, color: colori.error),
            ),
        ],
      ),
    );
  }

  Widget _rigaProtesi(Protesi protesi) {
    return _rigaImpianto(
      nome: protesi.nome,
      dettaglio: _dettaglioImpianto(
        protesi.parte.label,
        protesi.carico,
        protesi.modificatori,
        protesi.capacita?.nome,
      ),
      onDisinstalla: () => _modifica(() {
        _protesi.remove(protesi);
        _oggetti.add(protesi.nome);
      }),
    );
  }

  /// La riga sotto il nome di un impianto: cosa è (Chip Neurale, o la
  /// parte del corpo della protesi), il suo Carico, i suoi Modificatori e
  /// la Capacità da Impianto che concede, se ne ha.
  String _dettaglioImpianto(
    String cosa,
    int carico,
    List<Modificatore> modificatori,
    String? capacita,
  ) => [
    cosa,
    'Carico $carico',
    ...modificatori.map((m) => m.testo),
    if (capacita != null) 'Capacità: $capacita',
  ].join(' · ');

  /// Perché l'impianto [nome] non si può installare su [scheda], o null
  /// se si può: il suo Carico non entra in quello rimasto libero.
  String? _motivoNonInstallabile(Scheda scheda, String nome) {
    final chip = chipNeuraleDaNome(nome);
    if (chip != null) {
      return scheda.entraChip(chip)
          ? null
          : _nonEntra(
              chip.carico,
              scheda.limiteCaricoChip - scheda.impianti.caricoChip,
            );
    }
    final protesi = protesiDaNome(nome);
    if (protesi != null) {
      return scheda.entraProtesi(protesi)
          ? null
          : _nonEntra(
              protesi.carico,
              scheda.limiteCaricoProtesi - scheda.impianti.caricoProtesi,
            );
    }
    return null;
  }

  /// "Carico 3, liberi 1": il motivo per cui un impianto non entra.
  String _nonEntra(int carico, int liberi) =>
      'Carico $carico, liberi ${liberi < 0 ? 0 : liberi}';

  /// Installa l'impianto [nome] preso dagli Oggetti: ne toglie una copia
  /// dall'inventario e lo mette fra gli impianti installati. Non fa niente
  /// se il suo Carico non entra.
  void _installaDaOggetti(String nome) {
    final chip = chipNeuraleDaNome(nome);
    final protesi = protesiDaNome(nome);
    if (chip == null && protesi == null) return;
    if (_motivoNonInstallabile(_schedaCorrente, nome) != null) return;
    _modifica(() {
      _oggetti.remove(nome);
      if (chip != null) _chipNeurali.add(chip);
      if (protesi != null) _protesi.add(protesi);
    });
  }

  /// Riga di un impianto: nome e dettaglio a sinistra, "Disinstalla" a
  /// destra.
  ///
  /// Il nome è toccabile e apre tutti i dati dell'impianto, ed è colorato
  /// per farlo capire, come le righe della pagina Oggetti.
  Widget _rigaImpianto({
    required String nome,
    required String dettaglio,
    required VoidCallback onDisinstalla,
  }) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => mostraDettagliOggetto(context, nome),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    dettaglio,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Disinstallare non butta via: l'impianto torna fra gli Oggetti.
        IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Disinstalla $nome',
          onPressed: onDisinstalla,
        ),
      ],
    );
  }

  Widget _pulsanteAggiungi(String testo, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add),
          label: Text(testo),
        ),
      ),
    );
  }

  Widget _nessuno(String testo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        testo,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// I chip che non entrano nel Carico rimasto compaiono lo stesso, ma
  /// spenti e con il motivo: così si vede cosa servirebbe per averli.
  Future<void> _aggiungiChipNeurale() async {
    final scheda = _schedaCorrente;
    final scelto = await showDialog<String>(
      context: context,
      builder: (_) => DialogSceltaCatalogo(
        titolo: 'Aggiungi chip neurale',
        opzioni: chipNeuraliOptions,
        criteri: criteriChipNeurali,
        testoVuoto: 'Nessun chip trovato.',
        iconaScelta: Icons.add_circle_outline,
        tooltipScelta: (nome) => 'Aggiungi $nome',
        motivoBloccato: (nome) => _motivoNonInstallabile(scheda, nome),
      ),
    );
    final chip = scelto == null ? null : chipNeuraleDaNome(scelto);
    if (chip == null || !mounted) return;
    _modifica(() => _chipNeurali.add(chip));
  }

  /// Vedi [_aggiungiChipNeurale]: lo stesso, sul Carico delle protesi.
  Future<void> _aggiungiProtesi() async {
    final scheda = _schedaCorrente;
    final scelta = await showDialog<String>(
      context: context,
      builder: (_) => DialogSceltaCatalogo(
        titolo: 'Aggiungi protesi',
        opzioni: protesiOptions,
        criteri: criteriProtesi,
        testoVuoto: 'Nessuna protesi trovata.',
        iconaScelta: Icons.add_circle_outline,
        tooltipScelta: (nome) => 'Aggiungi $nome',
        motivoBloccato: (nome) => _motivoNonInstallabile(scheda, nome),
      ),
    );
    final protesi = scelta == null ? null : protesiDaNome(scelta);
    if (protesi == null || !mounted) return;
    _modifica(() => _protesi.add(protesi));
  }

  /// Sposta il Grado Ferita di un passo, restando fra 0 e 3.
  ///
  /// Salendo di grado le Ferite Attuali tornano a zero: il personaggio
  /// ha finito la scorta, ne incassa le conseguenze e riparte da capo.
  /// Scendendo di grado le Ferite non si toccano, perché non è un
  /// annullamento ma una guarigione.
  ///
  /// La Condizione "Ferito" non va aggiornata a mano: è calcolata dal
  /// grado (Scheda.condizioni), quindi compare, cambia numero e sparisce
  /// da sé.
  void _cambiaGradoFerita(int passo) {
    final nuovo = (_gradoFerita.index + passo).clamp(
      0,
      GradoFerita.values.length - 1,
    );
    _modifica(() {
      _gradoFerita = GradoFerita.values[nuovo];
      if (passo > 0) _feriteAttuali = 0;
    });
  }

  /// Toglie un Punto Corruzione, chiedendo conferma solo quando così
  /// facendo si scenderebbe di Grado.
  ///
  /// Un Grado di Corruzione si prende e non si restituisce, quindi
  /// perderlo è l'eccezione che vale la pena far confermare. Togliere
  /// un punto che il Grado non lo tocca - da 7 a 6, per dire - resta
  /// una correzione qualsiasi e non chiede niente.
  ///
  /// La Condizione "Corrotto" non va aggiornata a mano: come "Ferito"
  /// è calcolata dal grado (Scheda.condizioni).
  Future<void> _abbassaCorruzione(Scheda scheda) async {
    final gradoDopo = (_corruzione - 1) ~/ Scheda.puntiPerGradoCorruzione;
    if (gradoDopo < scheda.gradoCorruzione) {
      final conferma = await _chiediConferma(
        titolo: 'Scendere di Grado di Corruzione?',
        domanda:
            'Togliendo questo punto il Grado di Corruzione passa da '
            '${scheda.gradoCorruzione} a $gradoDopo, e un Grado non si dovrebbe '
            'perdere. Vuoi farlo lo stesso?',
        azione: 'Togli',
      );
      if (!conferma || !mounted) return;
    }
    _modifica(() => _corruzione--);
  }

  /// Domanda sì/no al centro dello schermo. Torna false anche quando
  /// la modale viene chiusa di lato, che vale come ripensamento.
  Future<bool> _chiediConferma({
    required String titolo,
    required String domanda,
    required String azione,
  }) async {
    final risposta = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titolo),
        content: Text(domanda),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(azione),
          ),
        ],
      ),
    );
    return risposta ?? false;
  }

  /// Le Condizioni attive, una per riga, con l'effetto sotto al nome
  /// quando il regolamento lo definisce.
  List<Widget> _buildCondizioni(Scheda scheda) {
    final condizioni = scheda.condizioni;
    if (condizioni.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Nessuna condizione attiva.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ];
    }

    return [
      for (final condizione in condizioni)
        _riga(
          condizione.etichetta,
          condizione.effetto.isEmpty ? '-' : condizione.effetto,
        ),
    ];
  }

  /// Una nota: il testo a sinistra e la "X" per toglierla.
  ///
  /// Il testo non è ancora modificabile una volta scritto - per
  /// correggerlo si toglie la nota e la si riscrive - ma la riga è già
  /// una riga sua, pronta a diventare un campo.
  Widget _rigaNota({required int indice, required String testo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(testo),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Rimuovi nota',
            onPressed: () => _modifica(() => _note.removeAt(indice)),
          ),
        ],
      ),
    );
  }

  /// Chiede il testo della nota e la aggiunge in fondo all'elenco.
  ///
  /// Il controller è quello della pagina e non uno creato al volo: la
  /// modale resta viva ancora un istante mentre si chiude, e liberarlo
  /// subito dopo il dialog lo farebbe usare da distrutto.
  Future<void> _aggiungiNota() async {
    final controller = _notaController..clear();

    final testo = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuova nota'),
        content: TextField(
          controller: controller,
          autofocus: true,
          // Le note sono frasi, non parole: il campo cresce fino a
          // cinque righe invece di far scorrere il testo di lato.
          minLines: 1,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nota',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );

    // Una nota vuota non è una nota: si annulla da sola.
    if (testo == null || testo.isEmpty || !mounted) return;
    _modifica(() => _note.add(testo));
  }

  void _mostraInfoIra() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ira'),
        content: const Text(
          'Descrizione degli Usi dell\'Ira da inserire, in attesa di '
          'Regolamento/Ira.',
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

  /// Mostra le voci di [catalogo] non ancora presenti in [giaPresenti] e
  /// richiama [onScelto] con quella selezionata.
  Future<void> _aggiungiDaCatalogo<T>({
    required String titolo,
    required List<T> catalogo,
    required List<T> giaPresenti,
    required String Function(T) nome,
    required String Function(T) descrizione,
    required void Function(T) onScelto,
  }) async {
    final nomiPresenti = giaPresenti.map(nome).toSet();
    final disponibili = catalogo
        .where((e) => !nomiPresenti.contains(nome(e)))
        .toList();

    final scelto = await showDialog<T>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titolo),
        content: SizedBox(
          width: double.maxFinite,
          child: disponibili.isEmpty
              ? const Text('Nessuna voce disponibile da aggiungere.')
              : ListView(
                  shrinkWrap: true,
                  children: disponibili
                      .map(
                        (e) => ListTile(
                          title: Text(nome(e)),
                          subtitle: Text(descrizione(e)),
                          onTap: () => Navigator.of(dialogContext).pop(e),
                        ),
                      )
                      .toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
        ],
      ),
    );

    if (scelto != null) onScelto(scelto);
  }

  /// Pagina Abilità: Caratteristiche e Abilità, in tabella.
  Widget _buildPaginaAbilita(Scheda scheda) {
    final personaggio = scheda.personaggio;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Caratteristiche', [
            _buildTabellaCaratteristiche(personaggio),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Abilità', [
            _buildAbilitaPerCaratteristica(personaggio),
          ], sottotitolo: legendaAsteriscoAbilita),
        ],
      ),
    );
  }

  /// Pagina Equip: l'Equipaggiamento indossato, cioè Armi e Armatura.
  ///
  /// La sezione Sopravvivenza non c'è più: tutti i suoi valori sono
  /// finiti nella pagina Stato, dove si consultano mentre si combatte
  /// invece di restare da scorrere in mezzo all'equipaggiamento.
  Widget _buildPaginaEquip(Scheda scheda) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Equipaggiamento - Armi', [
            ..._buildCampiArmi(),
            const SizedBox(height: 8),
            if (scheda.equipaggiamento.armi.isEmpty)
              _riga('Armi', '-')
            else ...[
              _tabella(
                // Niente colonna "Tipo": mischia o distanza si vede
                // già dalla Gittata, e su un telefono ogni colonna in
                // meno è spazio guadagnato per quelle che servono.
                intestazioni: const [
                  'Arma',
                  'Abilità',
                  'Danno',
                  'DE',
                  'VP',
                  'Tipo Danno',
                  'Gittata',
                  'Raffica',
                  'Tratti',
                  'Tag',
                ],
                righe: [
                  for (final arma in scheda.equipaggiamento.armi)
                    [
                      arma.nome,
                      // Sigla e Valore Totale dell'Abilità ("MP 5"): il
                      // numero è la Riserva di Dadi con cui si attacca,
                      // ed è quello che serve avere sott'occhio.
                      '${arma.abilitaAssociata.sigla} '
                          '${scheda.riservaDiDadi(arma)}',
                      '${arma.danno}',
                      '${arma.dadiExtra}',
                      '${arma.valorePenetrazione}',
                      arma.tipoDanno.label,
                      arma.etichettaGittata,
                      // La Raffica ce l'hanno solo le armi a distanza.
                      arma is ArmaDistanza ? (arma.raffica ? 'Sì' : 'No') : '-',
                      _elencoTratti(arma.tratti),
                      _elencoTag(arma.tag),
                    ],
                ],
              ),
              ..._dettagliTratti(
                scheda.equipaggiamento.armi.expand((a) => a.tratti),
              ),
            ],
          ]),
          const SizedBox(height: 16),
          _buildSezione('Equipaggiamento - Armatura', [
            CampoSceltaCatalogo(
              label: 'Armatura indossata',
              valoreSelezionato: _armaturaSelezionata,
              modale: () => DialogSceltaCatalogo(
                titolo: 'Scegli armatura',
                opzioni: armatureOptions,
                criteri: criteriArmature,
                testoVuoto: 'Nessuna armatura trovata.',
                iconaScelta: Icons.check_circle_outline,
                tooltipScelta: (nome) => 'Scegli $nome',
              ),
              contenutoInfo: (nome) =>
                  DettagliArmatura(armature: armatureDaNomi([nome])),
              onChanged: (valore) =>
                  _modifica(() => _armaturaSelezionata = valore),
              onRimuovi: () => _modifica(() => _armaturaSelezionata = null),
            ),
            const SizedBox(height: 8),
            if (scheda.equipaggiamento.armatura == null)
              _riga('Armatura', '-')
            else ...[
              _tabella(
                intestazioni: const [
                  'Armatura',
                  'PA',
                  'PA Energia',
                  'Tratti',
                  'Tag',
                ],
                righe: [
                  [
                    scheda.equipaggiamento.armatura!.nome,
                    '${scheda.equipaggiamento.armatura!.pa}',
                    '${scheda.equipaggiamento.armatura!.paEnergia}',
                    _elencoTratti(scheda.equipaggiamento.armatura!.tratti),
                    _elencoTag(scheda.equipaggiamento.armatura!.tag),
                  ],
                ],
              ),
              ..._dettagliTratti(scheda.equipaggiamento.armatura!.tratti),
            ],
          ]),
          // Oggetti, Influenza e Ricchezza hanno una pagina tutta loro.
        ],
      ),
    );
  }

  /// Pagina Capacità: Talenti e Capacità. Sono elencati per nome e
  /// uno - Poteri Psionici. Talenti e Capacità sono elencati per nome e
  /// si espandono a richiesta (vedi [_voceEspandibile]).
  Widget _buildPaginaCapacita(Personaggio personaggio) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Talenti', [
            if (personaggio.talenti.isEmpty)
              _riga('Talenti', '-')
            else
              ...personaggio.talenti.map(
                (t) => _voceEspandibile(t.nome, [
                  _riga('Descrizione', t.descrizione),
                  if (t.effetto.isNotEmpty) _riga('Effetto', t.effetto),
                  if (t.tag.isNotEmpty) _riga('Tag', t.tag),
                ]),
              ),
          ]),
          const SizedBox(height: 16),
          _buildSezione('Capacità', [
            if (personaggio.capacita.isEmpty &&
                _impiantiCorrenti.capacita.isEmpty)
              _riga('Capacità', '-')
            else
              ...personaggio.capacita.map(
                (c) => _voceEspandibile(c.nome, [
                  _riga('Tipo', c.tipo.label),
                  _riga('Descrizione', c.descrizione),
                  _riga('Effetto', c.effetto),
                  for (final m in c.modificatori)
                    _riga('Modificatore', m.testo),
                  _riga('Costo', '${c.costo} PE'),
                  if (c.tag.isNotEmpty) _riga('Tag', c.tag.join(', ')),
                ]),
              ),
            ..._capacitaDaImpianto(),
          ]),
        ],
      ),
    );
  }

  /// Le Capacità da Impianto, in coda alle Capacità: le danno gli
  /// impianti installati, e ognuna dice quale. Non stanno fra le Capacità
  /// del Personaggio perché non sono sue ma dell'impianto: disinstallato
  /// quello, spariscono anche da qui.
  List<Widget> _capacitaDaImpianto() {
    final concesse = _impiantiCorrenti.capacita;
    if (concesse.isEmpty) return const [];

    // Un Set: due braccia uguali concedono la capacità, ma il nome si
    // scrive una volta.
    String daChi(String capacita) => {
      for (final c in _chipNeurali)
        if (c.capacita?.nome == capacita) c.nome,
      for (final p in _protesi)
        if (p.capacita?.nome == capacita) p.nome,
    }.join(', ');

    return [
      _sottoTitolo('Da Impianto'),
      for (final c in concesse)
        _voceEspandibile(c.nome, [
          _riga('Tipo', c.tipo.label),
          _riga('Concessa da', daChi(c.nome)),
          _riga('Descrizione', c.descrizione),
          _riga('Effetto', c.effetto),
          for (final m in c.modificatori) _riga('Modificatore', m.testo),
          if (c.tag.isNotEmpty) _riga('Tag', c.tag.join(', ')),
        ]),
    ];
  }

  /// Pagina Poteri: i Poteri Psionici del personaggio, uno per voce.
  ///
  /// Stanno su una pagina loro e non più in coda alle Capacità perché sono
  /// roba che si consulta in mezzo a una scena: ogni potere ha CD,
  /// attivazione, durata e gittata, e cercarli sotto a Talenti e
  /// Capacità voleva dire scorrere tutta la pagina ogni volta.
  Widget _buildPaginaPoteri(Personaggio personaggio) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSezione('Poteri Psionici', [
            if (personaggio.poteriPsionici.isEmpty)
              _riga('Poteri Psionici', '-')
            else
              ...personaggio.poteriPsionici.map(
                (p) => _voceEspandibile(p.nome, [
                  _riga('Scuola', p.scuola.label),
                  _riga('CD', '${p.cd}'),
                  _riga('Attivazione', p.attivazione.label),
                  _riga('Durata', p.durata.etichetta),
                  _riga('Gittata', '${p.gittata}'),
                  _riga('Bersagli', p.multiBersaglio ? 'Multipli' : 'Uno'),
                  _riga('Descrizione', p.descrizione),
                  _riga('Effetto', p.effetto),
                  if (p.potenziamento1 != null)
                    _riga('Potenziamento 1', p.potenziamento1!.nome),
                  if (p.potenziamento2 != null)
                    _riga('Potenziamento 2', p.potenziamento2!.nome),
                ]),
              ),
          ]),
        ],
      ),
    );
  }

  /// Righe della sezione Caratteristiche, con le colonne larghe quanto
  /// serve al loro contenuto.
  Widget _buildTabellaCaratteristiche(Personaggio personaggio) {
    const intestazioni = ['Caratteristica', 'Totale', 'Base', 'Bonus'];
    final righe = [
      for (final c in personaggio.caratteristiche)
        [
          c.caratteristica.nome,
          '${c.valoreTotale}',
          '${c.valoreBase}',
          '${c.valoreBonus}',
        ],
    ];
    final larghezze = _larghezzeColonne(
      intestazioni: intestazioni,
      righe: righe,
      perParola: const {0},
    );

    return _TabellaScorrevole(
      larghezzaContenuto: larghezze.fold(0, (somma, l) => somma + l),
      contenuto: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rigaTabella(
            intestazioni.first,
            intestazioni.sublist(1),
            intestazione: true,
            larghezzaEtichetta: larghezze.first,
            larghezzeCelle: larghezze.sublist(1),
          ),
          for (final riga in righe)
            _rigaTabella(
              riga.first,
              riga.sublist(1),
              larghezzaEtichetta: larghezze.first,
              larghezzeCelle: larghezze.sublist(1),
            ),
        ],
      ),
    );
  }

  /// Righe della sezione Abilità, raggruppate per Caratteristica
  /// associata: un sotto-titolo con il nome della Caratteristica seguito
  /// dalle sue abilità. Le Caratteristiche senza abilità vengono saltate.
  ///
  /// Il Valore Totale di ogni abilità richiede il Valore Totale della
  /// Caratteristica associata (AbilitaPersonaggio.valoreTotale non lo
  /// memorizza): qui è già a disposizione, essendo quella del gruppo.
  Widget _buildAbilitaPerCaratteristica(Personaggio personaggio) {
    const intestazioni = ['Abilità', 'Totale', 'Base', 'Car', 'Bonus'];

    // Prima i dati, poi la misura, poi il disegno: le larghezze devono
    // valere per tutte le righe, e per saperle bisogna averle viste
    // tutte. Le righe sono indentate di 12, che vanno aggiunti alla
    // colonna dei nomi perché il nome più lungo ci stia lo stesso.
    final gruppi = <CaratteristicaPersonaggio, List<List<String>>>{};
    for (final caratteristica in personaggio.caratteristiche) {
      final abilitaDelGruppo = personaggio.abilita.where(
        (a) =>
            a.abilita.caratteristica.nome == caratteristica.caratteristica.nome,
      );
      if (abilitaDelGruppo.isEmpty) continue;

      final valoreCaratteristica = caratteristica.valoreTotale;
      gruppi[caratteristica] = [
        for (final a in abilitaDelGruppo)
          [
            a.abilita.addestramento ? '${a.abilita.nome}*' : a.abilita.nome,
            '${a.valoreTotale(valoreCaratteristica)}',
            '${a.valoreBase}',
            '$valoreCaratteristica',
            '${a.valoreBonus}',
          ],
      ];
    }

    final larghezze = _larghezzeColonne(
      intestazioni: intestazioni,
      righe: gruppi.values.expand((righe) => righe).toList(),
      perParola: const {0},
    );
    larghezze[0] += 12;

    return _TabellaScorrevole(
      larghezzaContenuto: larghezze.fold(0, (somma, l) => somma + l),
      contenuto: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rigaTabella(
            intestazioni.first,
            intestazioni.sublist(1),
            intestazione: true,
            larghezzaEtichetta: larghezze.first,
            larghezzeCelle: larghezze.sublist(1),
          ),
          for (final gruppo in gruppi.entries) ...[
            _sottoTitolo(gruppo.key.caratteristica.nome),
            for (final riga in gruppo.value)
              _rigaTabella(
                riga.first,
                riga.sublist(1),
                indentata: true,
                larghezzaEtichetta: larghezze.first,
                larghezzeCelle: larghezze.sublist(1),
              ),
          ],
        ],
      ),
    );
  }

  /// Tutti i Tag del personaggio: quelli portati dalle Capacità
  /// possedute (Modello/Personaggio.tag, ricalcolati a ogni salvataggio)
  /// più le eventuali Keyword proprie della Scheda, senza ripetizioni.
  /// I Tag arrivano da Lista/Tag e hanno un nome; le Keyword sono invece
  /// testo libero della Scheda. Qui servono solo i nomi, per scriverli
  /// tutti su una riga.
  List<String> _tag(Scheda scheda) {
    final tag = <String>[...scheda.personaggio.tag];
    for (final k in scheda.keyword) {
      if (!tag.contains(k)) tag.add(k);
    }
    return tag;
  }

  /// I Tratti come compaiono nella colonna "Tratti" della tabella: solo
  /// i nomi, perché descrizione ed effetto stanno sotto la tabella (vedi
  /// [_dettagliTratti]).
  String _elencoTratti(List<Tratto> tratti) =>
      tratti.isEmpty ? '-' : tratti.map((t) => t.nome).join(', ');

  /// I Tag come compaiono nella colonna "Tag" della tabella: solo i nomi.
  String _elencoTag(List<String> tag) => tag.isEmpty ? '-' : tag.join(', ');

  /// Descrizione ed effetto dei Tratti citati nella tabella. Ora che il
  /// Tratto è un modello unico per armi e armature (Modello/Tratto), lo
  /// stesso tratto può comparire su più armi: qui viene spiegato una
  /// volta sola.
  List<Widget> _dettagliTratti(Iterable<Tratto> tratti) {
    final unici = <String, Tratto>{};
    for (final t in tratti) {
      unici[t.nome] = t;
    }
    if (unici.isEmpty) return const [];
    return [
      _sottoTitolo('Tratti'),
      ...unici.values.map(
        (t) => _voceEspandibile(t.nome, [
          _riga('Descrizione', t.descrizione),
          _riga('Effetto', t.effetto),
        ]),
      ),
    ];
  }

  /// Voce di un elenco di dettaglio (un Talento, una Capacità): mostra
  /// solo il nome finché non viene toccata, e allora si apre rivelando
  /// tutto ciò che la riguarda. Parte chiusa proprio perché l'elenco
  /// resti leggibile a colpo d'occhio.
  Widget _voceEspandibile(String nome, List<Widget> dettagli) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SezioneCollassabile(
        titolo: nome,
        apertaIniziale: false,
        stileTitolo: const TextStyle(fontWeight: FontWeight.w600),
        figli: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: dettagli,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sottoTitolo(String testo) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(testo, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// [azione] finisce a fianco del titolo, fuori dall'area che apre e
  /// chiude la sezione: serve al Pulsante Info di Sopravvivenza.
  Widget _buildSezione(
    String titolo,
    List<Widget> righe, {
    Widget? azione,
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
          divisore: true,
          azione: azione,
          figli: righe,
        ),
      ),
    );
  }

  Widget _riga(String etichetta, String valore, {bool indentata = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: indentata ? 12 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              etichetta,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(valore)),
        ],
      ),
    );
  }

  /// La larghezza che serve a ogni colonna per contenere il testo più
  /// lungo che ci finisce dentro, intestazione compresa.
  ///
  /// Le colonne in [perParola] vengono misurate sulla parola più lunga
  /// invece che sull'intera stringa: è quello che serve alla colonna dei
  /// nomi, dove "Mischia Pesante" può andare a capo fra le due parole,
  /// ma "Sopravvivenza*" non deve spezzarsi.
  List<double> _larghezzeColonne({
    required List<String> intestazioni,
    required List<List<String>> righe,
    Set<int> perParola = const {},
    // Poco più di uno spazio fra una colonna e l'altra: su un telefono
    // da 361 punti ogni margine sprecato è una colonna che non ci sta.
    double margine = 10,
  }) {
    // Lo stile va preso dal tema e non da DefaultTextStyle.of(context):
    // qui sopra c'è solo il fallback di WidgetsApp, che è da 48 punti e
    // darebbe colonne larghe il triplo. Dentro la Card il testo viene
    // invece disegnato con bodyMedium.
    final stileBase =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
    final stileIntestazione = stileBase.merge(
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    );
    final stileEtichetta = stileBase.merge(
      const TextStyle(fontWeight: FontWeight.w600),
    );

    double misura(String testo, TextStyle stile) {
      final painter = TextPainter(
        text: TextSpan(text: testo, style: stile),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width;
    }

    double misuraCella(String testo, int colonna, TextStyle stile) {
      if (!perParola.contains(colonna)) return misura(testo, stile);
      // Solo la parola più lunga: il resto andrà a capo da solo.
      return testo
          .split(' ')
          .map((parola) => misura(parola, stile))
          .fold<double>(0, (massimo, l) => l > massimo ? l : massimo);
    }

    return [
      for (var colonna = 0; colonna < intestazioni.length; colonna++)
        margine +
            [
              misuraCella(intestazioni[colonna], colonna, stileIntestazione),
              for (final riga in righe)
                misuraCella(
                  riga[colonna],
                  colonna,
                  colonna == 0 ? stileEtichetta : stileBase,
                ),
            ].fold<double>(0, (massimo, l) => l > massimo ? l : massimo),
    ];
  }

  /// Riga di una tabella (Caratteristiche/Abilità): etichetta a sinistra
  /// e celle numeriche a larghezza fissa, così intestazione e dati
  /// restano incolonnati. La prima cella è il Valore Totale, in
  /// grassetto, seguito dai valori che lo compongono.
  Widget _rigaTabella(
    String etichetta,
    List<String> celle, {
    bool intestazione = false,
    bool indentata = false,
    double? larghezzaEtichetta,
    List<double>? larghezzeCelle,
  }) {
    const stileIntestazione = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    final stileEtichetta = intestazione
        ? stileIntestazione
        : const TextStyle(fontWeight: FontWeight.w600);

    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: indentata ? 12 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Con una larghezza misurata sul nome più lungo, un nome di
          // una parola sola non si spezza mai e quelli di più parole
          // vanno a capo fra le parole. Senza, la colonna si prende lo
          // spazio che avanza come faceva prima.
          if (larghezzaEtichetta == null)
            Expanded(child: Text(etichetta, style: stileEtichetta))
          else
            SizedBox(
              width: larghezzaEtichetta - (indentata ? 12 : 0),
              child: Text(etichetta, style: stileEtichetta),
            ),
          ...celle.asMap().entries.map(
            (e) => SizedBox(
              width: larghezzeCelle?[e.key] ?? 52,
              child: Text(
                e.value,
                textAlign: TextAlign.center,
                style: intestazione
                    ? stileIntestazione
                    : (e.key == 0
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tabella a più colonne, come quella delle Abilità ma con
  /// un'intestazione che nomina ogni campo e larghezze decise dal
  /// chiamante: Gittata e Tratti sono testi, non numeri, e in 52 punti
  /// non ci starebbero. Per lo stesso motivo la tabella scorre in
  /// orizzontale invece di stringere le colonne.
  Widget _tabella({
    required List<String> intestazioni,
    required List<List<String>> righe,
  }) {
    const stileIntestazione = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    // Ogni colonna è larga quanto il suo contenuto più lungo,
    // intestazione compresa: niente più "Raffic/a" spezzato a metà né
    // colonne di numeri larghe il doppio del necessario.
    final larghezze = _larghezzeColonne(
      intestazioni: intestazioni,
      righe: righe,
    );

    Widget costruisciRiga(List<String> celle, {bool intestazione = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < celle.length; i++)
              SizedBox(
                width: larghezze[i],
                child: Text(
                  celle[i],
                  // La prima colonna è il nome della riga: resta a
                  // sinistra come nelle tabelle di Caratteristiche e
                  // Abilità, le altre si incolonnano al centro.
                  textAlign: i == 0 ? TextAlign.left : TextAlign.center,
                  style: intestazione
                      ? stileIntestazione
                      : (i == 0
                            ? const TextStyle(fontWeight: FontWeight.w600)
                            : null),
                ),
              ),
          ],
        ),
      );
    }

    final larghezzaTotale = larghezze.fold<double>(0, (somma, l) => somma + l);

    return _TabellaScorrevole(
      larghezzaContenuto: larghezzaTotale,
      contenuto: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          costruisciRiga(intestazioni, intestazione: true),
          // Dentro uno scroll orizzontale la larghezza non è vincolata,
          // quindi il divisore deve dichiarare la sua.
          SizedBox(width: larghezzaTotale, child: const Divider(height: 1)),
          ...righe.map((r) => costruisciRiga(r)),
        ],
      ),
    );
  }

  /// Riga con valore numerico e bottoni "-"/"+", più un Pulsante Info
  /// opzionale. [onDiminuisci] a null blocca il "-" (es. valore a 0).
  Widget _rigaContatore({
    required String etichetta,
    required int valore,
    // Entrambi a null quando il valore è a un estremo: il bottone resta
    // in riga ma spento, così la riga non cambia forma.
    required VoidCallback? onDiminuisci,
    required VoidCallback? onAumenta,
    String? sottotitolo,
    VoidCallback? onInfo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etichetta,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (sottotitolo != null)
                  Text(sottotitolo, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          if (onInfo != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Mostra dettagli',
              onPressed: onInfo,
            ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onDiminuisci,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$valore',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onAumenta,
          ),
        ],
      ),
    );
  }

  /// Riga con campo numerico a compilazione libera e, se forniti,
  /// bottoni "-"/"+" per variare il valore di 1.
  Widget _rigaCampoNumerico({
    required String etichetta,
    required TextEditingController controller,
    required ValueChanged<int> onCambiato,
    VoidCallback? onDiminuisci,
    VoidCallback? onAumenta,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etichetta,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (onDiminuisci != null)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onDiminuisci,
            ),
          SizedBox(
            width: 64,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (testo) => onCambiato(int.tryParse(testo) ?? 0),
            ),
          ),
          if (onAumenta != null)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: onAumenta,
            ),
        ],
      ),
    );
  }

  /// Contenuto del Pulsante Info di una Lesione o di una Mutazione:
  /// cosa è, cosa comporta e - per le Mutazioni, le uniche ad averlo -
  /// i Modificatori che entrano davvero nei valori della scheda.
  Widget _dettagliVoce(
    String descrizione,
    String effetto, {
    List<Modificatore> modificatori = const [],
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _riga('Descrizione', descrizione),
        _riga('Effetto', effetto),
        for (final m in modificatori) _riga('Modificatore', m.testo),
      ],
    );
  }

  /// Riga "elenco": etichetta con bottone "+" per aggiungere una voce dal
  /// catalogo, seguita da una riga per ciascuna voce presente con il
  /// bottone "X" per rimuovere quella specifica voce.
  Widget _rigaElenco<T>({
    required String etichetta,
    required List<T> elementi,
    required String Function(T) nome,
    required VoidCallback onAggiungi,
    required void Function(int indice) onRimuovi,
    Widget Function(T)? dettagli,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  etichetta,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Aggiungi',
                onPressed: onAggiungi,
              ),
            ],
          ),
          if (elementi.isEmpty)
            const Padding(padding: EdgeInsets.only(left: 8), child: Text('-'))
          else
            ...elementi.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(nome(e.value))),
                    // Il nome da solo non dice cosa comporta la lesione o
                    // la mutazione: descrizione ed effetto sono già nei
                    // dati, qui si rendono leggibili.
                    if (dettagli != null)
                      InfoButton(
                        titolo: nome(e.value),
                        contenutoBuilder: (_) => dettagli(e.value),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Rimuovi',
                      onPressed: () => onRimuovi(e.key),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Una tabella più larga dello schermo, che quindi si trascina di lato.
///
/// Senza segnali, una tabella tagliata sul bordo sembra semplicemente una
/// tabella con meno colonne: qui il blocco scorrevole è riquadrato, ha una
/// barra di scorrimento sempre visibile e, sopra, la scritta che dice di
/// trascinare. I tre segnali compaiono solo quando servono davvero, cioè
/// quando il contenuto non ci sta: se la tabella entra tutta - schermo
/// largo, o tabella corta come quella dell'Armatura - resta pulita.
/// La barra delle linguette in cima alla Scheda.
///
/// Con sette pagine, su un telefono stretto, le linguette non ci stanno
/// tutte: la barra scorre, ma appena aperta la scheda sembra averne
/// quattro, perché le altre restano fuori dal bordo senza che niente lo
/// dica. Quando è così, di fianco compare una freccia: sta lì solo per
/// dire che di là ce n'è dell'altro.
class _BarraPagine extends StatelessWidget implements PreferredSizeWidget {
  final List<String> pagine;

  const _BarraPagine(this.pagine);

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  /// Quanto occupano tutte le linguette messe in fila.
  ///
  /// Misurate a mano e non chieste al TabBar, che la propria larghezza
  /// la sa solo dopo essersi disegnato: qui serve prima, per decidere
  /// se la freccia ci vuole. È lo stesso conto che fa
  /// [_larghezzeColonne] per le tabelle.
  double _larghezzaLinguette(BuildContext context) {
    final stile = Theme.of(context).textTheme.titleSmall;
    var totale = 0.0;
    for (final pagina in pagine) {
      final misura = TextPainter(
        text: TextSpan(text: pagina, style: stile),
        textDirection: TextDirection.ltr,
      )..layout();
      totale += misura.width + kTabLabelPadding.horizontal;
    }
    return totale;
  }

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, vincoli) {
        final barra = TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [for (final pagina in pagine) Tab(text: pagina)],
        );

        if (_larghezzaLinguette(context) <= vincoli.maxWidth) return barra;

        return Row(
          children: [
            Expanded(child: barra),
            Tooltip(
              message: 'Scorri per le altre pagine',
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colori.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabellaScorrevole extends StatefulWidget {
  final Widget contenuto;
  final double larghezzaContenuto;

  const _TabellaScorrevole({
    required this.contenuto,
    required this.larghezzaContenuto,
  });

  @override
  State<_TabellaScorrevole> createState() => _TabellaScorrevoleState();
}

class _TabellaScorrevoleState extends State<_TabellaScorrevole> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, vincoli) {
        final scorre = widget.larghezzaContenuto > vincoli.maxWidth;

        final tabella = SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          // Spazio sotto perché la barra di scorrimento non finisca
          // sopra l'ultima riga.
          padding: EdgeInsets.only(bottom: scorre ? 12 : 0),
          child: widget.contenuto,
        );

        if (!scorre) return tabella;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.swipe, size: 14, color: colori.primary),
                  const SizedBox(width: 4),
                  // Su un telefono stretto l'avviso non ci sta su una
                  // riga: deve poter andare a capo invece di sfondare.
                  Expanded(
                    child: Text(
                      'Trascina la tabella di lato per le altre colonne',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: colori.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colori.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              // Senza removePadding la barra di scorrimento si tiene
              // alla larga dai bordi dello schermo: Flutter le passa il
              // margine di sistema del telefono, e sui telefoni con i
              // tasti in fondo la barra risaliva dentro alla tabella,
              // finendo sopra all'intestazione. Qui siamo in mezzo a una
              // pagina, i bordi dello schermo non c'entrano niente.
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                removeLeft: true,
                removeRight: true,
                child: Scrollbar(
                  controller: _controller,
                  thumbVisibility: true,
                  child: tabella,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Contenuto del Pulsante Info di Sopravvivenza: da dove viene ognuno dei
/// valori della sezione.
///
/// Le formule sono quelle di Modello/Scheda, scritte qui in forma
/// leggibile. Se una formula cambia nel modello va cambiata anche qui:
/// per questo il testo nomina le Caratteristiche esattamente come le
/// chiama il modello, così le due versioni si confrontano a colpo
/// d'occhio.
Widget _formuleSopravvivenza(BuildContext context) {
  const formule = <(String, String)>[
    ('Difesa', 'Iniziativa - 1'),
    ('Resilienza Base', 'Resistenza + 1'),
    ('Resilienza Fisica', 'Resilienza Base + PA dell\'armatura indossata'),
    (
      'Resilienza Energetica',
      'Resilienza Base + PA Energia dell\'armatura indossata',
    ),
    ('Ferite Base', 'Resistenza'),
    ('Ferite Massime', 'Ferite Base + Ferite Bonus'),
    ('Shock Massimo', 'Volontà + Resistenza'),
    ('Grinta', 'Resistenza'),
    ('Fermezza', 'Volontà'),
    ('Risolutezza', 'Volontà - 1'),
  ];

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Ogni Caratteristica citata qui vale per il suo Valore Totale '
          '(Base + Bonus).',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ),
      for (final (nome, formula) in formule)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$nome: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: formula),
              ],
            ),
          ),
        ),
    ],
  );
}
