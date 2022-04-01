import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/Sounding.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add description of the new sounding
************************************************************************* */
class AddSoundingData extends StatefulWidget {
  var projectNumber;
  
  AddSoundingData(this.projectNumber);
  
  @override
  AddSoundingDataState createState() => AddSoundingDataState();
}


class AddSoundingDataState extends State<AddSoundingData>{
  var depth;
  var qc;
  var fs; 
  var notes; 
  
  var box;
  var boxSize; 


  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    var boxx;
    
    boxx = await Hive.openBox<SoundingDescription>('s_soundings');
    
    boxSize = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    box.put('sounding${boxSize+2}', SoundingDescription(depth, qc, fs, notes, widget.projectNumber));
    
    return Text('');
  }


  // Function for changing data in database
  /*Widget changeElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == widget.) {
        box.put(key, SoundingDescription(name, number, date, notes));
      }
    }
    
    box.close();
    return Text('');
  }*/


  // Function for deleting data in database
  Widget deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).depth == depth) {
        box.delete(key);
      }
    }
      
    box.close();
    return Text('');
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
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Ввести дані')),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Text field block for depth and qc
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            // Text field for depth input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  hintText: 'Глибина',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onChanged: (value) { depth = double.parse(value); }
                              )
                            ),

                            // Text field for qc input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  hintText: 'Ввести qc',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onChanged: (value) { qc = double.parse(value); }
                              )
                            ),        
                          ]
                        )
                      ),

                      // Text field block for fs and notes
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // Text field for fs input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  hintText: 'Ввести fs',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onChanged: (value) { fs = double.parse(value); }
                              )
                            ),   

                            // Text field for notes input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.done,

                                decoration: InputDecoration(
                                  hintText: 'Примітки',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onChanged: (value) { notes = value; }
                              )
                            ),        
                          ]
                        )
                      ),

                      // Add button
                      Padding(
                        padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
                        child: FlatButton(
                          minWidth: 150.0,
                          child: Text("Додати", style: TextStyle(color: Colors.black87)),
                          onPressed: ()=>{ 
                            addToBox(),
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Soundings(widget.projectNumber))),
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black87,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ), 
                        ),
                      )
                    
                    ],
                  ),
                ),
              ),
              
              bottomNavigationBar: Bottom(),
            ); 
        }
      }     
    );
    
  }

}