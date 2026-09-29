import 'package:flutter/material.dart';

import '../../enums/tipo_capacita.dart';
import '../../models/abilita_personaggio.dart';
import '../../models/capacita.dart';
import '../../models/caratteristica_personaggio.dart';
import '../../models/personaggio.dart';
import '../../models/talento.dart';
import '../../data/lista_capacita.dart';
import '../../services/effetti_personaggio.dart';
import '../../data/lista_caratteristiche.dart';
import '../../data/lista_talenti.dart';
import '../../widgets/sezione_collassabile.dart';
import '../creazione_pg/creazione_pg_dati.dart';
import '../creazione_pg/creazione_pg_widgets.dart';
import '../creazione_pg/dettagli_modelli.dart';

/// APP/Pagina/Aumento-PG
///
/// Permette di far progredire il [personaggio]: aumentare Caratteristiche
/// e Abilità (stessi costi PX di Avanzamento/Caratteristiche e
/// Avanzamento/Abilità della Creazione) e aggiungere nuovi Talenti e
/// nuove Capacità Generiche, e - se il personaggio ha il Tag Psionico -
/// nuovi Poteri Psionici. A differenza della Modifica, qui non è
/// possibile rimuovere nulla che il personaggio possedeva già prima di
/// aprire questa pagina: Caratteristiche e Abilità non possono scendere
/// sotto il valore di partenza (il bottone "-" si blocca lì), e solo i
/// Talenti/le Capacità aggiunti durante QUESTA sessione hanno un
/// bottone "X" per essere rimossi.
///
/// I PX partono da quelli rimasti al personaggio
/// (Modello/Personaggio.pxDisponibili) e quelli nuovi assegnati dal
/// narratore si aggiungono con il pulsante PX. Aggiungere una Capacità
/// costa i PE indicati da Modello/Capacità.costo, e toglierla li
/// restituisce; lo stesso vale per i Poteri Psionici
/// (Modello/Potere_Psionico.costo). I Talenti, che non hanno un costo nel
/// modello, restano gratuiti.
class AumentoPgPage extends StatefulWidget {
  final Personaggio personaggio;

  const AumentoPgPage({super.key, required this.personaggio});

  @override
  State<AumentoPgPage> createState() => _AumentoPgPageState();
}

class _AumentoPgPageState extends State<AumentoPgPage> {
  late final Map<String, int> _baselineCaratteristiche;
  late final Map<String, int> _baselineAbilita;
  late final Set<String> _talentiEsistenti;
  late final Set<String> _capacitaGenericheEsistenti;

  late Map<String, int> _valoriCaratteristiche;
  late Map<String, int> _valoriAbilita;

  late int _pxDisponibili;

  /// Ogni elemento rappresenta un nuovo Talento aggiunto in questa
  /// sessione di Aumento (stesso pattern delle Capacità Generiche in
  /// Creazione: dropdown + campo libero aggiunto automaticamente).
  final List<String?> _talentiAggiunti = [null];

  /// Nuove Capacità Generiche aggiunte in questa sessione di Aumento.
  final List<String?> _capacitaGenericheAggiunte = [null];

  /// Nuovi Poteri Psionici appresi in questa sessione. Come in Creazione
  /// sono disponibili solo se il personaggio ha il Tag Psionico, che qui
  /// può arrivare anche da una Capacità aggiunta adesso.
  final List<String?> _poteriPsioniciAggiunti = [null];

  late final Set<String> _poteriPsioniciEsistenti;

