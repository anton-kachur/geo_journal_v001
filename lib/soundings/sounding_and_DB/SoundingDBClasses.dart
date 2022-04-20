import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving soundings
**************************************************************** */
@HiveType(typeId: 4)
class SoundingDescription {
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
  
  SoundingDescription(this.depth, this.qc, this.fs, this.notes, this.projectNumber);

  @override
  String toString() {
    return '${this.depth}\n${this.qc}\n${this.fs}\n${this.notes}';
  }
}


class SoundingDescriptionAdapter extends TypeAdapter<SoundingDescription>{
  @override
  final typeId = 4;


  @override
  SoundingDescription read(BinaryReader reader) {
    final depth = reader.readDouble();
    final qc = reader.readDouble();
    final fs = reader.readDouble();
    final notes = reader.readString();
    final projectNumber = reader.readString();

    return SoundingDescription(depth, qc, fs, notes, projectNumber);
  }


  @override
  void write(BinaryWriter writer, SoundingDescription obj) {
    writer.writeDouble(obj.depth);
    writer.writeDouble(obj.qc);
    writer.writeDouble(obj.fs);
    writer.writeString(obj.notes);
    writer.writeString(obj.projectNumber);
  }
}