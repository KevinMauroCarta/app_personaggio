/// Cosa può cambiare un Modificatore (Modello/Modificatore): una
/// Caratteristica, un'Abilità o uno dei valori della Scheda.
///
/// È un catalogo chiuso perché un nome sbagliato non deve poter esistere:
/// scritto come testo, un bonus a "Forsa" non avrebbe alzato niente senza
/// che nulla lo segnalasse.
///
/// [label] è il nome con cui il valore compare nell'app. Per
/// Caratteristiche e Abilità è anche il nome che hanno in
/// Lista/Caratteristiche e Lista/Abilità, ed è così che il Modificatore
/// trova la riga da alzare (un test verifica che i due elenchi
/// coincidano).
enum Bersaglio {
  // Caratteristiche
  forza('Forza', CategoriaBersaglio.caratteristica),
  resistenza('Resistenza', CategoriaBersaglio.caratteristica),
  agilita('Agilità', CategoriaBersaglio.caratteristica),
  iniziativa('Iniziativa', CategoriaBersaglio.caratteristica),
  volonta('Volontà', CategoriaBersaglio.caratteristica),
  intelletto('Intelletto', CategoriaBersaglio.caratteristica),
  socialita('Socialità', CategoriaBersaglio.caratteristica),

  // Abilità
  atletica('Atletica', CategoriaBersaglio.abilita),
  mischiaPesante('Mischia Pesante', CategoriaBersaglio.abilita),
  tempra('Tempra', CategoriaBersaglio.abilita),
  furtivita('Furtività', CategoriaBersaglio.abilita),
  mira('Mira', CategoriaBersaglio.abilita),
  pilotaggio('Pilotaggio', CategoriaBersaglio.abilita),
  mischiaLeggera('Mischia Leggera', CategoriaBersaglio.abilita),
  comando('Comando', CategoriaBersaglio.abilita),
  controlloPsionico('Controllo Psionico', CategoriaBersaglio.abilita),
  intimidazione('Intimidazione', CategoriaBersaglio.abilita),
  investigazione('Investigazione', CategoriaBersaglio.abilita),
  istruzione('Istruzione', CategoriaBersaglio.abilita),
  medicae('Medicae', CategoriaBersaglio.abilita),
  percezione('Percezione', CategoriaBersaglio.abilita),
  tecnologia('Tecnologia', CategoriaBersaglio.abilita),
  sopravvivenza('Sopravvivenza', CategoriaBersaglio.abilita),
  astuzia('Astuzia', CategoriaBersaglio.abilita),
  inganno('Inganno', CategoriaBersaglio.abilita),
  intuizione('Intuizione', CategoriaBersaglio.abilita),
  persuasione('Persuasione', CategoriaBersaglio.abilita),

  // Valori della Scheda: si sommano alla loro formula e all'eventuale
  // bonus scritto a mano (vedi Modello/Scheda).
  ferite('Ferite Massime', CategoriaBersaglio.scheda),
  shock('Shock Massimo', CategoriaBersaglio.scheda),
  velocita('Velocità', CategoriaBersaglio.scheda),
  difesa('Difesa', CategoriaBersaglio.scheda),

  /// Resilienza Base: entra sia nella Fisica sia nell'Energetica.
  resilienza('Resilienza', CategoriaBersaglio.scheda),
  resilienzaFisica('Resilienza Fisica', CategoriaBersaglio.scheda),
  resilienzaEnergetica('Resilienza Energetica', CategoriaBersaglio.scheda),
  grinta('Grinta', CategoriaBersaglio.scheda),
  fermezza('Fermezza', CategoriaBersaglio.scheda),
  risolutezza('Risolutezza', CategoriaBersaglio.scheda),
  influenza('Influenza', CategoriaBersaglio.scheda),
  percezionePassiva('Percezione Passiva', CategoriaBersaglio.scheda),
  riservaFurtiva('Riserva Furtiva', CategoriaBersaglio.scheda);

  final String label;
  final CategoriaBersaglio categoria;

  const Bersaglio(this.label, this.categoria);

  /// Il Bersaglio che si chiama [label], null se non c'è: serve a leggere
  /// i salvataggi di prima, in cui il Modificatore aveva solo il nome.
  static Bersaglio? daLabel(String label) {
    for (final b in values) {
      if (b.label == label) return b;
    }
    return null;
  }
}

/// Di che genere è un [Bersaglio].
enum CategoriaBersaglio { caratteristica, abilita, scheda }
