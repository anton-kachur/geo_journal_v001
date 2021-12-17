import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';


var samplesList = [];


/* *************************************************************************
 Classes for sounding page with the list of soil samples
************************************************************************* */
class SoundingPage extends StatefulWidget {
  SoundingPage();
  
  @override
  SoundingPageState createState() => SoundingPageState();
}


class SoundingPageState extends State<SoundingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Дані'),
      ),

      body: Column(
        children: [
          if (samplesList.length > 0)
            for (var i in samplesList)
              i,
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Додати дані", style: TextStyle(color: Colors.black87)),
              onPressed: ()=>{
                //Navigator.push(context, MaterialPageRoute(builder: (context) => AddData()))
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
}