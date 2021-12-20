import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForSoundings.dart/Soundigs.dart';
import 'package:geo_journal_v001/folderForSoundings.dart/Sounding.dart';


/* *************************************************************************
 Classes for page where you can add description of the new sounding
************************************************************************* */
class AddSoundingData extends StatefulWidget {
  AddSoundingData();
  
  @override
  AddSoundingDataState createState() => AddSoundingDataState();
}


class AddSoundingDataState extends State<AddSoundingData>{
  var depth;
  var qc;
  var fs; 
  var notes; 

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
        title: Text('Ввести дані'),
      ),

      body: Column(
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

                    decoration: InputDecoration(
                      hintText: 'Глибина',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.depth = value; }
                  )
                ),

                // Text field for qc input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      hintText: 'Ввести qc',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.qc = value; }
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
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                      hintText: 'Ввести fs',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.fs = value; }
                  )
                ),   

                // Text field for notes input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      hintText: 'Примітки',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { this.notes = value; }
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

  // Function for adding new sounding to list
  Widget addToList() {
    soundingsList.add(Sounding(this.depth, this.qc, this.fs, this.notes));
    return Text('');
  }
}