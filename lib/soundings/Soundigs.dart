import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/Sounding.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../AppUtilites.dart';


/* *************************************************************************
 Classes for page with the list of soundings
************************************************************************* */
class Soundings extends StatefulWidget {
  var projectNumber;  // number of project, to which the sounding belongs

  Soundings(this.projectNumber);
  
  @override
  SoundingsState createState() => SoundingsState();
}


class SoundingsState extends State<Soundings> {
  var box;
  var boxSize;
  

  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox<SoundingDescription>('s_soundings');
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
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('Точки статичного зондування'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                children: [

                  // Output the list of soundings
                  for (var element in snapshot.data)
                    if (element.projectNumber.toString() == widget.projectNumber.toString())
                      Sounding(element.depth, element.qc, element.fs, element.notes, element.projectNumber),
                  
                ]
              ),
              
              bottomNavigationBar: Bottom.dependOnPage('soundings', widget.projectNumber),
            );
        }
      }
    );
  }
  
}