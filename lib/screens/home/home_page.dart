import 'package:flutter/material.dart';

import '../../models/personaggio.dart';
import '../../models/scheda.dart';
import '../../services/character_storage.dart';
import '../../services/effetti_personaggio.dart';
import '../../versione_app.dart';
import '../../widgets/sezione_collassabile.dart';
import '../creazione_pg/creazione_pg_page.dart';
import '../scheda/scheda_page.dart';
import '../modifica_pg/modifica_pg_page.dart';
import '../aumento_pg/aumento_pg_page.dart';

/// APP/Pagina/Home
///
/// La Home è divisa in sezioni collassabili, così da poterne aggiungere
/// altre senza rifare il layout:
/// - "Personaggi": i personaggi salvati come pulsanti quadrati con il
///   nome all'interno, e come ultimo elemento della griglia il pulsante
///   "Crea Personaggio";
/// - "Regolamento" e "Ambientazione": ancora vuote, il posto è solo
///   prenotato.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterStorage _storage = CharacterStorage();

  List<Scheda> _schede = [];
  bool _caricamento = true;

  @override
  void initState() {
    super.initState();
    _caricaSchede();
  }

  Future<void> _caricaSchede() async {
    final schede = await _storage.caricaSchede();
    setState(() {
      _schede = schede;
      _caricamento = false;
    });
  }

  Future<void> _vaiACreazionePersonaggio() async {
    final nuovoPersonaggio = await Navigator.of(context).push<Personaggio>(
      MaterialPageRoute(builder: (context) => const CharacterCreationPage()),
    );

    if (nuovoPersonaggio != null) {
      final nuovaScheda = Scheda(personaggio: nuovoPersonaggio);
      await _storage.aggiungiScheda(nuovaScheda);
      setState(() {
        _schede.add(nuovaScheda);
      });
    }
  }

  /// Mostra il menu di scelta Scheda/Modifica/Aumento/Elimina per il
  /// personaggio all'[indice] indicato, come da documento APP/Pagina/Home.
  void _mostraSceltaPersonaggio(int indice) {
    final personaggio = _schede[indice].personaggio;
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  personaggio.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Scheda'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _vaiAScheda(indice);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Modifica'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _vaiAModifica(indice);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Aumento'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _vaiAAumento(indice);
                },
              ),
              // Ultima voce, e in colore d'errore: è l'unica azione del
              // menu che non si può annullare tornando indietro.
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
                title: Text(
                  'Elimina',
                  style: TextStyle(
                    color: Theme.of(sheetContext).colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _chiediConfermaEliminazione(indice);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Apre la Scheda all'[indice] indicato.
  ///
  /// A differenza di Modifica e Aumento, la Scheda non ha un momento di
  /// "salva ed esci": si aggiorna durante il gioco, quindi ogni modifica
  /// viene salvata sul momento ([SchedaPage.onModificata]). Il salvataggio
  /// all'uscita resta come rete di sicurezza.
  Future<void> _vaiAScheda(int indice) async {
    final schedaAggiornata = await Navigator.of(context).push<Scheda>(
      MaterialPageRoute(
        builder: (_) => SchedaPage(
          scheda: _schede[indice],
          onModificata: (scheda) => _salvaScheda(indice, scheda),
        ),
      ),
    );

    if (schedaAggiornata != null) {
      await _salvaScheda(indice, schedaAggiornata);
    }
  }

  /// Apre Modifica per il personaggio all'[indice] indicato e, se torna
  /// con un [Personaggio] aggiornato (salvataggio, non annullo), lo
  /// sostituisce dentro la scheda, sia in lista sia nello storage.
  Future<void> _vaiAModifica(int indice) async {
    final personaggioAggiornato = await Navigator.of(context).push<Personaggio>(
      MaterialPageRoute(
        builder: (_) =>
            ModificaPgPage(personaggio: _schede[indice].personaggio),
      ),
    );

    if (personaggioAggiornato != null) {
      await _salvaScheda(
        indice,
        _conPersonaggio(_schede[indice], personaggioAggiornato),
      );
    }
  }

  /// [scheda] con dentro [personaggio], tornato da Modifica o Aumento.
  ///
  /// Quelle pagine ricalcolano il Valore Bonus senza gli Impianti, che
  /// stanno nella Scheda e non nel Personaggio: qui si ricalcola con
  /// quelli della scheda, altrimenti dopo un Aumento un chip "Mira +1"
  /// smetterebbe di alzare la Mira.
  Scheda _conPersonaggio(Scheda scheda, Personaggio personaggio) {
    return scheda.copyWith(
      personaggio: conEffettiRicalcolati(
        personaggio,
        impianti: scheda.impianti,
      ),
    );
  }

  /// Apre Aumento per il personaggio all'[indice] indicato e, se torna
  /// con un [Personaggio] aggiornato, lo sostituisce dentro la scheda
  /// (stessa logica di [_vaiAModifica]).
  Future<void> _vaiAAumento(int indice) async {
    final personaggioAggiornato = await Navigator.of(context).push<Personaggio>(
      MaterialPageRoute(
        builder: (_) => AumentoPgPage(personaggio: _schede[indice].personaggio),
      ),
    );

    if (personaggioAggiornato != null) {
      await _salvaScheda(
        indice,
        _conPersonaggio(_schede[indice], personaggioAggiornato),
      );
    }
  }

  /// Chiede conferma prima di eliminare il personaggio all'[indice]
  /// indicato: la scheda sparisce anche dal salvataggio permanente e non
  /// c'è modo di recuperarla, quindi la domanda non si salta mai.
  Future<void> _chiediConfermaEliminazione(int indice) async {
    final nome = _schede[indice].personaggio.nome;

    final conferma = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Elimina personaggio'),
          content: Text(
            'Vuoi davvero eliminare "$nome"? '
            'L\'operazione non può essere annullata.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (conferma != true || !mounted) return;
    await _eliminaScheda(indice);
  }

  Future<void> _eliminaScheda(int indice) async {
    setState(() {
      _schede.removeAt(indice);
    });
    await _accoda(() => _storage.rimuoviScheda(indice));
  }

  Future<void> _salvaScheda(int indice, Scheda scheda) async {
    setState(() {
      _schede[indice] = scheda;
    });
    await _accoda(() => _storage.aggiornaScheda(indice, scheda));
  }

  /// I salvataggi in coda, uno dopo l'altro.
  ///
  /// La Scheda salva a ogni modifica, anche a ogni tasto battuto in un
  /// campo numerico, e ogni salvataggio rilegge tutte le schede prima di
  /// riscriverle: due sovrapposti leggerebbero lo stesso punto di
  /// partenza e il più lento finirebbe per riscrivere sopra il più
  /// recente. Incatenandoli, l'ultima scrittura è sempre l'ultima
  /// modifica.
  Future<void> _codaSalvataggi = Future.value();

  Future<void> _accoda(Future<void> Function() operazione) {
    _codaSalvataggi = _codaSalvataggi.then((_) => operazione());
    return _codaSalvataggi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      // Ancorata in fondo e non in coda al contenuto: così si legge
      // sempre, anche con la Home piena di personaggi. Serve a sapere
      // quale versione si ha in mano quando si segnala un problema.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          // Una Row e non un Align: qui lo spazio verticale concesso è
          // tutto lo schermo, e Align se lo prenderebbe tutto portando
          // la scritta a metà pagina. La Row invece è alta quanto il
          // testo, e allinea a sinistra di suo.
          child: Row(
            children: [
              Text(
                'version: $versioneApp',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: _caricamento
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSezione('Personaggi', [_buildGriglia()]),
                    const SizedBox(height: 16),
                    _buildSezione('Regolamento // in progress', const [
                      _ContenutoDaFare(),
                    ], apertaIniziale: false),
                    const SizedBox(height: 16),
                    _buildSezione('Ambientazione // in progress', const [
                      _ContenutoDaFare(),
                    ], apertaIniziale: false),
                  ],
                ),
              ),
      ),
    );
  }

  /// Sezione della Home, nello stesso stile delle sezioni della Scheda:
  /// una Card con il titolo che apre e chiude il contenuto.
  ///
  /// La Home è divisa in sezioni per poterne aggiungere altre senza
  /// rifarne il layout: oggi c'è solo "Personaggi", ma Regolamento e
  /// Ambientazione hanno già il loro posto.
  Widget _buildSezione(
    String titolo,
    List<Widget> figli, {
    bool apertaIniziale = true,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SezioneCollassabile(
          titolo: titolo,
          apertaIniziale: apertaIniziale,
          stileTitolo: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          divisore: true,
          figli: figli,
        ),
      ),
    );
  }

  /// Griglia di pulsanti quadrati, tutti della stessa dimensione: prima i
  /// personaggi salvati, poi il pulsante "Crea Personaggio" come ultimo
  /// elemento della lista.
  Widget _buildGriglia() {
    final numeroElementi = _schede.length + 1;

    return GridView.builder(
      // La griglia sta dentro la pagina che scorre: deve occupare
      // l'altezza che le serve e lasciare lo scorrimento a lei, o si
      // ritroverebbero due aree scorrevoli una dentro l'altra.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: numeroElementi,
      itemBuilder: (context, indice) {
        final isPulsanteCreazione = indice == _schede.length;

        if (isPulsanteCreazione) {
          return _PulsanteCreazione(onTap: _vaiACreazionePersonaggio);
        }

        return _PulsantePersonaggio(
          nome: _schede[indice].personaggio.nome,
          onTap: () => _mostraSceltaPersonaggio(indice),
        );
      },
    );
  }
}

/// Contenuto di una sezione della Home ancora da fare. Una sezione che
/// si apre sul vuoto sembra rotta: questa riga dice che il posto è
/// prenotato e che il contenuto arriverà.
class _ContenutoDaFare extends StatelessWidget {
  const _ContenutoDaFare();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Non c\'è ancora niente qui.',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Pulsante quadrato "+" per avviare la creazione di un nuovo personaggio.
class _PulsanteCreazione extends StatelessWidget {
  final VoidCallback onTap;

  const _PulsanteCreazione({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Icon(
            Icons.add,
            size: 36,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Pulsante quadrato con il nome del personaggio, come da documento
/// APP/Pagina/Home.
class _PulsantePersonaggio extends StatelessWidget {
  final String nome;
  final VoidCallback onTap;

  const _PulsantePersonaggio({required this.nome, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              nome,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
