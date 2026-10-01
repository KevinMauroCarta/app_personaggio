import 'package:flutter/material.dart';

import '../../models/personaggio.dart';
import '../../models/caratteristica_personaggio.dart';
import '../../models/abilita_personaggio.dart';
import '../../models/talento.dart';
import '../../models/capacita.dart';
import '../../models/background.dart';
import '../../models/mutazione.dart';
import '../../models/pianeta.dart';
import '../../models/potere_psionico.dart';
import '../../models/razza.dart';
import '../../models/sistema.dart';
import '../../enums/genere.dart';
import '../../data/lista_razze.dart';
import '../../data/lista_background.dart';
import '../../data/lista_sistemi.dart';
import '../../data/lista_caratteristiche.dart';
import '../../data/lista_talenti.dart';
import '../../data/lista_capacita.dart';
import '../../services/effetti_personaggio.dart';
import 'creazione_pg_dati.dart';
import 'creazione_pg_widgets.dart';
import 'pagina_1_info_generali.dart';
import 'pagina_2_gestione_esperienza.dart';
import 'pagina_3_riepilogo.dart';

/// Pagina di creazione del personaggio.
///
/// Coordina le 3 sotto-pagine (Info Generali, Gestione Esperienza,
/// Riepilogo) tramite un unico [PageController] e un unico stato
/// condiviso. Le sotto-pagine sono widget "stupidi" che ricevono i
/// dati e notificano i cambiamenti tramite callback: tutta la logica
/// vive qui.
///
/// Lo stato interno (caratteristiche, abilità, ecc.) resta espresso con
/// semplici `Map<String, int>` tenute per nome, com'era nella versione
/// precedente: è solo al momento della creazione ([_creaPersonaggio])
/// che questi nomi vengono risolti negli oggetti reali (Caratteristica,
/// Abilita, Razza, Sistema, ecc.) definiti in lib/models e lib/data, per
/// costruire un [Personaggio] completo.
///
/// Se [personaggioIniziale] è fornito, la pagina funge da schermata di
/// Modifica (APP/Pagina/Modifica-PG): tutti i campi partono precompilati
/// con i valori di quel personaggio invece che con i valori standard di
/// creazione, PX rimasti inclusi (Modello/Personaggio.pxDisponibili). Il
/// salvataggio resta lo stesso ([_creaPersonaggio]): la pagina
/// restituisce sempre un [Personaggio] nuovo - con i PX rimasti a fine
/// sessione - e la Home decide se aggiungerlo o sostituire quello
/// esistente.
class CharacterCreationPage extends StatefulWidget {
  final Personaggio? personaggioIniziale;

  const CharacterCreationPage({super.key, this.personaggioIniziale});

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// True se la pagina è in modalità Modifica (APP/Pagina/Modifica-PG)
  /// invece che Creazione.
  bool get _inModifica => widget.personaggioIniziale != null;

  // ---- Pagina 1 - Info Generali ----
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _anniController = TextEditingController();
  String? _razzaSelezionata;
  String? _genereSelezionato;
  String? _backgroundSelezionato;
  String? _sistemaSelezionato;
  String? _pianetaSelezionato;

  // ---- Pagina 2 - Gestione Esperienza ----
  late int _pxDisponibili;
  late Map<String, int> _valoriCaratteristiche;
  late Map<String, int> _valoriAbilita;
  String? _talentoSelezionato;

  /// Una per campo "Capacità di Razza N": se ne prendono
  /// [capacitaRazzaDaScegliere], tutte diverse.
  final List<String?> _capacitaRazzaSelezionate = List.filled(
    capacitaRazzaDaScegliere,
    null,
  );
  String? _capacitaSistemaSelezionata;
  String? _capacitaPianetaSelezionata;

  /// Ogni elemento rappresenta un campo Capacità Generica (dropdown).
  /// Parte con un singolo campo vuoto; ogni volta che un campo viene
  /// compilato (e ci sono ancora opzioni libere) ne viene aggiunto uno
  /// nuovo in coda.
  final List<String?> _capacitaGenericheSelezionate = [null];

  /// Poteri Psionici scelti. Stesso pattern delle Capacità Generiche, ma
  /// la sezione che li offre compare solo se il personaggio ha il Tag
  /// Psionico (vedi [_puoScegliereePoteriPsionici]).
  final List<String?> _poteriPsioniciSelezionati = [null];

