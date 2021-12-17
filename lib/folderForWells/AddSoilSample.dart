import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForWells/SoilSample.dart';
import 'package:geo_journal_v001/folderForWells/Well.dart';
import 'package:geo_journal_v001/folderForWells/Wells.dart';
import 'package:geo_journal_v001/folderForWells/WellPage.dart';

/* *************************************************************************
 Classes for page where you can add soil sample and its description
************************************************************************* */
class AddSoilSample extends StatefulWidget {
  AddSoilSample();
  
  @override
  AddSoilSampleState createState() => AddSoilSampleState();
}


class AddSoilSampleState extends State<AddSoilSample>{
  var name;
  var depthStart;
  var depthEnd;
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
    var TextFieldStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Ввести дані грунту'),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      focusNode: _focusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'Тип грунту',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.name = value;
                      }
                    )
                  ),

                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'Початкова глибина',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.depthStart = value;
                      }

                    )
                  ),        
                ]
              )
            ),



            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'Кінцева глибина',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.depthEnd = value;
                      }

                    )
                  ),

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
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.notes = value;
                      }

                    )
                  ),           
                ]
              )
            ),

            

            Padding(
              padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
              child: FlatButton(
                minWidth: 150.0,
                child: Text("Додати", style: TextStyle(color: Colors.black87)),
                onPressed: ()=>{
                  addToList()
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
          ]
        ),

        bottomNavigationBar: Bottom(),
    );
  }


  addToList() {
    probesList.add(SoilSample(this.name, this.depthStart, this.depthEnd, this.notes));
    return Text('');
  }
}