import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForWells/AddSoilSample.dart';
import 'package:geo_journal_v001/folderForWells/SoilSample.dart';


var probesList = [];


/* *************************************************************************
 Classes for well page
************************************************************************* */
class WellPage extends StatefulWidget {
  WellPage();
  
  @override
  WellPageState createState() => WellPageState();
}


class WellPageState extends State<WellPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Проби грунту'),
      ),

      body: Column(
        children: [
          if (probesList.length > 0)
            for (var i in probesList)
              i,
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Додати пробу", style: TextStyle(color: Colors.black87)),
              onPressed: ()=>{
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoilSample()))
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