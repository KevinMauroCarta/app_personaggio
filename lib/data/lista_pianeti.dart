import '../enums/grandezza_pianeta.dart';
import '../enums/tipologia_pianeta.dart';
import '../enums/densita_popolativa.dart';
import '../models/pianeta.dart';
import '../models/capacita.dart';
import 'lista_capacita.dart';

Capacita _cap(String nome) => listaCapacita.firstWhere((c) => c.nome == nome);

/// La Capacità del Pianeta legata alla [tipologia]: la offrono tutti i
/// pianeti di quel tipo, accanto alle due che si apprendono su ciascuno.
Capacita capacitaDellaTipologia(TipologiaPianeta tipologia) =>
    _cap(switch (tipologia) {
      TipologiaPianeta.roccioso => 'Ossa di Pietra',
      TipologiaPianeta.gassoso => 'Senso delle Correnti',
      TipologiaPianeta.acquatico => 'Figlio delle Maree',
    });

/// Un pianeta (o una luna) con le sue tre Capacità del Pianeta: per prima
/// quella della [tipologia], che quindi non si scrive a mano e non può
/// non corrispondere, poi le due [capacitaApprese] su quel pianeta.
Pianeta _pianeta({
  required String nome,
  required GrandezzaPianeta grandezza,
  required TipologiaPianeta tipologia,
  required bool luna,
  List<Pianeta> lune = const [],
  required String capitale,
  required DensitaPopolativa densitaPopolativa,
  required List<String> capacitaApprese,
  required List<String> tag,
}) => Pianeta(
  nome: nome,
  grandezza: grandezza,
  tipologia: tipologia,
  luna: luna,
  lune: lune,
  capitale: capitale,
  densitaPopolativa: densitaPopolativa,
  capacitaDelPianeta: [
    capacitaDellaTipologia(tipologia),
    for (final appresa in capacitaApprese) _cap(appresa),
  ],
  tag: tag,
);

/// Lista/Pianeti + Regolamento/Pianeti/Sistema_* (uno per ognuno dei 13
/// sistemi). Raggruppati per sistema di appartenenza.
///
/// Le Capacità del Pianeta apprese sono una proposta scelta sui tag di
/// ciascun pianeta (vedi Lista/Capacità), da rivedere con i dati veri.

final List<Pianeta> pianetiSistemaSolare = [
  _pianeta(
    nome: 'Mercurio',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    capitale: 'Helion',
    luna: false,
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Cercatore di Vene', 'Pelle Arsa'],
    tag: const ['Arido', 'Minerario'],
  ),
  _pianeta(
    nome: 'Venere',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    capitale: 'Virelia',
    luna: false,
    densitaPopolativa: DensitaPopolativa.troppa,
    capacitaApprese: ['Polmoni Temprati', 'Pelle Arsa'],
    tag: const ['Denso', 'Ostile'],
  ),
  _pianeta(
    nome: 'Terra',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    capitale: 'Gaia Prime',
    luna: false,
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Crocevia di Popoli', 'Mediatore Nato'],
    tag: const ['Diversificato', 'Centrale'],
  ),
  _pianeta(
    nome: 'Marte',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    capitale: 'Ares',
    luna: false,
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Spirito Pioniere', 'Pelle Arsa'],
    tag: const ['Coloniale', 'Rosso'],
  ),
  _pianeta(
    nome: 'Giove',
    grandezza: GrandezzaPianeta.gigante,
    tipologia: TipologiaPianeta.gassoso,
    capitale: 'Jovian Hub',
    luna: false,
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Occhio della Tempesta', 'Polmoni Temprati'],
    tag: const ['Tempestoso', 'Massivo'],
  ),
  _pianeta(
    nome: 'Saturno',
    grandezza: GrandezzaPianeta.gigante,
    tipologia: TipologiaPianeta.gassoso,
    capitale: 'Kronos',
    luna: false,
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Etichetta di Corte', 'Occhio della Tempesta'],
    tag: const ['Anelli', 'Elegante'],
  ),
  _pianeta(
    nome: 'Urano',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.gassoso,
    capitale: 'Auralis',
    luna: false,
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Abituato al Gelo', 'Abitudine al Silenzio'],
    tag: const ['Freddo', 'Silenzioso'],
  ),
  _pianeta(
    nome: 'Nettuno',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.gassoso,
    capitale: 'Neryon',
    luna: false,
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Cacciatore nel Buio', 'Viandante'],
    tag: const ['Oscuro', 'Remoto'],
  ),
];

