import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Class for representing list with soil types
**************************************************************** */
class SoilTypes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text('Типи грунтів')),

      body: Column(
        children: [
          SoilType(type: 'Як визначати склад грунту'),
          SoilType(type: 'Пісок'),
          SoilType(type: 'Супісь'),
          SoilType(type: 'Легкий суглинок'),
          SoilType(type: 'Середній суглинок'),
          SoilType(type: 'Важкий суглинок'),
          SoilType(type: 'Торф'),
          
        ]
      ),
      
      bottomNavigationBar: Bottom(),
    );
  }
}


/* ***************************************************************
  Classes for creating soil sample with description
**************************************************************** */
class SoilType extends StatefulWidget {
  final String type;

  const SoilType({Key? key, required this.type}): super(key: key);
  
  @override
  CreateSoilType createState() => CreateSoilType();
}


class CreateSoilType extends State<SoilType> {

  // Function for getting soil description from Hive database 
  Future getDataFromBox() async {
    var boxx = await Hive.openBox<SoilDescription>('soil_types');
    for (var key in boxx.keys) {
      if (boxx.get(key)?.type == widget.type) {
        return Future.value(boxx.get(key)?.description);
      }
    }      
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDataFromBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Завантаження...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black45, width: 1.0),
                    )
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('     '+widget.type),
                      IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.arrow_forward_ios, size: 22),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SoilDescriptionPage.desc(widget.type, snapshot.data)));
                        }
                      )   
                    ]
                  )
                )
              ]
            );
        }
      }     
    );
  }
}


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
    return 'type: ${this.type} description: ${this.description}';
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