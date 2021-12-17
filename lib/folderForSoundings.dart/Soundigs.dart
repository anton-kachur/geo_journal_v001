import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';


var soundingsList = [];


/* *************************************************************************
 Classes for page with the list of soundings
************************************************************************* */
class Soundings extends StatefulWidget {
  Soundings();
  
  @override
  SoundingsState createState() => SoundingsState();
}


class SoundingsState extends State<Soundings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Точки статичного зондування'),
      ),

      body: Column(
        children: [
          if (soundingsList.length > 0)
            for (var i in soundingsList)
              i,
          Text(''),
        ]
      ),

      bottomNavigationBar: Bottom(),
    );
  }
}