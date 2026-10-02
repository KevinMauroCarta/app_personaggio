import 'package:flutter/material.dart';

import '../../enums/abilita_arma.dart';
import '../../enums/densita_popolativa.dart';
import '../../enums/grandezza_pianeta.dart';
import '../../enums/rarita.dart';
import '../../enums/taglia.dart';
import '../../enums/scuola_psionica.dart';
import '../../enums/tipo_azione.dart';
import '../../enums/tipo_danno.dart';
import '../../enums/tipologia_pianeta.dart';
import '../../models/armi/arma.dart';
import '../../models/armi/arma_distanza.dart';
import '../../models/armatura.dart';
import '../../models/background.dart';
import '../../models/capacita.dart';
import '../../models/pianeta.dart';
import '../../models/potere_psionico.dart';
import '../../models/razza.dart';
import '../../models/talento.dart';
import '../../models/tratto.dart';
import '../../models/sistema.dart';
import '../../widgets/sezione_collassabile.dart';
import 'creazione_pg_widgets.dart';

/// Contenuti dei Pulsanti Info della Pagina 1 (Info Generali).
///
/// A differenza di [DettagliOpzioni], che mostra solo nome e descrizione,
/// qui viene riportato il modello completo del campo: tutti i campi di
/// Modello/Razza, Modello/Background, Modello/Sistema e Modello/Pianeta.
///
/// Le Capacità non vengono appiattite in una riga di testo ma restano
/// cliccabili: toccandone una si apre un secondo dialog con i suoi
/// dettagli ([DettagliCapacita]), senza uscire dalle info del campo.
///
/// Ogni elemento è una sezione collassabile: il dialog si apre mostrando
/// solo l'elenco dei nomi, e si apre una voce alla volta. Quando però
/// l'elemento è uno solo non c'è niente da scegliere, e parte già aperto.

/// Modello/Razza per intero.
class DettagliRazza extends StatelessWidget {
  final List<Razza> razze;

