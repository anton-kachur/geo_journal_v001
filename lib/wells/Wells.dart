import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/wells/well_and_DB/Well.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../AppUtilites.dart';


/* *************************************************************************
 Classes for page with the list of wells
************************************************************************* */
class Wells extends StatefulWidget {
  final projectNumber;  // number of project, to which the well belongs
  Wells(this.projectNumber);
  
  @override
  WellsState createState() => WellsState();
}


class WellsState extends State<Wells>{
  var box;
  var boxSize;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox<WellDescription>('s_wells');
    boxSize = box.length;
    
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
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('Свердловини'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                children: [

                  // output list of wells
                  for (var element in snapshot.data)
                    if (element.projectNumber == widget.projectNumber)
                      Well(element.number, element.date, element.latitude, element.longtitude, element.projectNumber),
                  
                ]
              ),
              
              bottomNavigationBar: Bottom('wells', widget.projectNumber),
            );
        }
      }
    );
  }

}