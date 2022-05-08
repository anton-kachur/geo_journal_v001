import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../appUtilites.dart';


/* ***************************************************************
  Class for representing list with soil types
**************************************************************** */
class SoilTypes extends StatelessWidget {
  late final box;
  late final boxSize;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('soil_types');
    boxSize = box.length;

    return Future.value(box.values);     
  }  


  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('Типи грунтів'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // output soil types list
                      for (var element in snapshot.data)
                        SoilType(element.type, element.description, element.image),
                      
                    ]
                  ),
                ),
              ),
              
              bottomNavigationBar: Bottom('soil_types'),
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
  final String image;

  SoilType(this.type, this.description, this.image);
  
  @override
  SoilTypeState createState() => SoilTypeState();
}


class SoilTypeState extends State<SoilType> {
  var box;
  var image;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('soil_types');

    return Future.value(box.values);    
  }


  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();

    return FutureBuilder(
      future: boxData,  // data, retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Container(

              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black45, width: 1.0),
                )
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0), 
                    child: Text(widget.type)
                  ),

                  IconButton(        
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,

                    padding: EdgeInsets.fromLTRB(220.0, 0.0, 0.0, 0.0),
                    icon: Icon(Icons.photo, size: 20),
                    onPressed: () {
                      if (widget.image != null || image != null) {
                        
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {

                            return AlertDialog(
                              insetPadding: EdgeInsets.all(10),
                              contentPadding: EdgeInsets.zero,
                              
                              title: const Text(''),
                              content: Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.center,
                                children: [
                                  Image.network(widget.image == null? image : widget.image, fit: BoxFit.cover)
                                ],
                              ),

                              actions: [
                                
                                FlatButton(
                                  child: const Text('ОК'),
                                  onPressed: () { 
                                    Navigator.of(context).pop(); 
                                  },
                                ),

                              ],
                            );
                          }
                        );
                      } else {
                      }
                    }
                  ),
                  
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.arrow_forward_ios_rounded, size: 22),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SoilDescriptionPage.desc(widget.type, widget.description)));
                    }
                  ) 

                ]
              )

            );   
        }
      }
    );
  }

}