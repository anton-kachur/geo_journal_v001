import 'package:flutter/material.dart';
import 'package:geo_journal_v001/projects/ProjectPage.dart';
import 'package:hive_flutter/hive_flutter.dart';


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

  SoilForWellDescription(this.name, this.depthStart, this.depthEnd, this.notes, this.wellNumber, this.projectNumber);

  @override
  String toString() {
    return '${this.name}\n${this.depthStart}\n${this.depthEnd}\n${this.notes}';
  }
}


class SoilForWellDescriptionAdapter extends TypeAdapter<SoilForWellDescription>{
  @override
  final typeId = 16;


  @override
  SoilForWellDescription read(BinaryReader reader) {
    final name = reader.readString();
    final depthStart = reader.readString();
    final depthEnd = reader.readString();
    final notes = reader.readString();
    final wellNumber = reader.readString();
    final projectNumber = reader.readString();

    return SoilForWellDescription(name, depthStart, depthEnd, notes, wellNumber, projectNumber);
  }


  @override
  void write(BinaryWriter writer, SoilForWellDescription obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.depthStart);
    writer.writeString(obj.depthEnd);
    writer.writeString(obj.notes);
    writer.writeString(obj.wellNumber);
    writer.writeString(obj.projectNumber);
  }
}