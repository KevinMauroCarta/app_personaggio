import '../models/tag.dart';

/// Lista/Tag
///
/// Catalogo unico dei Tag. Ogni tag che compare su una razza, un sistema,
/// un pianeta, un background, una capacità, un talento o un'arma viene da
/// qui: è [tagDaNome] a risolverlo, quindi un nome sbagliato si fa
/// sentire subito invece di restare una stringa che non corrisponderà mai
/// a niente.
///
/// ATTENZIONE - dati incompleti: i nomi sono quelli veri o scelti su ciò
/// che li porta (il tag di un background parla di quel background), ma
/// nessun documento dice cosa significhino, quindi ogni [Tag.descrizione]
/// è un segnaposto `template-descrizione-tag-{n}`. Da riempire mano a mano
/// che i tag vengono definiti.
///
/// I 86 tag sono in ordine alfabetico.
const List<Tag> listaTag = [
  Tag(nome: 'Adattivo', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Addestrato', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Aeleidari', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Analitico', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Anelli', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Antico', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Archivista', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Ardente', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Arido', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Avanguardia', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Bilanciato', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Brutale', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Calmo', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Centrale', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Coloniale', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Conservatore', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Denso', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Desolato', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Diplomatico', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Disciplinato', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Diversificato', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Dominante', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Doppio', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Duro', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Elegante', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Equilibrato', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Errante', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Erudito', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Feroce', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Fiero', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Fluido', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Forte', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Freddo', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Impulso Stellare', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Industriale', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Innovativo', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Innovatore', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Intuitivo', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Isolato', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Istintivo', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Letale', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Logico', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Luminoso', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Massivo', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Medico', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Militare', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Minerario', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Mistico', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Mobile', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Mondriani', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Neutrale', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Nodo Centrale', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Nomade', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Occulto', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Oscuro', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Ostile', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Preciso', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Profondo', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Psionico', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Rapido', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Regale', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Remoto', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Resistente', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Rigidità', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Rigoroso', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Rosso', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Segreto', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Sentinella', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Severo', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Silenzioso', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Solari', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Solido', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Spaziale', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Spirituale', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Stabile', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Strategico', descrizione: 'template-descrizione-tag-5'),
  Tag(nome: 'Strutturato', descrizione: 'template-descrizione-tag-6'),
  Tag(nome: 'Tagliente', descrizione: 'template-descrizione-tag-7'),
  Tag(nome: 'Tattico', descrizione: 'template-descrizione-tag-8'),
  Tag(nome: 'Tecnico', descrizione: 'template-descrizione-tag-9'),
  Tag(nome: 'Tempestoso', descrizione: 'template-descrizione-tag-0'),
  Tag(nome: 'Tenace', descrizione: 'template-descrizione-tag-1'),
  Tag(nome: 'Tetramari', descrizione: 'template-descrizione-tag-2'),
  Tag(nome: 'Tradizionale', descrizione: 'template-descrizione-tag-3'),
  Tag(nome: 'Veterano', descrizione: 'template-descrizione-tag-4'),
  Tag(nome: 'Vigile', descrizione: 'template-descrizione-tag-5'),
];

/// Il Tag di nome [nome], da Lista/Tag.
///
/// Lancia se il nome non esiste: è voluto. Un tag scritto male è sempre
/// un errore nei dati, e accorgersene subito è meglio che mostrare un
/// personaggio a cui manca in silenzio un pezzo.
Tag tagDaNome(String nome) => listaTag.firstWhere((t) => t.nome == nome);

/// Il Tag che sblocca i Poteri Psionici (services/effetti_personaggio.dart).
final Tag tagPsionico = tagDaNome('Psionico');
