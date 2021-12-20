import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/SoilTypes.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  // Hive database initialization
  
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SoilDescriptionAdapter());  // Adding adapter for soil description
  }

  // Creating box for soil description
  var box = await Hive.openBox<SoilDescription>('soil_types');
  box.close();

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