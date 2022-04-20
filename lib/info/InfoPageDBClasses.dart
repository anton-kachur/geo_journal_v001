import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving app info
**************************************************************** */
@HiveType(typeId: 9)
class InfoDescription {
  @HiveField(0)
  var title;
  @HiveField(1)
  var developer;
  @HiveField(2)
  var version;  
  
  InfoDescription(this.title, this.developer, this.version);
}


class InfoDescriptionAdapter extends TypeAdapter<InfoDescription>{
  @override
  final typeId = 9;


  @override
  InfoDescription read(BinaryReader reader) {
    final title = reader.readString();
    final developer = reader.readString();
    final version = reader.readString();

    return InfoDescription(title, developer, version);
  }


  @override
  void write(BinaryWriter writer, InfoDescription obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.developer);
    writer.writeString(obj.version);
  }
}