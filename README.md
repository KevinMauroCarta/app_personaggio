# app_personaggio

A new Flutter project.

## Modelli: aggiungere o togliere un campo

I modelli in `lib/models/` usano
[json_serializable](https://pub.dev/packages/json_serializable): il codice
che li salva e li rilegge (`fromJson`/`toJson`) sta nei file `*.g.dart`, che
sono **generati** e non vanno modificati a mano.

Per aggiungere un campo:

1. scrivi il campo nella classe (`final int livello;`);
2. aggiungilo al costruttore (`required this.livello` oppure con un valore
   di default, `this.livello = 0`);
3. rigenera il codice:

   ```
   dart run build_runner build
   ```

Per togliere un campo: cancellalo da classe e costruttore, poi rigenera.

Mentre lavori puoi lasciare acceso `dart run build_runner watch`, che
rigenera da solo a ogni salvataggio.

**Personaggi già salvati.** Una scheda salvata prima dell'aggiunta del
campo non lo contiene. Se il campo ha un valore di default nel costruttore,
viene usato quello; altrimenti, per un campo obbligatorio, indicalo con
`@JsonKey(defaultValue: ...)`, come per `rarita` in `lib/models/oggetto.dart`.
Senza default la scheda vecchia non si carica più.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
