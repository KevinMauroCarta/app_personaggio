import 'package:flutter/material.dart';

import '../../widgets/sezione_collassabile.dart';
import 'creazione_pg_dati.dart';
import 'creazione_pg_widgets.dart';
import 'dettagli_modelli.dart';

/// Contenuto della Pagina 2 (Gestione Esperienza) del flusso di
/// creazione del personaggio: PX, caratteristiche, abilità, talento e
/// capacità (di Razza, di Sistema, di Background, Generiche).
///
/// È un widget "stupido": riceve i valori attuali e notifica i
/// cambiamenti tramite callback al widget che lo usa
/// (CharacterCreationPage).
class Pagina2GestioneEsperienza extends StatelessWidget {
  final int pxDisponibili;
  final VoidCallback onModificaPx;

  final Map<String, int> valoriCaratteristiche;
  final void Function(String nome) onAumentaCaratteristica;
  final void Function(String nome) onDiminuisciCaratteristica;

  final Map<String, int> valoriAbilita;
  final void Function(String nome) onAumentaAbilita;
  final void Function(String nome) onDiminuisciAbilita;

  final String? talentoSelezionato;
  final ValueChanged<String?> onTalentoChanged;

  /// Razza, sistema e background scelti in Pagina 1: servono per
  /// filtrare le Capacità di Razza/Sistema/Background disponibili.
  final String? razzaSelezionata;
  final String? sistemaSelezionato;
  final String? backgroundSelezionato;

  final String? capacitaRazzaSelezionata;
  final ValueChanged<String?> onCapacitaRazzaChanged;

  final String? capacitaSistemaSelezionata;
  final ValueChanged<String?> onCapacitaSistemaChanged;

  final String? capacitaBackgroundSelezionata;
  final ValueChanged<String?> onCapacitaBackgroundChanged;

  /// Ogni elemento rappresenta un campo Capacità Generica (dropdown).
  final List<String?> capacitaGenericheSelezionate;
  final void Function(int indice, String? valore) onCapacitaGenericaChanged;

  /// Rimuove (azzera) il campo Capacità Generica all'indice indicato,
  /// tramite il bottone "X" a fianco del dropdown.
  final void Function(int indice) onCapacitaGenericaRimossa;

  /// I Poteri Psionici si possono scegliere solo se il personaggio ha il
  /// Tag Psionico: se è false la sezione resta visibile ma sbiadita e
  /// non toccabile (vedi _buildSezionePoteriPsionici).
  final bool puoScegliereePoteriPsionici;
  final List<String?> poteriPsioniciSelezionati;
  final void Function(int indice, String? valore) onPoterePsionicoChanged;
  final void Function(int indice) onPoterePsionicoRimosso;

  final VoidCallback onIndietro;
  final VoidCallback onRiepilogo;

  const Pagina2GestioneEsperienza({
    super.key,
    required this.pxDisponibili,
    required this.onModificaPx,
    required this.valoriCaratteristiche,
    required this.onAumentaCaratteristica,
    required this.onDiminuisciCaratteristica,
    required this.valoriAbilita,
    required this.onAumentaAbilita,
    required this.onDiminuisciAbilita,
    required this.talentoSelezionato,
    required this.onTalentoChanged,
    required this.razzaSelezionata,
    required this.sistemaSelezionato,
    required this.backgroundSelezionato,
    required this.capacitaRazzaSelezionata,
    required this.onCapacitaRazzaChanged,
    required this.capacitaSistemaSelezionata,
    required this.onCapacitaSistemaChanged,
    required this.capacitaBackgroundSelezionata,
    required this.onCapacitaBackgroundChanged,
    required this.capacitaGenericheSelezionate,
    required this.onCapacitaGenericaChanged,
    required this.onCapacitaGenericaRimossa,
    required this.puoScegliereePoteriPsionici,
    required this.poteriPsioniciSelezionati,
    required this.onPoterePsionicoChanged,
    required this.onPoterePsionicoRimosso,
    required this.onIndietro,
    required this.onRiepilogo,
  });

