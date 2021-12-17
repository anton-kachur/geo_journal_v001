import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/InfoPage.dart';
import 'package:geo_journal_v001/folderForProjects/Projects.dart';
import 'package:geo_journal_v001/SoilDescriptionDB.dart';
import 'package:geo_journal_v001/SoilTypes.dart';
import 'package:geo_journal_v001/createHeader.dart';
import 'package:geo_journal_v001/weatherForecasts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {   
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SoilDescriptionAdapter());
  }

  // Create box
  var box = await Hive.openBox<SoilDescription>('soil_types');
  box.close();

  
  runApp(Application());
}


class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(2, 120);
    final p2 = Offset(1000, 120);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
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