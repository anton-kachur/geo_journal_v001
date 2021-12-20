import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForWells/Well.dart';
import 'package:geo_journal_v001/folderForWells/Wells.dart';


/* *************************************************************************
 Classes for page where you can add new well with description
************************************************************************* */
class AddWellDescription extends StatefulWidget {
  AddWellDescription();
  
  @override
  AddWellDescriptionState createState() => AddWellDescriptionState();
}


class AddWellDescriptionState extends State<AddWellDescription>{
  var number;
  var date;
  var latitude;
  var longtitude;

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

  @override
  Widget build(BuildContext context) {

    // Text field decoration
    OutlineInputBorder textFieldStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Ввести дані свердловини'),
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

                    decoration: InputDecoration(
                      hintText: 'Номер свердловини',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) {
                      this.number = value;
                    }
                  )
                ),

                // Text field for drilling date input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      hintText: 'Дата буріння (ДД-ММ-РРРР)',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.date = value; }
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

                    decoration: InputDecoration(
                      hintText: 'Широта',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.latitude = value; }
                  )
                ),

                // Text field for longtitude input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                      hintText: 'Довгота',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.longtitude = value; }
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
              onPressed: ()=>{ addToList() },
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
        ]
      ),

      bottomNavigationBar: Bottom(),
    );
  }

  // Function for adding new well to list
  Widget addToList() {
    wellsList.add(Well(this.number, this.date, this.latitude, this.longtitude));
    return Text('');
  }
}