  @override
  Widget build(BuildContext context) {
    final capacitaRazzaDisponibili = razzaSelezionata == null
        ? const <String>[]
        : (capacitaRazzaOptions[razzaSelezionata] ?? const <String>[]);

    final capacitaSistemaDisponibili = sistemaSelezionato == null
        ? const <String>[]
        : (capacitaSistemaOptions[sistemaSelezionato] ?? const <String>[]);

    final capacitaBackgroundDisponibili = backgroundSelezionato == null
        ? const <String>[]
        : (capacitaBackgroundOptions[backgroundSelezionato] ??
              const <String>[]);

    // I Punti Esperienza restano visibili in fondo alla pagina anche
    // scorrendo: il contenuto scorre dentro l'Expanded, la barra PX no.
    return Column(
      children: [
        Expanded(
          child: _buildContenuto(
            capacitaRazzaDisponibili,
            capacitaSistemaDisponibili,
            capacitaBackgroundDisponibili,
          ),
        ),
        _buildBarraPx(context),
      ],
    );
  }

  /// Barra dei Punti Esperienza, ancorata al fondo della pagina. Quando i
  /// PX vanno in negativo (l'aumento non è più bloccato, vedi
  /// [_buildRigaValore]) il valore diventa rosso.
  Widget _buildBarraPx(BuildContext context) {
    final inNegativo = pxDisponibili < 0;

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
                  'Punti Esperienza disponibili: $pxDisponibili',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: inNegativo ? Colors.red : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle),
                tooltip: 'Aggiungi o sottrai PX',
                onPressed: onModificaPx,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContenuto(
    List<String> capacitaRazzaDisponibili,
    List<String> capacitaSistemaDisponibili,
    List<String> capacitaBackgroundDisponibili,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  valore: valoriCaratteristiche[nome]!,
                  valoreMinimo: caratteristicaValoreIniziale,
                  valoreMassimo: caratteristicaValoreMassimo,
                  costo: costoCaratteristica,
                  onAumenta: () => onAumentaCaratteristica(nome),
                  onDiminuisci: () => onDiminuisciCaratteristica(nome),
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
                final valoreAttuale = valoriAbilita[nome]!;
                // Nessun blocco: la restrizione di Avanzamento/Abilità si
                // può violare liberamente, l'abilità fuori regola viene
                // solo segnalata in rosso.
                final fuoriRegola = abilitaViolaRestrizione(
                  valoriAbilita,
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
                  valoreMinimo: abilitaValoreIniziale,
                  valoreMassimo: abilitaValoreMassimo,
                  costo: costoAbilita,
                  fuoriRegola: fuoriRegola,
                  motivoFuoriRegola:
                      'Servono almeno $valoreAttuale abilità apprese per '
                      'tenere questa abilità a $valoreAttuale',
                  onAumenta: () => onAumentaAbilita(nome),
                  onDiminuisci: () => onDiminuisciAbilita(nome),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          SezioneCollassabile(
            titolo: 'Talenti e Capacità',
            figli: [
              _sottoSezione(
                titolo: 'Talento',
                figli: [
                  DropdownConDettagli(
                    label: 'Talento',
                    valoreSelezionato: talentoSelezionato,
                    opzioni: talentiOptions,
                    descrizioni: talentiDescrizioni,
                    contenutoInfo: (opzioni) =>
                        DettagliTalento(talenti: talentiDaNomi(opzioni)),
                    onChanged: onTalentoChanged,
                  ),
                ],
              ),
              _sottoSezione(
                titolo: 'Capacità di Razza',
                figli: [
                  if (razzaSelezionata == null)
                    const Text('Seleziona prima una razza in Pagina 1.')
                  else
                    DropdownConDettagli(
                      label: 'Capacità di Razza',
                      valoreSelezionato: capacitaRazzaSelezionata,
                      opzioni: capacitaRazzaDisponibili,
                      descrizioni: {
                        for (final c in capacitaRazzaDisponibili)
                          c: descrizionePlaceholder(c),
                      },
                      etichetteSecondarie: capacitaCosti,
                      contenutoInfo: (opzioni) =>
                          DettagliCapacita(capacita: capacitaDaNomi(opzioni)),
                      onChanged: onCapacitaRazzaChanged,
                    ),
                ],
              ),
              _sottoSezione(
                titolo: 'Capacità di Sistema',
                figli: [
                  if (sistemaSelezionato == null)
                    const Text(
                      'Seleziona prima un sistema di origine in Pagina 1.',
                    )
                  else
                    DropdownConDettagli(
                      label: 'Capacità di Sistema',
                      valoreSelezionato: capacitaSistemaSelezionata,
                      opzioni: capacitaSistemaDisponibili,
                      descrizioni: {
                        for (final c in capacitaSistemaDisponibili)
                          c: descrizioneCapacita(c),
                      },
                      etichetteSecondarie: capacitaCosti,
                      contenutoInfo: (opzioni) =>
                          DettagliCapacita(capacita: capacitaDaNomi(opzioni)),
                      onChanged: onCapacitaSistemaChanged,
                    ),
                ],
              ),
              _sottoSezione(
                titolo: 'Capacità di Background',
                figli: [
                  if (backgroundSelezionato == null)
                    const Text('Seleziona prima un background in Pagina 1.')
                  else
                    DropdownConDettagli(
                      label: 'Capacità di Background',
                      valoreSelezionato: capacitaBackgroundSelezionata,
                      opzioni: capacitaBackgroundDisponibili,
                      descrizioni: {
                        for (final c in capacitaBackgroundDisponibili)
                          c: descrizioneCapacita(c),
                      },
                      etichetteSecondarie: capacitaCosti,
                      contenutoInfo: (opzioni) =>
                          DettagliCapacita(capacita: capacitaDaNomi(opzioni)),
                      onChanged: onCapacitaBackgroundChanged,
                    ),
                ],
              ),
              _sottoSezione(
                titolo: 'Capacità Generiche',
                figli: _buildCampiCapacitaGeneriche(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSezionePoteriPsionici(),
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
                  onPressed: onRiepilogo,
                  child: const Text('Riepilogo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sezione annidata dentro "Talenti e Capacità": titolo più piccolo e
  /// rientro per rendere visibile la gerarchia.
  ///
  /// A differenza delle sezioni principali NON è collassabile: a
  /// collassare è già "Talenti e Capacità" che le contiene, e ognuna di
  /// queste sottosezioni ha un solo campo dentro.
  Widget _sottoSezione({required String titolo, required List<Widget> figli}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titolo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...figli,
        ],
      ),
    );
  }

  /// Riga con nome (+ eventuale sottotitolo), Pulsante Info, bottone "-",
  /// valore, bottone "+". Usata sia per le Caratteristiche sia per le
  /// Abilità.
  ///
  /// I bottoni non applicano più nessun blocco oltre ai limiti di valore
  /// (Avanzamento/Caratteristiche, Avanzamento/Abilità): si può aumentare
  /// anche senza avere i PE (che vanno in negativo, segnalati in rosso
  /// nella barra in fondo alla pagina) e si può diminuire liberamente.
  /// Quando il risultato viola una regola, la riga viene segnalata in
  /// rosso tramite [fuoriRegola] invece di impedire l'operazione.
  Widget _buildRigaValore({
    required String nome,
    required String descrizione,
    String? sottotitolo,
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
                if (sottotitolo != null)
                  Text(
                    sottotitolo,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
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

  /// Costruisce la lista dinamica dei campi Capacità Generica: ogni
  /// dropdown esclude i valori già scelti negli altri campi, così non
  /// è possibile selezionare due volte la stessa capacità. Quando
  /// l'ultimo campo viene compilato (e ci sono ancora opzioni libere)
  /// ne viene aggiunto uno nuovo. Il bottone "X" permette di rimuovere
  /// la selezione corrente.
  List<Widget> _buildCampiCapacitaGeneriche() {
    return List.generate(capacitaGenericheSelezionate.length, (indice) {
      final valoreCorrente = capacitaGenericheSelezionate[indice];

      // Valori scelti negli ALTRI campi (non in questo), da escludere
      // dalle opzioni di questo dropdown.
      final scelteAltrove = capacitaGenericheSelezionate
          .whereIndexed((i, v) => i != indice && v != null)
          .cast<String>()
          .toSet();

      final opzioniDisponibili = capacitaGenericheOptions
          .where((o) => !scelteAltrove.contains(o))
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DropdownConDettagli(
          label: 'Capacità Generica ${indice + 1}',
          valoreSelezionato: valoreCorrente,
          opzioni: opzioniDisponibili,
          descrizioni: {
            for (final c in opzioniDisponibili) c: descrizioneCapacita(c),
          },
          etichetteSecondarie: capacitaCosti,
          contenutoInfo: (opzioni) =>
              DettagliCapacita(capacita: capacitaDaNomi(opzioni)),
          onChanged: (valore) => onCapacitaGenericaChanged(indice, valore),
          onRimuovi: () => onCapacitaGenericaRimossa(indice),
          infoSoloOpzioneSelezionata: true,
        ),
      );
    });
  }

  /// Sezione dei Poteri Psionici.
  ///
  /// Senza il Tag Psionico la sezione resta comunque a schermo, ma
  /// sbiadita, chiusa e insensibile al tocco: così si vede che esiste - e
  /// il sottotitolo dice come sbloccarla - invece di sparire senza
  /// lasciare traccia di una scelta possibile.
  ///
  /// Chiusa e non apribile è voluto: i poteri non spettano più al
  /// personaggio, quindi non devono nemmeno restare in vista. La [Key]
  /// legata al tag serve proprio a questo: cambiando, Flutter ricrea la
  /// sezione da zero invece di riusarla con lo stato di apertura che
  /// aveva prima.
  Widget _buildSezionePoteriPsionici() {
    final sezione = SezioneCollassabile(
      key: ValueKey('poteri-psionici-$puoScegliereePoteriPsionici'),
      titolo: 'Poteri Psionici',
      apertaIniziale: puoScegliereePoteriPsionici,
      sottotitolo: puoScegliereePoteriPsionici
          ? 'Disponibili perché una delle scelte fatte ha dato al '
                'personaggio il tag Psionico.'
          : 'Per sceglierli serve il tag Psionico: lo danno alcuni '
                'Talenti e alcune Capacità.',
      figli: [const SizedBox(height: 8), ..._buildCampiPoteriPsionici()],
    );

    if (puoScegliereePoteriPsionici) return sezione;

    return Opacity(opacity: 0.4, child: IgnorePointer(child: sezione));
  }

  /// Campi di scelta dei Poteri Psionici: stesso comportamento delle
  /// Capacità Generiche (un campo libero in coda finché restano poteri
  /// non scelti, "X" per togliere quello selezionato). I poteri non
  /// costano PE: Modello/Potere_Psionico non ha un campo costo.
  List<Widget> _buildCampiPoteriPsionici() {
    return List.generate(poteriPsioniciSelezionati.length, (indice) {
      final valoreCorrente = poteriPsioniciSelezionati[indice];

      final scelteAltrove = poteriPsioniciSelezionati
          .whereIndexed((i, v) => i != indice && v != null)
          .cast<String>()
          .toSet();

      final opzioniDisponibili = poteriPsioniciOptions
          .where((o) => !scelteAltrove.contains(o))
          .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DropdownConDettagli(
          label: 'Potere Psionico ${indice + 1}',
          valoreSelezionato: valoreCorrente,
          opzioni: opzioniDisponibili,
          descrizioni: {
            for (final p in opzioniDisponibili) p: descrizionePoterePsionico(p),
          },
          contenutoInfo: (opzioni) =>
              DettagliPoterePsionico(poteri: poteriPsioniciDaNomi(opzioni)),
          etichetteSecondarie: poteriPsioniciCosti,
          onChanged: (valore) => onPoterePsionicoChanged(indice, valore),
          onRimuovi: () => onPoterePsionicoRimosso(indice),
          infoSoloOpzioneSelezionata: true,
        ),
      );
    });
  }
}

/// Piccola estensione di utilità per iterare con indice e filtro (segue)
/// insieme, usata in [Pagina2GestioneEsperienza._buildCampiCapacitaGeneriche].
extension _WhereIndexed<T> on List<T> {
  Iterable<T> whereIndexed(bool Function(int index, T value) test) sync* {
    for (var i = 0; i < length; i++) {
      if (test(i, this[i])) yield this[i];
    }
  }
}
