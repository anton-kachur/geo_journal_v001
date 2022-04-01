import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/ProjectPage.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/weather/WeatherDBClasses.dart';
import 'package:geo_journal_v001/weather/WeatherForecasts.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  // Hive database initialization
  

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SoilDescriptionAdapter());  // Adding adapter for soil description
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AccountDescriptionAdapter());  // Adding adapter for account description
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(WeatherDescriptionAdapter());  // Adding adapter for weather description
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ProjectDescriptionAdapter());  // Adding adapter for project description
  }

  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(SoundingDescriptionAdapter());  // Adding adapter for project description
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(WellDescriptionAdapter());  // Adding adapter for well description
  }



  // Creating box for soil description
  var box = await Hive.openBox<SoilDescription>('soil_types');
  box.close();

  // Creating box for accounts
  var box1 = await Hive.openBox<AccountDescription>('s_accounts');
  box1.close();

  // Creating box for weather forecasts
  var box2 = await Hive.openBox<WeatherDescription>('s_weather');
  box2.close();

  // Creating box for projects
  var box3 = await Hive.openBox<ProjectDescription>('s_projects');
  box3.close();

  // Creating box for projects
  var box4 = await Hive.openBox<SoundingDescription>('s_soundings');
  box4.close();

  // Creating box for projects
  var box5 = await Hive.openBox<WellDescription>('s_wells');
  /*await box5.put('well1', WellDescription('1', '12/12/2088', 50.8891, 45.8899, '1'));
  for (var i in box5.values) {
    print(i.toString());
  }*/
  box5.close();


  // Running app
  runApp(Application());
}


































  //box.put('soil3', SoilDescription.desc('Средний суглинок', 'Описания пока нет'));
  
  // Change element data
  //sd?.type = 'Trrraaarrrf';
  //await sd?.save();
  
  //var gettedBox = await Hive.openBox('testBox');
  //gettedBox.deleteFromDisk();
  //var sd = SoilDescriptionDB('SOMETHING...');
  //await box.put('test_soil', 'KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK');


  // Get element data
  //print('${box.get('Как определить состав грунта').toString()}\n');

  //for (var i in box.values) {
  //  print(i.toString());
  //}