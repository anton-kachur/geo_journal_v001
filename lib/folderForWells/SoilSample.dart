import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForWells/WellPage.dart';


/* *************************************************************************
 Classes for project in soil samples' list
************************************************************************* */
class SoilSample extends StatefulWidget {
  var name;
  var depthStart;
  var depthEnd;
  var notes;

  SoilSample(this.name, this.depthStart, this.depthEnd, this.notes);
  
  @override
  SoilSampleState createState() => SoilSampleState();
}


class SoilSampleState extends State<SoilSample>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            width: 400.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black45, width: 1.0),
              )
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                  child: Text('${widget.name}')
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                  child: Text('${widget.depthStart}-${widget.depthEnd} м'),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 8.0),
                  child: Text('Примітки: ${widget.notes}'),
                ),
              ]
            )
          )
        ]
      );
  }
}