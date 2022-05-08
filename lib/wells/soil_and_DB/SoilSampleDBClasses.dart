import 'package:hive_flutter/hive_flutter.dart';

part 'SoilSampleDBClasses.g.dart';

/* ***************************************************************
  Hive class for saving soil samples
**************************************************************** */
@HiveType(typeId: 16)
class SoilForWellDescription {
  @HiveField(0)
  var name;
  @HiveField(1)
  var depthStart;
  @HiveField(2)
  var depthEnd;
  @HiveField(3)
  var notes;
  @HiveField(4)
  var wellNumber;
  @HiveField(5)
  var projectNumber;
  @HiveField(6)
  var image;

  SoilForWellDescription(this.name, this.depthStart, this.depthEnd, this.notes, this.wellNumber, this.projectNumber, {this.image});

  @override
  String toString() {
    return '${this.name}\n${this.depthStart}\n${this.depthEnd}\n${this.notes}';
  }
}