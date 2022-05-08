import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:geo_journal_v001/info/InfoPageDBClasses.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'accounts/AccountsDBClasses.dart';




void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocDir.path)
    
    ..registerAdapter<SoilDescription>(SoilDescriptionAdapter())  // Adding adapter for soil description
    ..registerAdapter<ProjectDescription>(ProjectDescriptionAdapter())  // Adding adapter for project description
    ..registerAdapter<UserAccountDescription>(UserAccountDescriptionAdapter())  // Adding adapter for account description
    ..registerAdapter<SoundingDescription>(SoundingDescriptionAdapter())  // Adding adapter for sounding description
    ..registerAdapter<WellDescription>(WellDescriptionAdapter())  // Adding adapter for well description
    ..registerAdapter<SoilForWellDescription>(SoilForWellDescriptionAdapter())  // Adding adapter for soil sample description
    ..registerAdapter(InfoDescriptionAdapter())  // Adding adapter for app info description
    ..initFlutter();

  //Hive.deleteBoxFromDisk('soil_types');

  // Creating box for soil description
  var box = await Hive.openBox('soil_types');
  /*box.put(
    'soil0', SoilDescription('Пісок', 'Опис піску')
  );*/
  box.close();

  // Creating box for accounts
  var box1 = await Hive.openBox('accounts_data');
  /*box1.put(
    'account0', UserAccountDescription(
    'admin', 'qwerty', 'admin@gmail.com', '+380999999999', 
    'Адміністратор/розробник', true, true, [ProjectDescription('тест', '1', '31/12/2023', 'notes', [], [])]));*/
  //box1.clear();
  for (var i in box1.values) {
   print(i.toString());
  } 
  box1.close();

  // Creating box for weather forecasts
  /*var box2 = await Hive.openBox<WeatherDescription>('weather');
  //box2.clear();
  box2.close();

  // Creating box for projects
  var box3 = await Hive.openBox<ProjectDescription>('projects');
  //box3.clear();
  box3.close();

  // Creating box for soundings
  var box4 = await Hive.openBox<SoundingDescription>('soundings');
  //box4.clear();
  box4.close();

  // Creating box for wells
  var box5 = await Hive.openBox<WellDescription>('wells');
  //box5.put('well0', WellDescription('1', '24/04/2022', 11.2324, 14.5332, '1'));
  //box5.clear();
  box5.close();

  // Creating box for soil_samples
  var box6 = await Hive.openBox<SoilForWellDescription>('well_soil_samples');
  //box6.put('soil_sample0', SoilForWellDescription('Вода', '0.0', '1.0', 'Нотатки', '1', '1'));
  //box6.clear();
  box6.close();*/
  

  // Creating box for app info
  var box7 = await Hive.openBox<InfoDescription>('info');
  box7.put('info0', InfoDescription(
      'Застосунок для геологів', 
      'Розробник: Качур А. В.', 
      'Версія: 0.0.3'));
  box7.close();

  // Running app
  runApp(Application());
}