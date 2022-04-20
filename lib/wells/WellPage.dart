import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSample.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../AppUtilites.dart';


/* *************************************************************************
  Classes for well page
************************************************************************* */
class WellPage extends StatefulWidget {
  var wellNumber;
  var projectNumber;  // number of project, to which the well belongs

  WellPage(this.wellNumber, this.projectNumber);
  
  @override
  WellPageState createState() => WellPageState();
}


class WellPageState extends State<WellPage>{
  var box;
  var boxSize;
  

  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox<SoilForWellDescription>('well_soil_samples');
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
                title: Text('Проби грунту'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                children: [

                  // output the list of soil samples from current well
                  for (var element in snapshot.data)
                    if (element.wellNumber == widget.wellNumber && element.projectNumber == widget.projectNumber)
                      SoilSample(element.name, element.depthStart, element.depthEnd, element.notes, element.wellNumber, element.projectNumber),
                      
                ]
              ),

              bottomNavigationBar: Bottom('soil_sample', widget.wellNumber, widget.projectNumber),
            );
        }
      }
    );
  }

}