import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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

  //Hive.deleteBoxFromDisk('accounts_data');

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
    'Адміністратор/розробник', true, true, [
      ProjectDescription(
        'тест', '1', '31/12/2023', 'вул. Велика Васильківська, Київ', 'Тестовий проект для прикладу.', 
        [WellDescription(
          '1', '01/01/2023', 50.4536, 30.5164, '1', 
          
          [SoilForWellDescription('Пісок', 0.2, 0.5, 'нотатки', '1', '1')]
        )],

        [SoundingDescription(0.0, 2.234, 2.546, 'нотатки', '1')]
      )]
    )
  );
  //box1.clear();
  
  for (var i in box1.values) {
   print(i.toString());
  }*/
  
  box1.close();
  

  // Creating box for app info
  var box7 = await Hive.openBox<InfoDescription>('info');
  /*box7.put('info0', InfoDescription(
      'Застосунок для геологів', 
      'Розробник: Качур А. В.', 
      'Версія: 0.0.3'));*/
  box7.close();

  // Running app
  runApp(Application());
}