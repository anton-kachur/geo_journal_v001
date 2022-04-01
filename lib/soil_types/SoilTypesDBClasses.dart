import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving soil description
**************************************************************** */
@HiveType(typeId: 0)
class SoilDescription{
  @HiveField(0)
  var type;
  @HiveField(1)
  var description;
  
  SoilDescription(this.type);
  SoilDescription.desc(this.type, this.description);

  @override
  String toString() {
    return '${this.type} \n${this.description}';
  }
}


/* ***************************************************************
  Class for creating page of soil sample with description
**************************************************************** */
class SoilDescriptionPage extends StatelessWidget{
  var type;
  var description;
  
  SoilDescriptionPage(this.type);
  SoilDescriptionPage.desc(this.type, this.description);


  get getSoilType => type;
  get getSoilDescription => description;
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text(type)),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('$description'),
      )
    );
  }
}


class SoilDescriptionAdapter extends TypeAdapter<SoilDescription>{
  @override
  final typeId = 0;

  @override
  SoilDescription read(BinaryReader reader) {
    final type = reader.readString();
    final description = reader.readString();
    return SoilDescription.desc(type, description);
  }

  @override
  void write(BinaryWriter writer, SoilDescription obj) {
    writer.writeString(obj.type);
    writer.writeString(obj.description);
  }
}