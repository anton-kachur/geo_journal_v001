import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/Sounding.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page with the list of soundings
************************************************************************* */
class Soundings extends StatefulWidget {
  var projectNumber;
  Soundings(this.projectNumber);
  
  @override
  SoundingsState createState() => SoundingsState();
}


class SoundingsState extends State<Soundings> {
  var box_size;
  var box;

  // Function for getting data from Hive database
  Future getDataFromBox() async {
    var boxx = await Hive.openBox<SoundingDescription>('s_soundings');
    box_size = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  Widget waitingOrErrorWindow(var text, var context) {
    return Container(
      height: MediaQuery.of(context).size.height, 
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(130, MediaQuery.of(context).size.height/2, 0.0, 0.0),

        child: Text(
          text,
          style: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.black),
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();

    return FutureBuilder(
      future: boxData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Точки статичного зондування')),

              body: Column(
                children: [
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









    /*return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text('Точки статичного зондування')),

      body: Column(
        children: [
          if (soundingsList.length > 0)
            for (var i in soundingsList)
              i,
              
          Text(''),
        ]
      ),

      bottomNavigationBar: Bottom.dependOnPage('soundings'),
    );*/
  }
}