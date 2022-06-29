import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/wells/well_and_DB/Well.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


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
    box = await Hive.openBox('accounts_data');
    
    try {
      for (var key in box.keys) {
        if (
          box.get(key).login == (await currentAccount).login
        ) {
          boxSize = box.length;
      
          return Future.value(box.get(key));  
        
        }
      } 
    } catch (e) {} 
  }  


  // Sort the list of wells
  List<WellDescription> sortArray(List<WellDescription> array) {
    array.sort((a, b) => a.number.compareTo(b.number));

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
                title: Text('Свердловини'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    
                     // output list of wells
                      if (snapshot.data != null) 
                        for (var element in snapshot.data.projects) 
                          if (element.number == widget.projectNumber)
                            for (var well in sortArray(element.wells))
                              Well(well.number, well.date, well.latitude, well.longtitude, well.projectNumber, well.image),
                              
                      if (snapshot.data == null) 
                        Well('1', '12/07/2023', '17.1234', '19.1411', widget.projectNumber, ''),
                    ]
                  ),
                )
              ),
              
              bottomNavigationBar: Bottom('wells', widget.projectNumber),
            );
        }
      }
    );
  }

}