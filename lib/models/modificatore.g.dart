// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modificatore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modificatore _$ModificatoreFromJson(Map<String, dynamic> json) => Modificatore(
  bersaglio: $enumDecode(
    _$BersaglioEnumMap,
    _leggiBersaglio(json, 'bersaglio'),
  ),
  valore: (json['valore'] as num).toInt(),
);

Map<String, dynamic> _$ModificatoreToJson(Modificatore instance) =>
    <String, dynamic>{
      'bersaglio': _$BersaglioEnumMap[instance.bersaglio]!,
      'valore': instance.valore,
    };

const _$BersaglioEnumMap = {
  Bersaglio.forza: 'forza',
  Bersaglio.resistenza: 'resistenza',
  Bersaglio.agilita: 'agilita',
  Bersaglio.iniziativa: 'iniziativa',
  Bersaglio.volonta: 'volonta',
  Bersaglio.intelletto: 'intelletto',
  Bersaglio.socialita: 'socialita',
  Bersaglio.atletica: 'atletica',
  Bersaglio.mischiaPesante: 'mischiaPesante',
  Bersaglio.tempra: 'tempra',
  Bersaglio.furtivita: 'furtivita',
  Bersaglio.mira: 'mira',
  Bersaglio.pilotaggio: 'pilotaggio',
  Bersaglio.mischiaLeggera: 'mischiaLeggera',
  Bersaglio.comando: 'comando',
  Bersaglio.controlloPsionico: 'controlloPsionico',
  Bersaglio.intimidazione: 'intimidazione',
  Bersaglio.investigazione: 'investigazione',
  Bersaglio.istruzione: 'istruzione',
  Bersaglio.medicae: 'medicae',
  Bersaglio.percezione: 'percezione',
  Bersaglio.tecnologia: 'tecnologia',
  Bersaglio.sopravvivenza: 'sopravvivenza',
  Bersaglio.astuzia: 'astuzia',
  Bersaglio.inganno: 'inganno',
  Bersaglio.intuizione: 'intuizione',
  Bersaglio.persuasione: 'persuasione',
  Bersaglio.ferite: 'ferite',
  Bersaglio.shock: 'shock',
  Bersaglio.velocita: 'velocita',
  Bersaglio.difesa: 'difesa',
  Bersaglio.resilienza: 'resilienza',
  Bersaglio.resilienzaFisica: 'resilienzaFisica',
  Bersaglio.resilienzaEnergetica: 'resilienzaEnergetica',
  Bersaglio.grinta: 'grinta',
  Bersaglio.fermezza: 'fermezza',
  Bersaglio.risolutezza: 'risolutezza',
  Bersaglio.influenza: 'influenza',
  Bersaglio.percezionePassiva: 'percezionePassiva',
  Bersaglio.riservaFurtiva: 'riservaFurtiva',
};
