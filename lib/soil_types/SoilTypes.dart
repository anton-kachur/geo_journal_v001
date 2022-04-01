import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Class for representing list with soil types
**************************************************************** */
class SoilTypes extends StatelessWidget {
  var box_size;
  var box;

  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    var boxx = await Hive.openBox<SoilDescription>(boxName);
    box_size = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox('soil_types');

    return FutureBuilder(
      future: boxData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Типи грунтів')),

              body: Column(
                children: [
                  for (var element in snapshot.data)
                    SoilType(type: element.type, description: element.description),
                  
                ]
              ),
              
              bottomNavigationBar: Bottom(),
            );
        }
      }
    );
  }
}


/* ***************************************************************
  Classes for creating soil sample with description
**************************************************************** */
class SoilType extends StatefulWidget {
  final String type;
  final String description;

  const SoilType({Key? key, required this.type, required this.description}): super(key: key);
  
  @override
  CreateSoilType createState() => CreateSoilType();
}


class CreateSoilType extends State<SoilType> {

  @override
  Widget build(BuildContext context) {
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
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 22),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SoilDescriptionPage.desc(widget.type, widget.description)));
                  }
                )   
              ]
            )
          )
        ]
      );
  }
}