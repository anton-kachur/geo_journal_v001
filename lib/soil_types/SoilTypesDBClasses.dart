import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'SoilTypesDBClasses.g.dart';

/* ***************************************************************
  Hive class for saving soil description
**************************************************************** */
@HiveType(typeId: 0)
class SoilDescription{
  @HiveField(0)
  var type;
  @HiveField(1)
  var description;
  @HiveField(2)
  var image;
  
  SoilDescription(this.type, this.description, {this.image});

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
      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text(type),
        automaticallyImplyLeading: false
      ),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('$description'),
      )
    );
  }
}