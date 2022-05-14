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
  final wellNumber;
  final projectNumber;  // number of project, to which the well belongs

  WellPage(this.wellNumber, this.projectNumber);
  
  @override
  WellPageState createState() => WellPageState();
}


class WellPageState extends State<WellPage>{
  var box;
  var boxSize;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
      
    try {
      for (var key in box.keys) {
        if (box.get(key).login == (await currentAccount).login) {
          boxSize = box.length;
      
          return Future.value(box.get(key));  
        
        }
      }  
    } catch (e) {}
  }  


  // Sort list of soil samples
  List<SoilForWellDescription> sortArray(List<SoilForWellDescription> array) {
    array.sort((a, b) => a.depthStart.toString().compareTo(b.depthStart.toString()));

    return array;
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

              body:  Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // output the list of soil samples from current well
                      if (currentAccount != null) 
                        for (var element in snapshot.data.projects)
                          if (element.number == widget.projectNumber)
                            for (var well in element.wells)
                              if (well.number == widget.wellNumber && well.projectNumber == widget.projectNumber)
                                for (var sample in sortArray(well.samples))
                                  SoilSample(sample.name, sample.depthStart, sample.depthEnd, sample.notes, sample.wellNumber, sample.projectNumber, sample.image),
                          
                    ]
                  ),
                )
              ),

              bottomNavigationBar: Bottom('soil_sample', widget.wellNumber, widget.projectNumber),
            );
        }
      }
    );
  }

}