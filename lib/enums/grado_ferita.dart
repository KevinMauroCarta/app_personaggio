/// Grado di Ferita del personaggio (vedi Modello/Ferite): livello di
/// gravità da 0 a 3.
enum GradoFerita { zero, uno, due, tre }

extension GradoFeritaLabel on GradoFerita {
  String get label {
    switch (this) {
      case GradoFerita.zero:
        return '0';
      case GradoFerita.uno:
        return '1';
      case GradoFerita.due:
        return '2';
      case GradoFerita.tre:
        return '3';
    }
  }
}