final List<Pianeta> pianetiSistemaAriete = [
  _pianeta(
    nome: 'Pyra',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Pyrion',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Scuola Tattica', 'Pelle Arsa'],
    tag: const ['Militare', 'Ardente'],
  ),
  _pianeta(
    nome: 'Karnis',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Karna',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Scuola Tattica', 'Vita di Regole'],
    tag: const ['Tattico', 'Severo'],
  ),
  _pianeta(
    nome: 'Ophryon',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Ophra City',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Abituato al Gelo', 'Calma degli Abissi'],
    tag: const ['Freddo', 'Silenzioso'],
  ),
];

final List<Pianeta> pianetiSistemaToro = [
  _pianeta(
    nome: 'Bront',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Brontia',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Cercatore di Vene', 'Polmoni Temprati'],
    tag: const ['Minerario', 'Solido'],
  ),
  _pianeta(
    nome: 'Helgor',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Helgor Prime',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Polmoni Temprati', 'Spirito Pioniere'],
    tag: const ['Duro', 'Resistente'],
  ),
  _pianeta(
    nome: 'Tessala',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Tessa',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Calma degli Abissi', 'Mediatore Nato'],
    tag: const ['Calmo', 'Profondo'],
  ),
];

final List<Pianeta> pianetiSistemaGemelli = [
  _pianeta(
    nome: 'Lytha',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Lythos',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Mente Analitica', 'Custode di Segreti'],
    tag: const ['Doppio', 'Logico'],
  ),
  _pianeta(
    nome: 'Coren',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Corenia',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Riflessi Taglienti', 'Cacciatore nel Buio'],
    tag: const ['Rapido', 'Tagliente'],
  ),
  _pianeta(
    nome: 'Virel',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Virelia',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Come l\'Acqua', 'Crocevia di Popoli'],
    tag: const ['Fluido', 'Adattivo'],
  ),
];

final List<Pianeta> pianetiSistemaCancro = [
  _pianeta(
    nome: 'Thalor',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Thalos',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Memoria degli Antichi', 'Vita di Regole'],
    tag: const ['Tradizionale', 'Solido'],
  ),
  _pianeta(
    nome: 'Meryn',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Meryos',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Calma degli Abissi', 'Memoria degli Antichi'],
    tag: const ['Profondo', 'Antico'],
  ),
  _pianeta(
    nome: 'Oros',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Orovia',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Abituato al Gelo', 'Spirito Pioniere'],
    tag: const ['Freddo', 'Isolato'],
  ),
];

final List<Pianeta> pianetiSistemaLeone = [
  _pianeta(
    nome: 'Kael',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Kaelia',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Orgoglio Indomito', 'Scuola Tattica'],
    tag: const ['Dominante', 'Fiero'],
  ),
  _pianeta(
    nome: 'Dravos',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Dravon',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Orgoglio Indomito', 'Etichetta di Corte'],
    tag: const ['Forte', 'Regale'],
  ),
  _pianeta(
    nome: 'Lysara',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Lysaris',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Risonanza Mistica', 'Come l\'Acqua'],
    tag: const ['Mistico', 'Luminoso'],
  ),
];

final List<Pianeta> pianetiSistemaVergine = [
  _pianeta(
    nome: 'Eryon',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    lune: [
      _pianeta(
        nome: 'Eryos I',
        grandezza: GrandezzaPianeta.piccolo,
        tipologia: TipologiaPianeta.roccioso,
        luna: true,
        capitale: 'Eryos I City',
        densitaPopolativa: DensitaPopolativa.poca,
        capacitaApprese: ['Abituato al Gelo', 'Abitudine al Silenzio'],
        tag: const ['Freddo', 'Isolato'],
      ),
      _pianeta(
        nome: 'Eryos II',
        grandezza: GrandezzaPianeta.piccolo,
        tipologia: TipologiaPianeta.roccioso,
        luna: true,
        capitale: 'Eryos II City',
        densitaPopolativa: DensitaPopolativa.nessuna,
        capacitaApprese: ['Vita di Regole', 'Abituato al Gelo'],
        tag: const ['Desolato', 'Rigoroso'],
      ),
    ],
    capitale: 'Eryos',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Mente Analitica', 'Abituato al Gelo'],
    tag: const ['Analitico', 'Freddo'],
  ),
  _pianeta(
    nome: 'Phyra',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Phyris',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Abitudine al Silenzio', 'Mente Analitica'],
    tag: const ['Silenzioso', 'Preciso'],
  ),
  _pianeta(
    nome: 'Talen',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Talos',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Come l\'Acqua', 'Risonanza Mistica'],
    tag: const ['Fluido', 'Intuitivo'],
  ),
];