  @override
  void initState() {
    super.initState();
    final p = widget.personaggio;

    _baselineCaratteristiche = {
      for (final nome in caratteristicheNomi)
        nome: _valoreBaseCaratteristica(p, nome),
    };
    _baselineAbilita = {
      for (final nome in abilitaOptions) nome: _valoreBaseAbilita(p, nome),
    };
    _valoriCaratteristiche = Map.of(_baselineCaratteristiche);
    _valoriAbilita = Map.of(_baselineAbilita);
    _pxDisponibili = p.pxDisponibili;

    _talentiEsistenti = p.talenti.map((t) => t.nome).toSet();
    _capacitaGenericheEsistenti = p.capacita
        .where((c) => c.tipo == TipoCapacita.generica)
        .map((c) => c.nome)
        .toSet();
    _poteriPsioniciEsistenti = p.poteriPsionici.map((x) => x.nome).toSet();
  }

  // -------------------------------------------------------------
  // Poteri Psionici: come in Creazione si possono prendere solo se il
  // personaggio ha il Tag Psionico. Qui il tag può venire anche da una
  // Capacità aggiunta in questa stessa sessione.
  // -------------------------------------------------------------

  List<Capacita> get _capacitaCorrenti => <Capacita>[
    ...widget.personaggio.capacita,
    for (final nome in _capacitaGenericheAggiunte.whereType<String>())
      listaCapacita.firstWhere((c) => c.nome == nome),
  ];

  List<Talento> get _talentiCorrenti => <Talento>[
    ...widget.personaggio.talenti,
    for (final nome in _talentiAggiunti.whereType<String>())
      listaTalenti.firstWhere((t) => t.nome == nome),
  ];

  bool get _puoScegliereePoteriPsionici {
    final p = widget.personaggio;
    return haTagPsionico(
      tagDelPersonaggio(
        razza: p.razza,
        sistema: p.sistemaDiOrigine,
        pianeta: p.pianetaDiOrigine,
        background: p.background,
        capacita: _capacitaCorrenti,
        talenti: _talentiCorrenti,
      ),
    );
  }

  void _applicaCostoPotere(String? precedente, String? nuovo) {
    if (precedente == nuovo) return;
    if (precedente != null) _pxDisponibili += costoPoterePsionico(precedente);
    if (nuovo != null) _pxDisponibili -= costoPoterePsionico(nuovo);
  }

  /// Se il Tag Psionico non c'è (più), i poteri aggiunti in questa
  /// sessione vengono tolti e i loro PE restituiti. Quelli già posseduti
  /// prima dell'Aumento restano: da qui non si toglie nulla di
  /// preesistente.
  void _sincronizzaPoteriPsionici() {
    if (_puoScegliereePoteriPsionici) return;
    for (final nome in _poteriPsioniciAggiunti.whereType<String>()) {
      _pxDisponibili += costoPoterePsionico(nome);
    }
    _poteriPsioniciAggiunti
      ..clear()
      ..add(null);
  }

  /// Applica un cambio di scelta e rimette subito in ordine i Poteri
  /// Psionici, che dipendono dal Tag.
  void _cambiaScelta(VoidCallback cambia) {
    setState(() {
      cambia();
      _sincronizzaPoteriPsionici();
    });
  }

  void _onPoterePsionicoSelezionato(int indice, String? valore) {
    setState(() {
      _applicaCostoPotere(_poteriPsioniciAggiunti[indice], valore);
      _poteriPsioniciAggiunti[indice] = valore;
      final isUltimo = indice == _poteriPsioniciAggiunti.length - 1;
      if (isUltimo && valore != null && _restanoPoteri()) {
        _poteriPsioniciAggiunti.add(null);
      }
    });
  }

  void _rimuoviPoterePsionico(int indice) {
    setState(() {
      _applicaCostoPotere(_poteriPsioniciAggiunti[indice], null);
      _poteriPsioniciAggiunti.removeAt(indice);
      if (_poteriPsioniciAggiunti.isEmpty) {
        _poteriPsioniciAggiunti.add(null);
        return;
      }
      if (_restanoPoteri() && !_poteriPsioniciAggiunti.contains(null)) {
        _poteriPsioniciAggiunti.add(null);
      }
    });
  }