  /// Restituisce il primo elemento di [elementi] che soddisfa [test], o
  /// null se nessuno lo soddisfa (Iterable.firstWhere non ha una
  /// variante che accetta un [orElse] nullable, da qui questo piccolo
  /// helper). Usato per precompilare i campi in Modifica a partire da
  /// [widget.personaggioIniziale].
  T? _primoOppureNull<T>(Iterable<T> elementi, bool Function(T) test) {
    for (final elemento in elementi) {
      if (test(elemento)) return elemento;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    final personaggio = widget.personaggioIniziale;
    if (personaggio == null) {
      _pxDisponibili = pxIniziali;
      _valoriCaratteristiche = {
        for (final nome in caratteristicheNomi)
          nome: caratteristicaValoreIniziale,
      };
      _valoriAbilita = {
        for (final nome in abilitaOptions) nome: abilitaValoreIniziale,
      };
      return;
    }

    _nomeController.text = personaggio.nome;
    _anniController.text = personaggio.anni.toString();
    _razzaSelezionata = personaggio.razza.nome;
    _genereSelezionato = personaggio.genere.label;
    _backgroundSelezionato = personaggio.background.nome;
    _sistemaSelezionato = personaggio.sistemaDiOrigine.nome;
    _pianetaSelezionato = personaggio.pianetaDiOrigine.nome;

    _valoriCaratteristiche = {
      for (final nome in caratteristicheNomi)
        nome:
            _primoOppureNull(
              personaggio.caratteristiche,
              (c) => c.caratteristica.nome == nome,
            )?.valoreBase ??
            caratteristicaValoreIniziale,
    };
    _valoriAbilita = {
      for (final nome in abilitaOptions)
        nome:
            _primoOppureNull(
              personaggio.abilita,
              (a) => a.abilita.nome == nome,
            )?.valoreBase ??
            abilitaValoreIniziale,
    };

    // I PX ripartono da quelli rimasti al termine dell'ultima
    // Creazione/Modifica/Aumento (Modello/Personaggio.pxDisponibili), non
    // da pxIniziali: altrimenti la Modifica regalerebbe PX extra.
    _pxDisponibili = personaggio.pxDisponibili;

    _talentoSelezionato = personaggio.talenti.isEmpty
        ? null
        : personaggio.talenti.first.nome;

    // Le opzioni sono quelle che Pagina 2 offrirà: un valore precompilato
    // che non fosse fra le voci della sua tendina la manderebbe in errore.
    final ripartite = ripartisciCapacita(personaggio.capacita, [
      for (var i = 0; i < capacitaRazzaDaScegliere; i++)
        capacitaRazzaOptions[_razzaSelezionata] ?? const [],
      capacitaSistemaOptions[_sistemaSelezionato] ?? const [],
      capacitaPianetaOptions(_sistemaSelezionato, _pianetaSelezionato),
      [?capacitaDiBackground(_backgroundSelezionato)],
    ]);
    // La Capacità di Background non si legge da qui: arriva sempre con
    // il background.
    final [...razza, sistema, pianeta, _] = ripartite.campi;
    _capacitaRazzaSelezionate.setAll(0, razza);
    _capacitaSistemaSelezionata = sistema;
    _capacitaPianetaSelezionata = pianeta;

    final capacitaGenericheEsistenti = ripartite.generiche;
    _capacitaGenericheSelezionate
      ..clear()
      ..addAll(capacitaGenericheEsistenti);
    final scelte = capacitaGenericheEsistenti.toSet();
    final restanoOpzioni = capacitaGenericheOptions.any(
      (o) => !scelte.contains(o),
    );
    if (restanoOpzioni || _capacitaGenericheSelezionate.isEmpty) {
      _capacitaGenericheSelezionate.add(null);
    }

    final poteriEsistenti = personaggio.poteriPsionici
        .map((p) => p.nome)
        .toList();
    _poteriPsioniciSelezionati
      ..clear()
      ..addAll(poteriEsistenti);
    final restanoPoteri = poteriPsioniciOptions.any(
      (o) => !poteriEsistenti.contains(o),
    );
    if (restanoPoteri || _poteriPsioniciSelezionati.isEmpty) {
      _poteriPsioniciSelezionati.add(null);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nomeController.dispose();
    _anniController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------
  // Caratteristiche: range 1-12, costo da Avanzamento/Caratteristiche
  // -------------------------------------------------------------

  /// Aumenta la caratteristica di 1. Non c'è nessun blocco sui PX: se non
  /// bastano, i PX disponibili vanno in negativo e la barra in fondo alla
  /// Pagina 2 li segnala in rosso (APP/Pagina/Creazione-PG/Pagina_2).
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
    if (valoreAttuale <= caratteristicaValoreIniziale) return;

    final rimborso = costoCaratteristica(valoreAttuale);
    setState(() {
      _pxDisponibili += rimborso;
      _valoriCaratteristiche[nome] = valoreAttuale - 1;
    });
  }

  // -------------------------------------------------------------
  // Abilità: range 0-8, costo da Avanzamento/Abilità
  // -------------------------------------------------------------

  /// Aumenta l'abilità di 1. Come per le Caratteristiche non c'è alcun
  /// blocco: né sui PX (che possono andare in negativo) né sulla
  /// restrizione di Avanzamento/Abilità, che se violata viene solo
  /// segnalata in rosso sulla riga dell'abilità.
  void _aumentaAbilita(String nome) {
    final valoreAttuale = _valoriAbilita[nome]!;
    if (valoreAttuale >= abilitaValoreMassimo) return;

    final valoreArrivo = valoreAttuale + 1;
    setState(() {
      _pxDisponibili -= costoAbilita(valoreArrivo);
      _valoriAbilita[nome] = valoreArrivo;
    });
  }

  /// Diminuisce l'abilità di 1 senza blocchi: se così facendo un'altra
  /// abilità resta sopra il numero di abilità apprese, è quell'altra
  /// abilità a diventare rossa in Pagina 2.
  void _diminuisciAbilita(String nome) {
    final valoreAttuale = _valoriAbilita[nome]!;
    if (valoreAttuale <= abilitaValoreIniziale) return;

    final rimborso = costoAbilita(valoreAttuale);
    setState(() {
      _pxDisponibili += rimborso;
      _valoriAbilita[nome] = valoreAttuale - 1;
    });
  }

  /// Applica ai PE disponibili il passaggio da [precedente] a [nuova]
  /// nella scelta di una Capacità Generica: la capacità lasciata
  /// restituisce il suo costo, quella presa lo scala (Modello/Capacità.costo).
  ///
  /// Solo le Generiche si pagano. Quelle di Razza, di Sistema, del
  /// Pianeta e di Background arrivano dalle scelte di Pagina 1 e non
  /// muovono PE, anche quando la stessa capacità esiste come Generica
  /// (Addestramento Psichico, offerta da alcuni sistemi).
  ///
  /// Da chiamare solo dentro un setState, e solo sui cambiamenti: le
  /// capacità già possedute all'apertura della Modifica sono già state
  /// pagate e non vanno riaddebitate.
  void _applicaCostoCapacita(String? precedente, String? nuova) {
    if (precedente == nuova) return;
    if (precedente != null) _pxDisponibili += costoCapacita(precedente);
    if (nuova != null) _pxDisponibili -= costoCapacita(nuova);
  }

  /// Passa da [_cambiaScelta] perché una Capacità Generica è la via più
  /// comune al Tag Psionico ("Addestramento Psichico", "Memoria
  /// Fotografica"): cambiandola o togliendola i Poteri Psionici vanno
  /// rimessi in ordine, altrimenti restano scelti e pagati.
  void _onCapacitaGenericaSelezionata(int indice, String? valore) {
    _cambiaScelta(() {
      _applicaCostoCapacita(_capacitaGenericheSelezionate[indice], valore);
      _capacitaGenericheSelezionate[indice] = valore;

      final isUltimo = indice == _capacitaGenericheSelezionate.length - 1;
      if (isUltimo && valore != null) {
        // Aggiunge un nuovo campo solo se esistono ancora opzioni libere
        final scelte = _capacitaGenericheSelezionate
            .whereType<String>()
            .toSet();
        final restanoOpzioni = capacitaGenericheOptions.any(
          (o) => !scelte.contains(o),
        );
        if (restanoOpzioni) {
          _capacitaGenericheSelezionate.add(null);
        }
      }
    });
  }

  /// Rimuove il campo Capacità Generica all'[indice] indicato (bottone
  /// "X"), mantenendo sempre almeno un campo libero in coda finché
  /// esistono ancora opzioni non scelte.
  void _rimuoviCapacitaGenerica(int indice) {
    _cambiaScelta(() {
      _applicaCostoCapacita(_capacitaGenericheSelezionate[indice], null);
      _capacitaGenericheSelezionate.removeAt(indice);

      if (_capacitaGenericheSelezionate.isEmpty) {
        _capacitaGenericheSelezionate.add(null);
        return;
      }

      final scelte = _capacitaGenericheSelezionate.whereType<String>().toSet();
      final restanoOpzioni = capacitaGenericheOptions.any(
        (o) => !scelte.contains(o),
      );
      final haGiaCampoLibero = _capacitaGenericheSelezionate.contains(null);
      if (restanoOpzioni && !haGiaCampoLibero) {
        _capacitaGenericheSelezionate.add(null);
      }
    });
  }

  /// I Poteri Psionici scelti, nell'ordine in cui sono stati presi.
  /// Sono ignorati se il personaggio ha perso il Tag Psionico: in quel
  /// caso non può averne, qualunque cosa fosse rimasta selezionata.
  List<PoterePsionico> get _poteriPsionici => _puoScegliereePoteriPsionici
      ? poteriPsioniciDaNomi(
          _poteriPsioniciSelezionati.whereType<String>().toList(),
        )
      : const [];

  /// Come [_applicaCostoCapacita], ma per i Poteri Psionici
  /// (Modello/Potere_Psionico.costo). Da chiamare dentro un setState.
  void _applicaCostoPotere(String? precedente, String? nuovo) {
    if (precedente == nuovo) return;
    if (precedente != null) _pxDisponibili += costoPoterePsionico(precedente);
    if (nuovo != null) _pxDisponibili -= costoPoterePsionico(nuovo);
  }

  /// Se il personaggio ha perso il Tag Psionico, i poteri scelti non gli
  /// spettano più: vengono tolti e i PE spesi restituiti. Da chiamare
  /// dentro un setState, DOPO aver applicato il cambio di scelta.
  void _sincronizzaPoteriPsionici() {
    if (_puoScegliereePoteriPsionici) return;
    for (final nome in _poteriPsioniciSelezionati.whereType<String>()) {
      _pxDisponibili += costoPoterePsionico(nome);
    }
    _poteriPsioniciSelezionati
      ..clear()
      ..add(null);
  }

  /// Applica un cambio di scelta e rimette subito in ordine i Poteri
  /// Psionici: ogni scelta può far comparire o sparire il Tag Psionico.
  void _cambiaScelta(VoidCallback cambia) {
    setState(() {
      cambia();
      _sincronizzaPoteriPsionici();
    });
  }

  void _onPoterePsionicoSelezionato(int indice, String? valore) {
    setState(() {
      _applicaCostoPotere(_poteriPsioniciSelezionati[indice], valore);
      _poteriPsioniciSelezionati[indice] = valore;

      final isUltimo = indice == _poteriPsioniciSelezionati.length - 1;
      if (isUltimo && valore != null) {
        final scelte = _poteriPsioniciSelezionati.whereType<String>().toSet();
        if (poteriPsioniciOptions.any((o) => !scelte.contains(o))) {
          _poteriPsioniciSelezionati.add(null);
        }
      }
    });
  }

  void _rimuoviPoterePsionico(int indice) {
    setState(() {
      _applicaCostoPotere(_poteriPsioniciSelezionati[indice], null);
      _poteriPsioniciSelezionati.removeAt(indice);

      if (_poteriPsioniciSelezionati.isEmpty) {
        _poteriPsioniciSelezionati.add(null);
        return;
      }
      final scelte = _poteriPsioniciSelezionati.whereType<String>().toSet();
      final restanoOpzioni = poteriPsioniciOptions.any(
        (o) => !scelte.contains(o),
      );
      if (restanoOpzioni && !_poteriPsioniciSelezionati.contains(null)) {
        _poteriPsioniciSelezionati.add(null);
      }
    });
  }

  /// I campi di Pagina 1 non ancora compilati, nell'ordine in cui
  /// compaiono. Sono tutti obbligatori: un personaggio senza razza o
  /// senza pianeta di origine non è una scheda incompleta, è una scheda
  /// che non sta in piedi (da lì arrivano capacità, tag e taglia).
  List<String> get _campiMancantiPagina1 => [
    if (_nomeController.text.trim().isEmpty) 'Nome personaggio',
    if (_razzaSelezionata == null) 'Razza',
    if (_anniController.text.trim().isEmpty) 'Anni',
    if (_genereSelezionato == null) 'Genere',
    if (_backgroundSelezionato == null) 'Background',
    if (_sistemaSelezionato == null) 'Sistema di origine',
    if (_pianetaSelezionato == null) 'Pianeta di origine',
  ];

  void _vaiAPagina2() {
    final mancanti = _campiMancantiPagina1;
    if (mancanti.isNotEmpty) {
      // Dire *quali* campi mancano evita di rileggere tutta la pagina
      // per capire cosa non va.
      _avvisa('Compila prima: ${mancanti.join(', ')}');
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _mostraDialogModificaPx() {
    mostraDialogModificaPx(
      context: context,
      pxAttuali: _pxDisponibili,
      onPxCambiati: (nuovoValore) =>
          setState(() => _pxDisponibili = nuovoValore),
    );
  }

  void _tornaAPagina1() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// I campi obbligatori di Pagina 2 non ancora compilati: il Talento e
  /// le Capacità di Razza, di Sistema e del Pianeta. Manca la Capacità di
  /// Background perché non si sceglie: arriva già presa con il
  /// background, obbligatorio in Pagina 1.
  List<String> get _campiMancantiPagina2 => [
    if (_talentoSelezionato == null) 'Talento',
    for (var i = 0; i < capacitaRazzaDaScegliere; i++)
      if (_capacitaRazzaSelezionate[i] == null) 'Capacità di Razza ${i + 1}',
    if (_capacitaSistemaSelezionata == null) 'Capacità di Sistema',
    if (_capacitaPianetaSelezionata == null) 'Capacità del Pianeta',
  ];

  void _vaiARiepilogo() {
    final mancanti = _campiMancantiPagina2;
    if (mancanti.isNotEmpty) {
      _avvisa('Compila prima: ${mancanti.join(', ')}');
      return;
    }

    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _tornaAPagina2() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Costruisce il [Personaggio] finale risolvendo i nomi selezionati
  /// nelle pagine precedenti negli oggetti reali (Razza, Sistema,
  /// Pianeta, Background, Caratteristica, Abilita, Talento, Capacita)
  /// definiti in lib/data.
  ///
  /// NOTA: se [test] è true, alcuni campi obbligatori potrebbero non
  /// essere stati selezionati (validazione disattivata): in quel caso si
  /// usa un valore di default (il primo della lista) per evitare che la
  /// creazione fallisca durante lo sviluppo.
  // -------------------------------------------------------------
  // Risoluzione delle scelte correnti negli oggetti di lib/data.
  // Serve sia a costruire il Personaggio finale, sia - durante la
  // compilazione - a sapere quali Tag ha già il personaggio, da cui
  // dipende la disponibilità dei Poteri Psionici.
  // -------------------------------------------------------------

  Razza get _razza => listaRazze.firstWhere(
    (r) => r.nome == _razzaSelezionata,
    orElse: () => listaRazze.first,
  );

  Sistema get _sistema => listaSistemi.firstWhere(
    (s) => s.nome == _sistemaSelezionato,
    orElse: () => listaSistemi.first,
  );

  Pianeta get _pianeta => _sistema.pianeti.firstWhere(
    (p) => p.nome == _pianetaSelezionato,
    orElse: () => _sistema.pianeti.first,
  );

  Background get _background => listaBackground.firstWhere(
    (b) => b.nome == _backgroundSelezionato,
    orElse: () => listaBackground.first,
  );

  List<Talento> get _talenti => _talentoSelezionato == null
      ? const []
      : [listaTalenti.firstWhere((t) => t.nome == _talentoSelezionato)];

  /// Le Capacità di Razza vengono cercate nella lista propria della
  /// razza scelta, quelle di Sistema e del Pianeta nelle liste proprie
  /// del sistema e del pianeta scelti, quella di Background è l'unica del
  /// background scelto, e quelle Generiche stanno nell'elenco completo di
  /// Lista/Capacità.
  ///
  /// L'ordine - Razza, Sistema, Pianeta, Background, Generiche - è quello
  /// con cui il personaggio viene salvato, e la Modifica ci conta per
  /// rimettere ogni capacità nel suo campo (vedi [ripartisciCapacita]).
  List<Capacita> get _capacita => <Capacita>[
    for (final nome in _capacitaRazzaSelezionate.whereType<String>())
      _razza.capacita.firstWhere((c) => c.nome == nome),
    if (_capacitaSistemaSelezionata != null)
      _sistema.capacitaDelSistema.firstWhere(
        (c) => c.nome == _capacitaSistemaSelezionata,
      ),
    if (_capacitaPianetaSelezionata != null)
      _pianeta.capacitaDelPianeta.firstWhere(
        (c) => c.nome == _capacitaPianetaSelezionata,
      ),
    if (_backgroundSelezionato != null) _background.capacitaDiBackground,
    for (final nome in _capacitaGenericheSelezionate.whereType<String>())
      listaCapacita.firstWhere((c) => c.nome == nome),
  ];

  /// I Tag che il personaggio ha con le scelte fatte finora.
  List<String> get _tagCorrenti => tagDelPersonaggio(
    razza: _razza,
    sistema: _sistema,
    pianeta: _pianeta,
    background: _background,
    capacita: _capacita,
    talenti: _talenti,
  );

  /// Regolamento: i Poteri Psionici si possono prendere solo se una
  /// delle scelte fatte ha portato il Tag Psionico.
  bool get _puoScegliereePoteriPsionici => haTagPsionico(_tagCorrenti);

  void _avvisa(String messaggio) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(messaggio)));
  }

  void _creaPersonaggio() {
    // Durante la spesa si può andare in negativo - serve a provare le
    // combinazioni, ed è segnalato in rosso - ma un personaggio con PE
    // negativi ha speso punti che non aveva: non si salva.
    if (_pxDisponibili < 0) {
      _avvisa(
        'Punti Esperienza negativi ($_pxDisponibili): togli qualcosa '
        'prima di salvare.',
      );
      return;
    }

    final mancanti = [..._campiMancantiPagina1, ..._campiMancantiPagina2];
    if (mancanti.isNotEmpty) {
      _avvisa('Compila prima: ${mancanti.join(', ')}');
      return;
    }

    // Le abilità in rosso violano Avanzamento/Abilità: si possono
    // lasciare tali mentre si spendono i PE, non in un personaggio
    // salvato.
    final fuoriRegola = abilitaFuoriRegola(_valoriAbilita);
    if (fuoriRegola.isNotEmpty) {
      _avvisa(
        'Abilità oltre il limite consentito: ${fuoriRegola.join(', ')}. '
        'Servono almeno tante abilità apprese quanto il valore da '
        'raggiungere.',
      );
      return;
    }

    final iniziale = widget.personaggioIniziale;
    final mutazioni = iniziale?.mutazioni ?? const <Mutazione>[];
    final razza = _razza;
    final sistema = _sistema;
    final pianeta = _pianeta;
    final background = _background;
    final talenti = _talenti;
    final capacita = _capacita;

    final genere = Genere.values.firstWhere(
      (g) => g.label == _genereSelezionato,
      orElse: () => Genere.nonDefinito,
    );

    // I Modificatori delle Capacità possedute vanno nel Valore Bonus
    // della Caratteristica/Abilità indicata, e i loro Tag nei Tag del
    // personaggio (vedi services/effetti_capacita.dart). Il Valore Bonus
    // è sempre ricalcolato dall'elenco completo delle capacità, così
    // togliendone una in Modifica sparisce anche il suo bonus.
    final caratteristiche = _valoriCaratteristiche.entries
        .map(
          (e) => CaratteristicaPersonaggio(
            caratteristica: listaCaratteristiche.firstWhere(
              (c) => c.nome == e.key,
            ),
            valoreBase: e.value,
            valoreBonus: bonusCaratteristica(
              e.key,
              capacita: capacita,
              background: background,
              mutazioni: mutazioni,
            ),
          ),
        )
        .toList();

    final abilita = _valoriAbilita.entries
        .map(
          (e) => AbilitaPersonaggio(
            abilita: abilitaDaNome(e.key),
            valoreBase: e.value,
            valoreBonus: bonusAbilita(
              e.key,
              capacita: capacita,
              background: background,
            ),
          ),
        )
        .toList();

    final personaggio = Personaggio(
      nome: _nomeController.text.trim(),
      anni: int.tryParse(_anniController.text.trim()) ?? 0,
      genere: genere,
      razza: razza,
      sistemaDiOrigine: sistema,
      pianetaDiOrigine: pianeta,
      background: background,
      caratteristiche: caratteristiche,
      abilita: abilita,
      talenti: talenti,
      capacita: capacita,
      tag: tagDelPersonaggio(
        razza: razza,
        sistema: sistema,
        pianeta: pianeta,
        background: background,
        capacita: capacita,
        talenti: talenti,
      ),
      pxDisponibili: _pxDisponibili,
      poteriPsionici: _poteriPsionici,
      // Lesioni, Mutazioni e Corruzione non si toccano da qui: in
      // Creazione partono vuote, e in Modifica vanno riportate tali e
      // quali dal personaggio di partenza. Ricostruire il Personaggio da
      // zero senza di loro le cancellerebbe, insieme ai bonus che le
      // Mutazioni portano.
      lesioniMemorabili: iniziale?.lesioniMemorabili ?? const [],
      lesioniTraumatiche: iniziale?.lesioniTraumatiche ?? const [],
      mutazioni: mutazioni,
      corruzione: iniziale?.corruzione ?? 0,
    );

    // Torna alla Home passando il personaggio appena creato, così la
    // Home potrà aggiungerlo alla lista dei personaggi salvati.
    Navigator.of(context).pop(personaggio);
  }

  String _titoloPagina(int indice) {
    final titolo = switch (indice) {
      0 => 'Dati generali',
      1 => 'Gestione Punti Esperienza',
      _ => 'Riepilogo',
    };
    final prefisso = _inModifica ? 'Modifica' : 'Crea';
    return '$prefisso - $titolo';
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
        title: Text(_titoloPagina(_currentPage)),
      ),
      // PageView.builder invece di PageView(children: [...]): costruisce
      // solo la pagina effettivamente necessaria invece di ricreare tutte
      // e 3 le sotto-pagine a ogni setState (es. un singolo +/- in
      // Pagina 2 altrimenti ricostruiva anche Pagina 1 e Pagina 3).
      // Come in Scheda: i bottoni Avanti/CREA stanno in fondo alla
      // pagina, e senza questo margine finiscono sotto ai tasti di
      // sistema del telefono.
      body: SafeArea(
        top: false,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // navigazione solo tramite bottoni
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: 3,
          itemBuilder: (context, indice) => switch (indice) {
            0 => Pagina1InfoGenerali(
              nomeController: _nomeController,
              anniController: _anniController,
              razzaSelezionata: _razzaSelezionata,
              genereSelezionato: _genereSelezionato,
              backgroundSelezionato: _backgroundSelezionato,
              sistemaSelezionato: _sistemaSelezionato,
              pianetaSelezionato: _pianetaSelezionato,
              // La tendina avvisa anche quando si riprende la voce già
              // scelta: senza i controlli sull'uguaglianza, riaprirla
              // cancellerebbe le capacità che ne dipendono.
              onRazzaChanged: (v) => _cambiaScelta(() {
                if (v == _razzaSelezionata) return;
                _razzaSelezionata = v;
                // Cambiando razza, le Capacità di Razza vanno riscelte.
                _capacitaRazzaSelezionate.fillRange(
                  0,
                  capacitaRazzaDaScegliere,
                  null,
                );
              }),
              onGenereChanged: (v) => setState(() => _genereSelezionato = v),
              // La Capacità di Background segue da sola il background.
              onBackgroundChanged: (v) =>
                  _cambiaScelta(() => _backgroundSelezionato = v),
              onSistemaChanged: (v) => _cambiaScelta(() {
                if (v == _sistemaSelezionato) return;
                _sistemaSelezionato = v;
                // Cambiando sistema, pianeta e Capacità di Sistema e del
                // Pianeta vanno reimpostati.
                _pianetaSelezionato = null;
                _capacitaSistemaSelezionata = null;
                _capacitaPianetaSelezionata = null;
              }),
              onPianetaChanged: (v) => _cambiaScelta(() {
                if (v == _pianetaSelezionato) return;
                _pianetaSelezionato = v;
                _capacitaPianetaSelezionata = null;
              }),
              onAvanti: _vaiAPagina2,
            ),
            1 => Pagina2GestioneEsperienza(
              pxDisponibili: _pxDisponibili,
              onModificaPx: _mostraDialogModificaPx,
              valoriCaratteristiche: _valoriCaratteristiche,
              onAumentaCaratteristica: _aumentaCaratteristica,
              onDiminuisciCaratteristica: _diminuisciCaratteristica,
              valoriAbilita: _valoriAbilita,
              onAumentaAbilita: _aumentaAbilita,
              onDiminuisciAbilita: _diminuisciAbilita,
              talentoSelezionato: _talentoSelezionato,
              onTalentoChanged: (v) =>
                  _cambiaScelta(() => _talentoSelezionato = v),
              razzaSelezionata: _razzaSelezionata,
              sistemaSelezionato: _sistemaSelezionato,
              pianetaSelezionato: _pianetaSelezionato,
              backgroundSelezionato: _backgroundSelezionato,
              capacitaRazzaSelezionate: _capacitaRazzaSelezionate,
              onCapacitaRazzaChanged: (indice, v) =>
                  _cambiaScelta(() => _capacitaRazzaSelezionate[indice] = v),
              capacitaSistemaSelezionata: _capacitaSistemaSelezionata,
              onCapacitaSistemaChanged: (v) =>
                  _cambiaScelta(() => _capacitaSistemaSelezionata = v),
              capacitaPianetaSelezionata: _capacitaPianetaSelezionata,
              onCapacitaPianetaChanged: (v) =>
                  _cambiaScelta(() => _capacitaPianetaSelezionata = v),
              capacitaGenericheSelezionate: _capacitaGenericheSelezionate,
              onCapacitaGenericaChanged: _onCapacitaGenericaSelezionata,
              onCapacitaGenericaRimossa: _rimuoviCapacitaGenerica,
              puoScegliereePoteriPsionici: _puoScegliereePoteriPsionici,
              poteriPsioniciSelezionati: _poteriPsioniciSelezionati,
              onPoterePsionicoChanged: _onPoterePsionicoSelezionato,
              onPoterePsionicoRimosso: _rimuoviPoterePsionico,
              onIndietro: _tornaAPagina1,
              onRiepilogo: _vaiARiepilogo,
            ),
            _ => Pagina3Riepilogo(
              nome: _nomeController.text,
              razza: _razzaSelezionata ?? '-',
              anni: _anniController.text,
              genere: _genereSelezionato ?? '-',
              background: _backgroundSelezionato ?? '-',
              sistemaOrigine: _sistemaSelezionato ?? '-',
              pianetaOrigine: _pianetaSelezionato ?? '-',
              pxDisponibili: _pxDisponibili,
              valoriCaratteristiche: _valoriCaratteristiche,
              valoriAbilita: _valoriAbilita,
              talentoSelezionato: _talentoSelezionato,
              capacitaRazzaSelezionate: _capacitaRazzaSelezionate,
              capacitaSistemaSelezionata: _capacitaSistemaSelezionata,
              capacitaPianetaSelezionata: _capacitaPianetaSelezionata,
              capacitaBackground: capacitaDiBackground(_backgroundSelezionato),
              capacitaGeneriche: _capacitaGenericheSelezionate
                  .whereType<String>()
                  .toList(),
              poteriPsionici: _poteriPsionici.map((p) => p.nome).toList(),
              onIndietro: _tornaAPagina2,
              onCrea: _creaPersonaggio,
              etichettaBottoneCrea: _inModifica ? 'SALVA' : 'CREA',
            ),
          },
        ),
      ),
    );
  }
}
