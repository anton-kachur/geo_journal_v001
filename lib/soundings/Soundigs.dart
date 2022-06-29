import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/Sounding.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page with the list of soundings
************************************************************************* */
class Soundings extends StatefulWidget {
  final projectNumber;  // number of project, to which the sounding belongs

  Soundings(this.projectNumber);
  
  @override
  SoundingsState createState() => SoundingsState();
}


class SoundingsState extends State<Soundings> {
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


  // Sort soundings' list
  List<SoundingDescription> sortArray(List<SoundingDescription> array) {
    array.sort((a, b) => a.depth.compareTo(b.depth));

    return array;
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

              body:  Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // Output the list of soundings
                      if (snapshot.data != null) 
                        for (var element in snapshot.data.projects)
                          if (element.number == widget.projectNumber)
                            for (var sounding in sortArray(element.soundings))
                              Sounding(sounding.depth, sounding.qc, sounding.fs, sounding.notes, widget.projectNumber, sounding.image),
                      
                      if (snapshot.data == null) 
                        Sounding('0.5', '23.4', '15.8', 'Нотатки', widget.projectNumber, null)
                    ]
                  ),
                )
              ),
              
              bottomNavigationBar: Bottom('soundings', widget.projectNumber),
            );
        }
      }
    );
  }
  
}