  bool _restanoPoteri() {
    final scelte = _poteriPsioniciAggiunti.whereType<String>().toSet();
    return poteriPsioniciOptions.any(
      (o) => !scelte.contains(o) && !_poteriPsioniciEsistenti.contains(o),
    );
  }

  int _valoreBaseCaratteristica(Personaggio p, String nome) {
    for (final c in p.caratteristiche) {
      if (c.caratteristica.nome == nome) return c.valoreBase;
    }
    return caratteristicaValoreIniziale;
  }

  int _valoreBaseAbilita(Personaggio p, String nome) {
    for (final a in p.abilita) {
      if (a.abilita.nome == nome) return a.valoreBase;
    }
    return abilitaValoreIniziale;
  }

  // -------------------------------------------------------------
  // Caratteristiche: stessi costi della Creazione, ma non si può
  // scendere sotto il valore di partenza (Modello/Scheda invariato da
  // prima dell'Aumento).
  // -------------------------------------------------------------

  /// Come in Creazione, l'aumento non è bloccato dai PX: se non bastano,
  /// i PX disponibili vanno in negativo e vengono segnalati in rosso.
  void _aumentaCaratteristica(String nome) {
    final valoreAttuale = _valoriCaratteristiche[nome]!;
    if (valoreAttuale >= caratteristicaValoreMassimo) return;

    final valoreArrivo = valoreAttuale + 1;
    setState(() {
      _pxDisponibili -= costoCaratteristica(valoreArrivo);
      _valoriCaratteristiche[nome] = valoreArrivo;
    });
  }

  void _diminuisciCaratteristica(String nome) {
    final valoreAttuale = _valoriCaratteristiche[nome]!;
    final minimo = _baselineCaratteristiche[nome]!;
    if (valoreAttuale <= minimo) return;

    final rimborso = costoCaratteristica(valoreAttuale);
    setState(() {
      _pxDisponibili += rimborso;
      _valoriCaratteristiche[nome] = valoreAttuale - 1;
    });
  }

  // -------------------------------------------------------------
  // Abilità: stessa restrizione di Avanzamento/Abilità della Creazione,
  // più il vincolo di non scendere sotto il valore di partenza.
  // -------------------------------------------------------------

  /// Nessun blocco né sui PX né sulla restrizione di Avanzamento/Abilità:
  /// le abilità fuori regola vengono segnalate in rosso, come in
  /// Creazione.
  void _aumentaAbilita(String nome) {
    final valoreAttuale = _valoriAbilita[nome]!;
    if (valoreAttuale >= abilitaValoreMassimo) return;

    final valoreArrivo = valoreAttuale + 1;
    setState(() {
      _pxDisponibili -= costoAbilita(valoreArrivo);
      _valoriAbilita[nome] = valoreArrivo;
    });
  }

  /// L'unico limite alla riduzione resta quello proprio dell'Aumento: non
  /// si può scendere sotto il valore già posseduto prima della sessione.
  void _diminuisciAbilita(String nome) {
    final valoreAttuale = _valoriAbilita[nome]!;
    final minimo = _baselineAbilita[nome]!;
    if (valoreAttuale <= minimo) return;

    final rimborso = costoAbilita(valoreAttuale);
    setState(() {
      _pxDisponibili += rimborso;
      _valoriAbilita[nome] = valoreAttuale - 1;
    });
  }

  // -------------------------------------------------------------
  // Talenti/Capacità Generiche aggiunti in questa sessione: stesso
  // pattern dropdown "aggiungi campo libero, escludi già scelti" usato
  // dalle Capacità Generiche in Creazione, applicato qui a due liste
  // separate e con l'esclusione aggiuntiva di quanto già posseduto.
  // -------------------------------------------------------------

