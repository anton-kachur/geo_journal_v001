import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/wells/Wells.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add new well with description
************************************************************************* */
class AddWellDescription extends StatefulWidget {
  final projectNumber;  // number of project, to which the well belongs
  AddWellDescription(this.projectNumber);
  
  @override
  AddWellDescriptionState createState() => AddWellDescriptionState();
}


class AddWellDescriptionState extends State<AddWellDescription>{
  var number;
  var date;
  var latitude;
  var longtitude;

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
    box = await Hive.openBox<WellDescription>('s_wells');
    boxSize = box.length;

    return Future.value(box.values);     
  }


  // Function for adding data to database
  Widget addToBox() {
    box.put('well${boxSize+2}', WellDescription(number, date, latitude, longtitude, widget.projectNumber));
    
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
      if ((box.get(key)).number == number) {
        box.delete(key);
      }
    }
      
    box.close();
    return Text('');
  }


  // Redirect to page with list of wells
  void redirect() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Wells(widget.projectNumber)));
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
                title: Text('Ввести дані свердловини'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        // Text field for well number input
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
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],

                            decoration: InputDecoration(
                              labelText: 'Номер свердловини',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { number = value; }
                          )
                        ),

                        // Text field for drilling date input
                        Container(
                          width: this.textFieldWidth,
                          height: this.textFieldHeight,
                          child: TextFormField(
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            
                            cursorRadius: const Radius.circular(10.0),
                            cursorColor: Colors.black,

                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                            ],

                            decoration: InputDecoration(
                              labelText: 'Дата буріння (ДД-ММ-РРРР)',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { date = value; }
                          )
                        ),        
                      ]
                    )
                  ),

                  // Block with text fields for latitude and longtitude
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text field for latitude input
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
                              hintText: 'Широта',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { latitude = double.parse(value); }
                          )
                        ),

                        // Text field for longtitude input
                        Container(
                          width: this.textFieldWidth,
                          height: this.textFieldHeight,
                          child: TextFormField(
                            autofocus: false,
                            textInputAction: TextInputAction.done,
                            
                            cursorRadius: const Radius.circular(10.0),
                            cursorColor: Colors.black,

                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                            ],

                            decoration: InputDecoration(
                              labelText: 'Довгота',
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              focusedBorder: textFieldStyle,
                              enabledBorder: textFieldStyle,
                            ),
                            
                            onFieldSubmitted: (String value) { longtitude = double.parse(value); }
                          )
                        ),           
                      ]
                    )
                  ),
                  
                  button(functions: [addToBox, redirect], text: "Додати"),
                  
                ]
              ),

              bottomNavigationBar: Bottom(),
            );
          }
        }
    );
  }

}