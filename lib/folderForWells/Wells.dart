import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';


var wellsList = [];


/* *************************************************************************
 Classes for page with the list of wells
************************************************************************* */
class Wells extends StatefulWidget {
  Wells();
  
  @override
  WellsState createState() => WellsState();
}


class WellsState extends State<Wells>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Свердловини'),
      ),

      body: Column(
        children: [
          if (wellsList.length > 0)
            for (var i in wellsList)
              i,
          Text(''),
        ]
      ),

      bottomNavigationBar: Bottom(),
    );
  }
}