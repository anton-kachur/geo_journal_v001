import 'package:flutter/material.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/wells/WellPage.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../AppUtilites.dart';


/* *************************************************************************
 Classes for well
************************************************************************* */
class Well extends StatefulWidget {
  var number;
  var date;
  var latitude;
  var longtitude;

  var projectNumber;

  Well(this.number, this.date, this.latitude, this.longtitude, this.projectNumber);
  
  @override
  WellState createState() => WellState();
}


class WellState extends State<Well>{
  var thisProjectBox;
  var thisWellsBox;
  var soilSamplesBox;
  
   
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    thisProjectBox = await Hive.openBox<ProjectDescription>('s_projects');
    thisWellsBox = await Hive.openBox<WellDescription>('s_wells');
    soilSamplesBox = await Hive.openBox<SoilForWellDescription>('well_soil_samples');

    return Future.value(thisWellsBox.values);     
  }


    // Function for deleting data in database
  Widget deleteElementInBox() {
    
    // Find all SOIL SAMPLES, connected with the current well and delete them
    for (var soilKey in soilSamplesBox.keys) {
      if ((soilSamplesBox.get(soilKey)).wellNumber == widget.number && widget.projectNumber == (soilSamplesBox.get(soilKey)).projectNumber) {
        soilSamplesBox.delete(soilKey);
      }
    }

    // Find current WELL in database and delete it
    for (var wellKey in thisWellsBox.keys) {
      if ((thisWellsBox.get(wellKey)).number == widget.number && (thisWellsBox.get(wellKey)).projectNumber == widget.projectNumber) {
          
          thisWellsBox.delete(wellKey); // Delete well
      
      }   
    }

  
    return Text('');
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                        child: Text('Свердловина №${widget.number}')
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: Text('Дата буріння: ${widget.date}'),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                        child: Text('Координати: ${widget.latitude}, ${widget.longtitude}'),
                      )
                    ]
                  ),


                  Row(
                    children: [
                      IconButton(        
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () {
                          // TODO    Make edit page
                        }
                      ),

                      IconButton(        
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 23.0, 0.0),
                        icon: Icon(Icons.delete, size: 20),
                        onPressed: () {
                          deleteElementInBox();
                          setState(() { });
                        }
                      ),
                      
                      IconButton(  
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),

                        icon: Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => WellPage(widget.number, widget.projectNumber)),
                          );
                        }
                      ),
                    ]
                  ),

                ]
              )
            );
        }
      }
    );
  }
}