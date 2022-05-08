import 'package:hive_flutter/hive_flutter.dart';

part 'SoundingDBClasses.g.dart';

/* ***************************************************************
  Hive class for saving soundings
**************************************************************** */
@HiveType(typeId: 4)
class SoundingDescription extends HiveObject {
  @HiveField(0)
  var depth;
  @HiveField(1)
  var qc;
  @HiveField(2)
  var fs;
  @HiveField(3)
  var notes;
  @HiveField(4)
  var projectNumber;
  @HiveField(5)
  var image;
  
  SoundingDescription(this.depth, this.qc, this.fs, this.notes, this.projectNumber, {this.image});

  @override
  String toString() {
    return '${this.depth}\n${this.qc}\n${this.fs}\n${this.notes}';
  }
}