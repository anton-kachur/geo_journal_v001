import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'ProjectDBClasses.g.dart';


/* ***************************************************************
  Hive class for saving projects
**************************************************************** */
abstract class ObjectDatabase{}
@HiveType(typeId: 3)
class ProjectDescription extends HiveObject {
  @HiveField(0)
  var name;
  @HiveField(1)
  var number;
  @HiveField(2)
  var date;
  @HiveField(3)
  var address;
  @HiveField(4)
  var notes;
  @HiveField(5)
  List<WellDescription> wells;
  @HiveField(6)
  List<SoundingDescription> soundings;
  
  
  ProjectDescription(this.name, this.number, this.date, this.address, this.notes, this.wells, this.soundings);

  @override
  String toString() {
    return '${this.name} №${this.number}\n${this.date}\n${this.address}\n${this.notes}\nwells: ${this.wells}\nsoundings: ${this.soundings}\n';
  }
}