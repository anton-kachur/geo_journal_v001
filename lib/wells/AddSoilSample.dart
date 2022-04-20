import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSample.dart';
import 'package:geo_journal_v001/wells/WellPage.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add soil sample with description
************************************************************************* */
class AddSoilSample extends StatefulWidget {
  var wellNumber; // number of well, to which the soil sample belongs
  var projectNumber; // number of project, to which the soil sample belongs

  AddSoilSample(this.wellNumber, this.projectNumber);
  
  @override
  AddSoilSampleState createState() => AddSoilSampleState();
}


class AddSoilSampleState extends State<AddSoilSample>{
  var name;
  var depthStart;
  var depthEnd;
  var notes;  

  var boxSize;
  var box;

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
    box = await Hive.openBox<SoilForWellDescription>('well_soil_samples');
    boxSize = box.length;

    return Future.value(box.values);     
  }


  // Function for adding data to database
  Widget addToBox() {
    box.put('soil_sample${boxSize+2}', SoilForWellDescription(name, depthStart, depthEnd, notes, widget.wellNumber, widget.projectNumber));
    
    return Text('');
  }


  // Function for deleting data in database
  Widget deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == name) {
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
                title: Text('Ввести дані грунту'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Text field block for soil type and start depth
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        // Text field for soil type input
                        Container(
                          width: this.textFieldWidth,
                          height: this.textFieldHeight,
                          child: TextFormField(
                            focusNode: _focusNode,
                            autofocus: false,
                            textInputAction: TextInputAction.next,

                            cursorRadius: const Radius.circular(10.0),
                            cursorColor: Colors.black,

                            decoration: InputDecoration(
                              labelText: 'Тип грунту',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              
                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { name = value; }
                          )
                        ),

                        // Text field for start depth input
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
                              labelText: 'Початкова глибина',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { depthStart = value.toString(); }
                          )
                        ),        
                      ]
                    )
                  ),
                  
                  // Text field block for final depth and notes
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        // Text field for final depth input
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
                              labelText: 'Кінцева глибина',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { depthEnd = value.toString(); }
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
                  
                  button(functions: [addToBox], text: "Додати"),

                ]
              ),

              bottomNavigationBar: Bottom(),
            );
        }
      }
    );
  }

}