final List<Pianeta> pianetiSistemaBilancia = [
  _pianeta(
    nome: 'Auron',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Auria',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Equilibrio Perfetto', 'Mediatore Nato'],
    tag: const ['Equilibrato', 'Neutrale'],
  ),
  _pianeta(
    nome: 'Selis',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Selion',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Mediatore Nato', 'Etichetta di Corte'],
    tag: const ['Diplomatico', 'Calmo'],
  ),
  _pianeta(
    nome: 'Vorn',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Vornia',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Equilibrio Perfetto', 'Calma degli Abissi'],
    tag: const ['Bilanciato', 'Profondo'],
  ),
];

final List<Pianeta> pianetiSistemaScorpione = [
  _pianeta(
    nome: 'Zareth',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Zaria',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Cacciatore nel Buio', 'Riflessi Taglienti'],
    tag: const ['Letale', 'Oscuro'],
  ),
  _pianeta(
    nome: 'Myrka',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Myrkon',
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Custode di Segreti', 'Abituato al Gelo'],
    tag: const ['Segreto', 'Freddo'],
  ),
  _pianeta(
    nome: 'Threx',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Threxia',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Risonanza Mistica', 'Calma degli Abissi'],
    tag: const ['Mistico', 'Profondo'],
  ),
];

final List<Pianeta> pianetiSistemaSagittario = [
  _pianeta(
    nome: 'Kerys',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Keryon',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Viandante', 'Riflessi Taglienti'],
    tag: const ['Nomade', 'Rapido'],
  ),
  _pianeta(
    nome: 'Darn',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Darnia',
    densitaPopolativa: DensitaPopolativa.nessuna,
    capacitaApprese: ['Viandante', 'Vita di Regole'],
    tag: const ['Errante', 'Severo'],
  ),
  _pianeta(
    nome: 'Ophra',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Ophralis',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Come l\'Acqua', 'Viandante'],
    tag: const ['Fluido', 'Mobile'],
  ),
];

final List<Pianeta> pianetiSistemaCapricorno = [
  _pianeta(
    nome: 'Bris',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Brisia',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Vita di Regole', 'Abituato al Gelo'],
    tag: const ['Rigoroso', 'Freddo'],
  ),
  _pianeta(
    nome: 'Torga',
    grandezza: GrandezzaPianeta.grande,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Torgos',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Vita di Regole', 'Orgoglio Indomito'],
    tag: const ['Strutturato', 'Forte'],
  ),
  _pianeta(
    nome: 'Velan',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Velaris',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Calma degli Abissi', 'Equilibrio Perfetto'],
    tag: const ['Profondo', 'Stabile'],
  ),
];

final List<Pianeta> pianetiSistemaPesci = [
  _pianeta(
    nome: 'Orin',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Orinia',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Risonanza Mistica', 'Memoria degli Antichi'],
    tag: const ['Mistico', 'Spirituale'],
  ),
  _pianeta(
    nome: 'Selmar',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Selmaria',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Abitudine al Silenzio', 'Calma degli Abissi'],
    tag: const ['Silenzioso', 'Profondo'],
  ),
  _pianeta(
    nome: 'Thessa',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Thessos',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Memoria degli Antichi', 'Risonanza Mistica'],
    tag: const ['Spirituale', 'Antico'],
  ),
];

final List<Pianeta> pianetiSistemaAcquario = [
  _pianeta(
    nome: 'Nerys',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.acquatico,
    luna: false,
    capitale: 'Neryon',
    densitaPopolativa: DensitaPopolativa.molta,
    capacitaApprese: ['Mani da Tecnico', 'Come l\'Acqua'],
    tag: const ['Innovativo', 'Fluido'],
  ),
  _pianeta(
    nome: 'Halon',
    grandezza: GrandezzaPianeta.piccolo,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Halos',
    densitaPopolativa: DensitaPopolativa.poca,
    capacitaApprese: ['Mani da Tecnico', 'Abituato al Gelo'],
    tag: const ['Freddo', 'Tecnico'],
  ),
  _pianeta(
    nome: 'Tyra',
    grandezza: GrandezzaPianeta.medio,
    tipologia: TipologiaPianeta.roccioso,
    luna: false,
    capitale: 'Tyrion',
    densitaPopolativa: DensitaPopolativa.media,
    capacitaApprese: ['Mente Analitica', 'Mani da Tecnico'],
    tag: const ['Analitico', 'Solido'],
  ),
];
