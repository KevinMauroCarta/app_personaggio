/// La versione dell'app, mostrata in fondo alla Home.
///
/// È il solo numero di versione, senza il numero di build che in
/// pubspec.yaml sta dopo il "+": quello serve ad Android per capire se
/// un APK è più nuovo di quello installato, ma a chi usa l'app non dice
/// niente.
///
/// Va tenuta allineata al campo `version:` di pubspec.yaml, che è quello
/// che finisce davvero dentro APK e build web. Sono due posti diversi
/// perché leggere pubspec.yaml a runtime richiederebbe un pacchetto in
/// più: a tenerli in riga ci pensa un test (versione_app_test.dart), che
/// diventa rosso appena i due numeri divergono.
const String versioneApp = '0.5.3';