  void _onTalentoAggiuntoSelezionato(int indice, String? valore) {
    _cambiaScelta(() {
      _talentiAggiunti[indice] = valore;
      final isUltimo = indice == _talentiAggiunti.length - 1;
      if (isUltimo && valore != null) {
        final scelte = _talentiAggiunti.whereType<String>().toSet();
        final restanoOpzioni = talentiOptions.any(
          (o) => !scelte.contains(o) && !_talentiEsistenti.contains(o),
        );
        if (restanoOpzioni) _talentiAggiunti.add(null);
      }
    });
  }

  void _rimuoviTalentoAggiunto(int indice) {
    _cambiaScelta(() {
      _talentiAggiunti.removeAt(indice);
      if (_talentiAggiunti.isEmpty) {
        _talentiAggiunti.add(null);
        return;
      }
      final scelte = _talentiAggiunti.whereType<String>().toSet();
      final restanoOpzioni = talentiOptions.any(
        (o) => !scelte.contains(o) && !_talentiEsistenti.contains(o),
      );
      final haGiaCampoLibero = _talentiAggiunti.contains(null);
      if (restanoOpzioni && !haGiaCampoLibero) {
        _talentiAggiunti.add(null);
      }
    });
  }

  /// Applica ai PE il passaggio da [precedente] a [nuova] nella scelta di
  /// una capacità: quella lasciata restituisce il suo costo, quella presa
  /// lo scala (Modello/Capacità.costo). Da chiamare dentro un setState.
  void _applicaCostoCapacita(String? precedente, String? nuova) {
    if (precedente == nuova) return;
    if (precedente != null) _pxDisponibili += costoCapacita(precedente);
    if (nuova != null) _pxDisponibili -= costoCapacita(nuova);
  }

  void _onCapacitaGenericaAggiuntaSelezionata(int indice, String? valore) {
    _cambiaScelta(() {
      _applicaCostoCapacita(_capacitaGenericheAggiunte[indice], valore);
      _capacitaGenericheAggiunte[indice] = valore;
      final isUltimo = indice == _capacitaGenericheAggiunte.length - 1;
      if (isUltimo && valore != null) {
        final scelte = _capacitaGenericheAggiunte.whereType<String>().toSet();
        final restanoOpzioni = capacitaGenericheOptions.any(
          (o) =>
              !scelte.contains(o) && !_capacitaGenericheEsistenti.contains(o),
        );
        if (restanoOpzioni) _capacitaGenericheAggiunte.add(null);
      }
    });
  }

  void _rimuoviCapacitaGenericaAggiunta(int indice) {
    _cambiaScelta(() {
      _applicaCostoCapacita(_capacitaGenericheAggiunte[indice], null);
      _capacitaGenericheAggiunte.removeAt(indice);
      if (_capacitaGenericheAggiunte.isEmpty) {
        _capacitaGenericheAggiunte.add(null);
        return;
      }
      final scelte = _capacitaGenericheAggiunte.whereType<String>().toSet();
      final restanoOpzioni = capacitaGenericheOptions.any(
        (o) => !scelte.contains(o) && !_capacitaGenericheEsistenti.contains(o),
      );
      final haGiaCampoLibero = _capacitaGenericheAggiunte.contains(null);
      if (restanoOpzioni && !haGiaCampoLibero) {
        _capacitaGenericheAggiunte.add(null);
      }
    });
  }

  void _mostraDialogPx() {
    mostraDialogModificaPx(
      context: context,
      pxAttuali: _pxDisponibili,
      onPxCambiati: (nuovoValore) =>
          setState(() => _pxDisponibili = nuovoValore),
    );
  }

