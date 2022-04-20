import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving projects
**************************************************************** */
@HiveType(typeId: 3)
class ProjectDescription {
  @HiveField(0)
  var name;
  @HiveField(1)
  var number;
  @HiveField(2)
  var date;
  @HiveField(3)
  var notes;
  
  ProjectDescription([this.name, this.number, this.date, this.notes]);

  @override
  String toString() {
    return '${this.name} №${this.number}\n\n${this.date}\n${this.notes}';
  }
}


class ProjectDescriptionAdapter extends TypeAdapter<ProjectDescription>{
  @override
  final typeId = 3;


  @override
  ProjectDescription read(BinaryReader reader) {
    final name = reader.readString();
    final number = reader.readString();
    final date = reader.readString();
    final notes = reader.readString();
    
    return ProjectDescription(name, number, date, notes);
  }


  @override
  void write(BinaryWriter writer, ProjectDescription obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.number);
    writer.writeString(obj.date);
    writer.writeString(obj.notes);
  }
}