  const DettagliRazza({super.key, required this.razze});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: razze
          .map(
            (r) => _SchedaModello(
              titolo: r.nome,
              campi: [
                _Campo('Descrizione', r.descrizione),
                _Campo('Tag', r.tag),
                _Campo('Taglia', r.taglia.label),
              ],
              capacita: r.capacita,
              etichettaCapacita: 'Capacità di Razza',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Background per intero.
class DettagliBackground extends StatelessWidget {
  final List<Background> background;

  const DettagliBackground({super.key, required this.background});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: background
          .map(
            (b) => _SchedaModello(
              titolo: b.nome,
              campi: [
                _Campo('Descrizione', b.descrizione),
                _Campo('Tag', b.tag),
                for (final m in b.modificatori) _Campo('Modificatore', m.testo),
              ],
              capacita: [b.capacitaDiBackground],
              etichettaCapacita: 'Capacità di Background',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Sistema per intero.
class DettagliSistema extends StatelessWidget {
  final List<Sistema> sistemi;

  const DettagliSistema({super.key, required this.sistemi});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: sistemi
          .map(
            (s) => _SchedaModello(
              titolo: s.nome,
              campi: [
                _Campo('Governo', s.governo),
                _Campo('Tag', s.tag),
                _Campo('Mappa', s.mappaAssetPath ?? 'non disponibile'),
                _Campo(
                  'Pianeti',
                  s.pianeti.isEmpty
                      ? '-'
                      : s.pianeti.map((p) => p.nome).join(', '),
                ),
              ],
              capacita: s.capacitaDelSistema,
              etichettaCapacita: 'Capacità di Sistema',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Pianeta per intero.
class DettagliPianeta extends StatelessWidget {
  final List<Pianeta> pianeti;

  const DettagliPianeta({super.key, required this.pianeti});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: pianeti
          .map(
            (p) => _SchedaModello(
              titolo: p.nome,
              campi: [
                _Campo('Grandezza', p.grandezza.label),
                _Campo('Tipologia', p.tipologia.label),
                _Campo('Capitale', p.capitale),
                _Campo('Densità popolativa', p.densitaPopolativa.label),
                _Campo('Luna', p.luna ? 'Sì' : 'No'),
                if (p.lune.isNotEmpty)
                  _Campo('Lune', p.lune.map((l) => l.nome).join(', ')),
                _Campo('Tag', _tag(p.tag)),
              ],
              capacita: p.capacitaDelPianeta,
              etichettaCapacita: 'Capacità del Pianeta',
            ),
          )
          .toList(),
    );
  }
}

/// Coppia etichetta/valore di un campo del modello.
class _Campo {
  final String etichetta;
  final String valore;

  const _Campo(this.etichetta, this.valore);
}

/// Elenco di elementi collassabili. [_SchedaModello] riceve da qui se
/// partire aperto: con un solo elemento non ha senso tenerlo chiuso.
class _Elenco extends StatelessWidget {
  final List<_SchedaModello> children;

  const _Elenco({required this.children});

  @override
  Widget build(BuildContext context) {
    final unicoElemento = children.length == 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final scheda in children) scheda.conApertura(unicoElemento),
      ],
    );
  }
}

/// Una voce dell'elenco: una sezione collassabile col nome dell'elemento
/// come intestazione e, dentro, tutti i campi del modello e le sue
/// Capacità come pulsanti cliccabili.
class _SchedaModello extends StatelessWidget {
  final String titolo;
  final List<_Campo> campi;
  final List<Capacita> capacita;
  final String etichettaCapacita;
  final bool aperta;

  const _SchedaModello({
    required this.titolo,
    required this.campi,
    required this.capacita,
    required this.etichettaCapacita,
    this.aperta = false,
  });

  _SchedaModello conApertura(bool aperta) => _SchedaModello(
    titolo: titolo,
    campi: campi,
    capacita: capacita,
    etichettaCapacita: etichettaCapacita,
    aperta: aperta,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SezioneCollassabile(
        titolo: titolo,
        apertaIniziale: aperta,
        stileTitolo: const TextStyle(fontWeight: FontWeight.bold),
        figli: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _contenuto(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _contenuto(BuildContext context) {
    return [
      ...campi.map(
        (c) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '${c.etichetta}: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: c.valore.isEmpty ? '-' : c.valore),
              ],
            ),
          ),
        ),
      ),
      // Gli elementi che non hanno Capacità collegate (es. i Poteri
      // Psionici) non mostrano nemmeno l'etichetta.
      if (etichettaCapacita.isEmpty)
        const SizedBox.shrink()
      else ...[
        const SizedBox(height: 6),
        Text(
          '$etichettaCapacita:',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (capacita.isEmpty)
          const Text('-')
        else
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: capacita
                .map((c) => _CapacitaCliccabile(capacita: c))
                .toList(),
          ),
      ],
    ];
  }
}

/// Nome di una Capacità che, toccato, apre i dettagli della capacità
/// sopra le info del campo, così da poterli leggere senza perdere il
/// punto in cui si era.
class _CapacitaCliccabile extends StatelessWidget {
  final Capacita capacita;

  const _CapacitaCliccabile({required this.capacita});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.info_outline, size: 18),
      label: Text(capacita.nome),
      onPressed: () => showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Capacità'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: DettagliCapacita(capacita: [capacita]),
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

/// Modello/Potere_Psionico per intero, per il Pulsante Info della
/// sezione Poteri Psionici. Stessa forma collassabile degli altri
/// dettagli, senza Capacità collegate.
class DettagliPoterePsionico extends StatelessWidget {
  final List<PoterePsionico> poteri;

  const DettagliPoterePsionico({super.key, required this.poteri});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: poteri
          .map(
            (p) => _SchedaModello(
              titolo: p.nome,
              campi: [
                _Campo('Scuola', p.scuola.label),
                _Campo('CD', '${p.cd}'),
                _Campo('Attivazione', p.attivazione.label),
                _Campo('Durata', p.durata.etichetta),
                _Campo('Gittata', '${p.gittata}'),
                _Campo('Bersagli', p.multiBersaglio ? 'Multipli' : 'Uno'),
                _Campo('Costo', '${p.costo}'),
                _Campo('Descrizione', p.descrizione),
                _Campo('Effetto', p.effetto),
                if (p.potenziamento1 != null)
                  _Campo('Potenziamento 1', p.potenziamento1!.nome),
                if (p.potenziamento2 != null)
                  _Campo('Potenziamento 2', p.potenziamento2!.nome),
              ],
              capacita: const [],
              etichettaCapacita: '',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Talento per intero, per il Pulsante Info della sezione
/// Talento. Stessa forma collassabile degli altri dettagli; il modello
/// non prevede Capacità collegate.
class DettagliTalento extends StatelessWidget {
  final List<Talento> talenti;

  const DettagliTalento({super.key, required this.talenti});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: talenti
          .map(
            (t) => _SchedaModello(
              titolo: t.nome,
              campi: [
                _Campo('Descrizione', t.descrizione),
                _Campo('Effetto', t.effetto),
                _Campo('Tag', t.tag),
              ],
              capacita: const [],
              etichettaCapacita: '',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Arma per intero. La Riserva di Dadi non compare: non è un
/// attributo dell'arma ma un valore del personaggio (Scheda.riservaDiDadi).
class DettagliArma extends StatelessWidget {
  final List<Arma> armi;

  const DettagliArma({super.key, required this.armi});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: armi
          .map(
            (a) => _SchedaModello(
              titolo: a.nome,
              campi: [
                _Campo('Tipo', a.descrizioneTipo),
                _Campo('Danno', '${a.danno}'),
                _Campo('Tipo Danno', a.tipoDanno.label),
                _Campo('Dadi Extra', '${a.dadiExtra}'),
                _Campo('Valore Penetrazione', '${a.valorePenetrazione}'),
                _Campo('Gittata', a.etichettaGittata),
                // La Raffica esiste solo sulle armi a distanza: sulle
                // altre la riga non compare, invece di dire "No".
                if (a is ArmaDistanza)
                  _Campo('Raffica', a.raffica ? 'Sì' : 'No'),
                _Campo('Abilità', a.abilitaAssociata.nomeAbilita),
                _Campo('Valore', '${a.valore}'),
                _Campo('Rarità', a.rarita.label),
                _Campo('Tratti', _tratti(a.tratti)),
                _Campo('Tag', _tag(a.tag)),
              ],
              capacita: const [],
              etichettaCapacita: '',
            ),
          )
          .toList(),
    );
  }
}

/// Modello/Armatura per intero.
class DettagliArmatura extends StatelessWidget {
  final List<Armatura> armature;

  const DettagliArmatura({super.key, required this.armature});

  @override
  Widget build(BuildContext context) {
    return _Elenco(
      children: armature
          .map(
            (a) => _SchedaModello(
              titolo: a.nome,
              campi: [
                _Campo('PA', '${a.pa}'),
                _Campo('PA Energia', '${a.paEnergia}'),
                _Campo('Tratti', _tratti(a.tratti)),
                _Campo('Tag', _tag(a.tag)),
              ],
              capacita: const [],
              etichettaCapacita: '',
            ),
          )
          .toList(),
    );
  }
}

String _tratti(List<Tratto> tratti) =>
    tratti.isEmpty ? '-' : tratti.map((t) => t.nome).join(', ');

String _tag(List<String> tag) => tag.isEmpty ? '-' : tag.join(', ');
