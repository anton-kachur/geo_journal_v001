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
  var projectNumber;  // number of project, to which the sounding belongs
  
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
    box = await Hive.openBox<SoundingDescription>('s_soundings');
    boxSize = box.length;

    return Future.value(box.values);     
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
                title: Text('Ввести дані'),
                automaticallyImplyLeading: false
              ),

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

                                cursorRadius: const Radius.circular(10.0),
                                cursorColor: Colors.black,

                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  labelText: 'Глибина',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onFieldSubmitted: (String value) { depth = double.parse(value); }
                              )
                            ),
                            

                            // Text field for qc input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.next,

                                cursorRadius: const Radius.circular(10.0),
                                cursorColor: Colors.black,

                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  labelText: 'Ввести qc',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onFieldSubmitted: (String value) { qc = double.parse(value); }
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

                                cursorRadius: const Radius.circular(10.0),
                                cursorColor: Colors.black,
                                
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                ],

                                decoration: InputDecoration(
                                  labelText: 'Ввести fs',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onFieldSubmitted: (String value) { fs = double.parse(value); }
                              )
                            ),   

                            // Text field for notes input
                            Container(
                              width: this.textFieldWidth,
                              height: this.textFieldHeight,
                              child: TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.done,

                                cursorRadius: const Radius.circular(10.0),
                                cursorColor: Colors.black,

                                decoration: InputDecoration(
                                  labelText: 'Примітки',
                                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                  
                                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  
                                  focusedBorder: textFieldStyle,
                                  enabledBorder: textFieldStyle,
                                ),
                                
                                onFieldSubmitted: (String value) { notes = value; }
                              )
                            ),        
                          ]
                        )
                      ),
                      
                      button(functions: [addToBox], text: "Додати", context: context, route: 'soundings', routingArgs: [widget.projectNumber]),
                    
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