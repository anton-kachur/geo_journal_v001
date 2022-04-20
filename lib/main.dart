import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/weather/WeatherDBClasses.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:geo_journal_v001/info/InfoPageDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  // Hive database initialization
  

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SoilDescriptionAdapter());  // Adding adapter for soil description
  }

  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(UserAccountDescriptionAdapter());  // Adding adapter for account description
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(WeatherDescriptionAdapter());  // Adding adapter for weather description
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ProjectDescriptionAdapter());  // Adding adapter for project description
  }

  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(SoundingDescriptionAdapter());  // Adding adapter for sounding description
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(WellDescriptionAdapter());  // Adding adapter for well description
  }

  if (!Hive.isAdapterRegistered(16)) {
    Hive.registerAdapter(SoilForWellDescriptionAdapter());  // Adding adapter for soil sample description
  }

  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(InfoDescriptionAdapter());  // Adding adapter for app info description
  }



  // Creating box for soil description
  var box = await Hive.openBox<SoilDescription>('soil_types');
  box.close();

  // Creating box for accounts
  var box1 = await Hive.openBox<UserAccountDescription>('accounts');
  box1.close();

  // Creating box for weather forecasts
  var box2 = await Hive.openBox<WeatherDescription>('s_weather');
  box2.close();

  // Creating box for projects
  var box3 = await Hive.openBox<ProjectDescription>('s_projects');
  box3.close();

  // Creating box for soundings
  var box4 = await Hive.openBox<SoundingDescription>('s_soundings');
  box4.close();

  // Creating box for wells
  var box5 = await Hive.openBox<WellDescription>('s_wells');
  box5.close();

  // Creating box for soil_samples
  var box6 = await Hive.openBox<SoilForWellDescription>('well_soil_samples');
  box6.close();


  // Creating box for app info
  var box7 = await Hive.openBox<InfoDescription>('info');
  box7.close();
  

  // Running app
  runApp(Application());
}