  /// Costruisce il [Personaggio] aggiornato: stesso oggetto di partenza,
  /// con Caratteristiche/Abilità ai nuovi valori (preservando il Valore
  /// Bonus originale, non toccato dall'Aumento) e Talenti/Capacità
  /// Generiche esistenti più quelli aggiunti in questa sessione.
  void _avvisa(String messaggio) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(messaggio)));
  }

  void _salva() {
    // Gli stessi due blocchi della Creazione: un personaggio salvato non
    // può avere PE negativi né abilità oltre il limite (quelle in rosso).
    if (_pxDisponibili < 0) {
      _avvisa(
        'Punti Esperienza negativi ($_pxDisponibili): togli qualcosa '
        'prima di salvare.',
      );
      return;
    }

    final fuoriRegola = abilitaFuoriRegola(_valoriAbilita);
    if (fuoriRegola.isNotEmpty) {
      _avvisa(
        'Abilità oltre il limite consentito: ${fuoriRegola.join(', ')}. '
        'Servono almeno tante abilità apprese quanto il valore da '
        'raggiungere.',
      );
      return;
    }

    final p = widget.personaggio;

    final nuoviTalenti = _talentiAggiunti
        .whereType<String>()
        .map((nome) => listaTalenti.firstWhere((t) => t.nome == nome))
        .toList();

    final nuoveCapacita = _capacitaGenericheAggiunte
        .whereType<String>()
        .map((nome) => listaCapacita.firstWhere((c) => c.nome == nome))
        .toList();

    final capacita = <Capacita>[...p.capacita, ...nuoveCapacita];
    final talenti = <Talento>[...p.talenti, ...nuoviTalenti];

    // Come in Creazione, il Valore Bonus e i Tag sono ricalcolati
    // dall'elenco completo delle capacità possedute: le Capacità appena
    // aggiunte portano così subito il loro Modificatore e i loro Tag.
    final caratteristicheAggiornate = caratteristicheNomi.map((nome) {
      final originale = p.caratteristiche
          .where((c) => c.caratteristica.nome == nome)
          .toList();
      return CaratteristicaPersonaggio(
        caratteristica: originale.isNotEmpty
            ? originale.first.caratteristica
            : listaCaratteristiche.firstWhere((c) => c.nome == nome),
        valoreBase: _valoriCaratteristiche[nome]!,
        valoreBonus: bonusCaratteristica(
          nome,
          capacita: capacita,
          background: p.background,
          mutazioni: p.mutazioni,
        ),
      );
    }).toList();

    final abilitaAggiornate = abilitaOptions.map((nome) {
      final originale = p.abilita.where((a) => a.abilita.nome == nome).toList();
      return AbilitaPersonaggio(
        abilita: originale.isNotEmpty
            ? originale.first.abilita
            : abilitaDaNome(nome),
        valoreBase: _valoriAbilita[nome]!,
        valoreBonus: bonusAbilita(
          nome,
          capacita: capacita,
          background: p.background,
        ),
      );
    }).toList();

    final personaggioAggiornato = Personaggio(
      nome: p.nome,
      anni: p.anni,
      genere: p.genere,
      razza: p.razza,
      sistemaDiOrigine: p.sistemaDiOrigine,
      pianetaDiOrigine: p.pianetaDiOrigine,
      background: p.background,
      caratteristiche: caratteristicheAggiornate,
      abilita: abilitaAggiornate,
      talenti: talenti,
      capacita: capacita,
      lesioniMemorabili: p.lesioniMemorabili,
      lesioniTraumatiche: p.lesioniTraumatiche,
      mutazioni: p.mutazioni,
      corruzione: p.corruzione,
      poteriPsionici: [
        ...p.poteriPsionici,
        ...poteriPsioniciDaNomi(
          _poteriPsioniciAggiunti.whereType<String>().toList(),
        ),
      ],
      tag: tagDelPersonaggio(
        razza: p.razza,
        sistema: p.sistemaDiOrigine,
        pianeta: p.pianetaDiOrigine,
        background: p.background,
        capacita: capacita,
        talenti: talenti,
      ),
      pxDisponibili: _pxDisponibili,
    );

    Navigator.of(context).pop(personaggioAggiornato);
  }

  /// Barra dei Punti Esperienza ancorata al fondo della pagina. I PX
  /// possono andare in negativo (nessun blocco sugli aumenti): in quel
  /// caso il valore diventa rosso.
  Widget _buildBarraPx(BuildContext context) {
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              // Flexible: su uno schermo stretto, o col testo di
              // sistema ingrandito, la scritta da sola è più larga
              // della barra e si porterebbe via il tasto dei PX.
              Flexible(
                child: Text(
                  'Punti Esperienza disponibili: $_pxDisponibili',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _pxDisponibili < 0 ? Colors.red : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle),
                tooltip: 'Aggiungi PX guadagnati',
                onPressed: _mostraDialogPx,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Torna alla Home',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Aumento - ${widget.personaggio.nome}'),
      ),
      // I Punti Esperienza restano ancorati in fondo alla pagina anche
      // scorrendo, come in Creazione/Pagina 2.
      bottomNavigationBar: _buildBarraPx(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Senza una riga che lo dica, la pagina sembra una Modifica
            // a cui mancano dei pezzi.
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Qui si spendono i Punti Esperienza guadagnati giocando: '
                'puoi alzare Caratteristiche e Abilità e aggiungere '
                'Talenti, Capacità e Poteri, ma non toglierli. Razza, '
                'sistema, pianeta e background si cambiano da Modifica.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
            SezioneCollassabile(
              titolo: 'Caratteristiche',
              azione: InfoButton(
                titolo: 'Costi di avanzamento - Caratteristiche',
                contenutoBuilder: (_) => TabellaCosti(
                  valoreIniziale: caratteristicaValoreIniziale + 1,
                  valoreMassimo: caratteristicaValoreMassimo,
                  costo: costoCaratteristica,
                ),
              ),
              figli: [
                const SizedBox(height: 8),
                ...caratteristicheNomi.map(
                  (nome) => _buildRigaValore(
                    nome: '$nome (${caratteristicaDiminutivo[nome] ?? nome})',
                    descrizione: descrizioneCaratteristica(nome),
                    valore: _valoriCaratteristiche[nome]!,
                    valoreMinimo: _baselineCaratteristiche[nome]!,
                    valoreMassimo: caratteristicaValoreMassimo,
                    costo: costoCaratteristica,
                    onAumenta: () => _aumentaCaratteristica(nome),
                    onDiminuisci: () => _diminuisciCaratteristica(nome),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SezioneCollassabile(
              titolo: 'Abilità',
              azione: InfoButton(
                titolo: 'Costi di avanzamento - Abilità',
                contenutoBuilder: (_) => TabellaCosti(
                  valoreIniziale: abilitaValoreIniziale + 1,
                  valoreMassimo: abilitaValoreMassimo,
                  costo: costoAbilita,
                ),
              ),
              sottotitolo:
                  '$legendaAsteriscoAbilita\n$restrizioneAvanzamentoAbilita',
              figli: [
                ...abilitaOptions.map((nome) {
                  final abilita = abilitaDaNome(nome);
                  final valoreAttuale = _valoriAbilita[nome]!;
                  final fuoriRegola = abilitaViolaRestrizione(
                    _valoriAbilita,
                    nome,
                  );
                  final diminutivoCaratteristica =
                      caratteristicaDiminutivo[abilita.caratteristica.nome] ??
                      abilita.caratteristica.nome;
                  final nomeConDiminutivo =
                      '$nome ($diminutivoCaratteristica)'
                      '${abilita.addestramento ? '*' : ''}';
                  return _buildRigaValore(
                    nome: nomeConDiminutivo,
                    descrizione: descrizioneAbilita(nome),
                    valore: valoreAttuale,
                    valoreMinimo: _baselineAbilita[nome]!,
                    valoreMassimo: abilitaValoreMassimo,
                    costo: costoAbilita,
                    fuoriRegola: fuoriRegola,
                    motivoFuoriRegola:
                        'Servono almeno $valoreAttuale abilità apprese per '
                        'tenere questa abilità a $valoreAttuale',
                    onAumenta: () => _aumentaAbilita(nome),
                    onDiminuisci: () => _diminuisciAbilita(nome),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            SezioneCollassabile(
              titolo: 'Talenti già posseduti',
              figli: [
                const SizedBox(height: 8),
                if (_talentiEsistenti.isEmpty)
                  const Text('Nessuno.')
                else
                  ..._talentiEsistenti.map((nome) => Text('• $nome')),
              ],
            ),
            const SizedBox(height: 16),
            SezioneCollassabile(
              titolo: 'Nuovi Talenti',
              figli: [
                const SizedBox(height: 8),
                ..._buildCampiTalentiAggiunti(),
              ],
            ),
            const SizedBox(height: 24),
            SezioneCollassabile(
              titolo: 'Capacità Generiche già possedute',
              figli: [
                const SizedBox(height: 8),
                if (_capacitaGenericheEsistenti.isEmpty)
                  const Text('Nessuna.')
                else
                  ..._capacitaGenericheEsistenti.map((nome) => Text('• $nome')),
              ],
            ),
            const SizedBox(height: 16),
            SezioneCollassabile(
              titolo: 'Nuove Capacità Generiche',
              figli: [
                const SizedBox(height: 8),
                ..._buildCampiCapacitaGenericheAggiunte(),
              ],
            ),
            if (_puoScegliereePoteriPsionici) ...[
              const SizedBox(height: 24),
              SezioneCollassabile(
                titolo: 'Poteri Psionici già appresi',
                figli: [
                  const SizedBox(height: 8),
                  if (_poteriPsioniciEsistenti.isEmpty)
                    const Text('Nessuno.')
                  else
                    ..._poteriPsioniciEsistenti.map((nome) => Text('• ')),
                ],
              ),
              const SizedBox(height: 16),
              SezioneCollassabile(
                titolo: 'Nuovi Poteri Psionici',
                figli: [
                  const SizedBox(height: 8),
                  ..._buildCampiPoteriPsionici(),
                ],
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _salva, child: const Text('SALVA')),
          ],
        ),
      ),
    );
  }

  /// Riga con nome, Pulsante Info, bottone "-", valore, bottone "+".
  /// Stesso comportamento della riga equivalente in Creazione (vedi
  /// Pagina2GestioneEsperienza._buildRigaValore), qui con [valoreMinimo]
  /// pari al valore di partenza dell'Aumento invece che al minimo
  /// assoluto di Creazione.
  Widget _buildRigaValore({
    required String nome,
    required String descrizione,
    required int valore,
    required int valoreMinimo,
    required int valoreMassimo,
    required int Function(int valoreArrivo) costo,
    required VoidCallback onAumenta,
    required VoidCallback onDiminuisci,
    bool fuoriRegola = false,
    String? motivoFuoriRegola,
  }) {
    final puoAumentare = valore < valoreMassimo;
    final puoDiminuire = valore > valoreMinimo;
    final coloreFuoriRegola = fuoriRegola ? Colors.red : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: TextStyle(color: coloreFuoriRegola)),
                if (fuoriRegola && motivoFuoriRegola != null)
                  Text(
                    motivoFuoriRegola,
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
              ],
            ),
          ),
          InfoButton(titolo: nome, contenutoBuilder: (_) => Text(descrizione)),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: valore <= valoreMinimo
                ? 'Non si può scendere sotto il valore già posseduto'
                : null,
            onPressed: puoDiminuire ? onDiminuisci : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$valore',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: coloreFuoriRegola,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Costo: ${costo(valore + 1)} PE',
            onPressed: puoAumentare ? onAumenta : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCampiTalentiAggiunti() {
    return List.generate(_talentiAggiunti.length, (indice) {
      final valoreCorrente = _talentiAggiunti[indice];
      final scelteAltrove = <String>{
        for (var i = 0; i < _talentiAggiunti.length; i++)
          if (i != indice && _talentiAggiunti[i] != null) _talentiAggiunti[i]!,
      };
      final opzioniDisponibili = talentiOptions
          .where(
            (o) => !scelteAltrove.contains(o) && !_talentiEsistenti.contains(o),
          )
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DropdownConDettagli(
          label: 'Nuovo Talento ${indice + 1}',
          valoreSelezionato: valoreCorrente,
          opzioni: opzioniDisponibili,
          descrizioni: talentiDescrizioni,
          contenutoInfo: (opzioni) =>
              DettagliTalento(talenti: talentiDaNomi(opzioni)),
          onChanged: (valore) => _onTalentoAggiuntoSelezionato(indice, valore),
          onRimuovi: () => _rimuoviTalentoAggiunto(indice),
          infoSoloOpzioneSelezionata: true,
        ),
      );
    });
  }

  /// Campi di scelta dei nuovi Poteri Psionici: escludono quelli già
  /// posseduti e quelli scelti negli altri campi.
  List<Widget> _buildCampiPoteriPsionici() {
    return List.generate(_poteriPsioniciAggiunti.length, (indice) {
      final valoreCorrente = _poteriPsioniciAggiunti[indice];
      final scelteAltrove = <String>{
        for (var i = 0; i < _poteriPsioniciAggiunti.length; i++)
          if (i != indice && _poteriPsioniciAggiunti[i] != null)
            _poteriPsioniciAggiunti[i]!,
      };
      final opzioniDisponibili = poteriPsioniciOptions
          .where(
            (o) =>
                !scelteAltrove.contains(o) &&
                !_poteriPsioniciEsistenti.contains(o),
          )
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DropdownConDettagli(
          label: 'Nuovo Potere Psionico ${indice + 1}',
          valoreSelezionato: valoreCorrente,
          opzioni: opzioniDisponibili,
          descrizioni: {
            for (final p in opzioniDisponibili) p: descrizionePoterePsionico(p),
          },
          etichetteSecondarie: poteriPsioniciCosti,
          contenutoInfo: (opzioni) =>
              DettagliPoterePsionico(poteri: poteriPsioniciDaNomi(opzioni)),
          onChanged: (valore) => _onPoterePsionicoSelezionato(indice, valore),
          onRimuovi: () => _rimuoviPoterePsionico(indice),
          infoSoloOpzioneSelezionata: true,
        ),
      );
    });
  }

  List<Widget> _buildCampiCapacitaGenericheAggiunte() {
    return List.generate(_capacitaGenericheAggiunte.length, (indice) {
      final valoreCorrente = _capacitaGenericheAggiunte[indice];
      final scelteAltrove = <String>{
        for (var i = 0; i < _capacitaGenericheAggiunte.length; i++)
          if (i != indice && _capacitaGenericheAggiunte[i] != null)
            _capacitaGenericheAggiunte[i]!,
      };
      final opzioniDisponibili = capacitaGenericheOptions
          .where(
            (o) =>
                !scelteAltrove.contains(o) &&
                !_capacitaGenericheEsistenti.contains(o),
          )
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DropdownConDettagli(
          label: 'Nuova Capacità Generica ${indice + 1}',
          valoreSelezionato: valoreCorrente,
          opzioni: opzioniDisponibili,
          descrizioni: {
            for (final c in opzioniDisponibili) c: descrizioneCapacita(c),
          },
          etichetteSecondarie: capacitaCosti,
          contenutoInfo: (opzioni) =>
              DettagliCapacita(capacita: capacitaDaNomi(opzioni)),
          onChanged: (valore) =>
              _onCapacitaGenericaAggiuntaSelezionata(indice, valore),
          onRimuovi: () => _rimuoviCapacitaGenericaAggiunta(indice),
          infoSoloOpzioneSelezionata: true,
        ),
      );
    });
  }
}
