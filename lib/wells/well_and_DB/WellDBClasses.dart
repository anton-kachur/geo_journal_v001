import 'dart:io';

import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'WellDBClasses.g.dart';

/* ***************************************************************
  Hive class for saving wells
**************************************************************** */
@HiveType(typeId: 5)
class WellDescription extends HiveObject {
  @HiveField(0)
  var number;
  @HiveField(1)
  var date;
  @HiveField(2)
  var latitude;
  @HiveField(3)
  var longtitude;
  @HiveField(4)
  var projectNumber;
  @HiveField(5)
  List<SoilForWellDescription> samples;
  @HiveField(6)
  
  var image;

  WellDescription(this.number, this.date, this.latitude, this.longtitude, this.projectNumber, this.samples, {this.image});

  @override
  String toString() {
    return '${this.number}\n${this.date}\n${this.latitude}\n${this.longtitude}\nprn: ${this.projectNumber}';
  }
}