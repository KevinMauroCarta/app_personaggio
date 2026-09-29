import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/personaggio.dart';
import '../models/scheda.dart';

/// Gestisce il salvataggio persistente delle Schede create.
///
/// Viene salvata la [Scheda] intera (che contiene il [Personaggio]), non
/// il solo Personaggio: servono persistenti anche i valori di gioco
/// modificabili dalla Scheda stessa (Ira, Furtività Passiva, PE
/// Guadagnati, ecc.). Le schede vengono serializzate in JSON tramite
/// [Scheda.toJson]/[Scheda.fromJson] e salvate come lista di stringhe
/// tramite [SharedPreferences]: funziona sia su Windows sia su Android
/// senza bisogno di un vero database.
class CharacterStorage {
  static const String _chiave = 'personaggi_salvati';

  /// Carica tutte le schede salvate. Ritorna una lista vuota se non è
  /// ancora stata salvata nessuna scheda.
  ///
  /// Una singola scheda illeggibile (salvataggio troncato, oppure scritta
  /// da una versione del modello non più compatibile) viene saltata invece
  /// di far fallire l'intero caricamento: meglio perdere quel personaggio
  /// che ritrovarsi la Home vuota o bloccata sul caricamento.
  Future<List<Scheda>> caricaSchede() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList(_chiave) ?? [];
    final schede = <Scheda>[];
    for (final json in listaJson) {
      try {
        schede.add(_decodifica(jsonDecode(json) as Map<String, dynamic>));
      } catch (_) {
        continue;
      }
    }
    return schede;
  }

  /// I salvataggi fatti prima che la Scheda diventasse persistente
  /// contengono il JSON di un [Personaggio] "nudo" invece che di una
  /// [Scheda]: si riconoscono perché non hanno la chiave 'personaggio'.
  /// In quel caso il personaggio viene avvolto in una Scheda con i valori
  /// di default, così i personaggi già salvati non vanno persi.
  Scheda _decodifica(Map<String, dynamic> json) {
    if (json.containsKey('personaggio')) return Scheda.fromJson(json);
    return Scheda(personaggio: Personaggio.fromJson(json));
  }

  /// Sovrascrive l'intera lista di schede salvate.
  Future<void> salvaSchede(List<Scheda> schede) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = schede.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_chiave, listaJson);
  }

  /// Aggiunge una singola scheda a quelle già salvate.
  Future<void> aggiungiScheda(Scheda scheda) async {
    final attuali = await caricaSchede();
    attuali.add(scheda);
    await salvaSchede(attuali);
  }

  /// Rimuove una scheda dato il suo indice nella lista salvata. Usata
  /// dalla voce "Elimina" della Home, che chiede conferma prima di
  /// chiamarla: qui la cancellazione è definitiva.
  Future<void> rimuoviScheda(int indice) async {
    final attuali = await caricaSchede();
    if (indice < 0 || indice >= attuali.length) return;
    attuali.removeAt(indice);
    await salvaSchede(attuali);
  }

  /// Sostituisce la scheda all'[indice] indicato con [scheda], usato da
  /// APP/Pagina/Modifica-PG, APP/Pagina/Aumento-PG e APP/Pagina/Scheda
  /// per salvare le modifiche.
  Future<void> aggiornaScheda(int indice, Scheda scheda) async {
    final attuali = await caricaSchede();
    if (indice < 0 || indice >= attuali.length) return;
    attuali[indice] = scheda;
    await salvaSchede(attuali);
  }
}
