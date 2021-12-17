import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForWells/Well.dart';
import 'package:geo_journal_v001/folderForWells/Wells.dart';

/* *************************************************************************
 Classes for page where you can add description of the new project
************************************************************************* */
class AddData extends StatefulWidget {
  AddData();
  
  @override
  AddDataState createState() => AddDataState();
}


class AddDataState extends State<AddData>{
  var number='';
  var date='';
  var latitude = '';
  var longtitude = '';
  

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
  
  printAll() {
    return 'Pumping №${number}, date: ${date}, coordinates: (${latitude}, ${longtitude})\n'; 
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
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.number = value;
                        print("Number entered : ${this.number}");
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
                        hintText: 'Дата буріння (ДД-ММ-РРРР)',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.date = value;
                        print("date entered : ${this.date}");
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
                        hintText: 'Широта',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.latitude = value;
                        print("Latitude entered : ${this.latitude}");
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
                        hintText: 'Довгота',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        this.longtitude = value;
                        print("Longtitude entered : ${this.longtitude}");
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
                  printAll(),
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
    wellsList.add(Well(this.number, this.date, this.latitude, this.longtitude));
    return Text('');
  }
}