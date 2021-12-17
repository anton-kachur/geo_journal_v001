import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForSoundings.dart/AddSoundingData.dart';
import 'package:geo_journal_v001/folderForSoundings.dart/Soundigs.dart';
import 'package:geo_journal_v001/folderForWells/AddWellDescription.dart';
import 'package:geo_journal_v001/folderForWells/Wells.dart';

/* *************************************************************************
 Classes for page of additional project
************************************************************************* */
class ProjectPage extends StatefulWidget {
  var name;
  var number;
  var date;
  var notes;

  ProjectPage(this.name, this.number, this.date, this.notes);
  
  @override
  ProjectPageState createState() => ProjectPageState();
}


class ProjectPageState extends State<ProjectPage> {
  ProjectPageState();

  @override
  Widget build(BuildContext context) {
    var dateNow = DateTime.now();
    var dateToEnd = DateTime(
      int.tryParse(widget.date.substring(6, 10)) ?? 0, 
      int.tryParse(widget.date.substring(3, 5)) ?? 0, 
      int.tryParse(widget.date.substring(0, 2)) ?? 0,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(widget.name),
        ),

        body: Column(
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black45, width: 1.0),
                )
              ),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 8.0),
                    child: Row(
                      children: [
                        Text('id: ${widget.number}'),
                        SizedBox(width: 15.0),
                        Text('Дата закінчення: ${widget.date}'),
                      ]
                    ) 
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 8.0),
                    child: Row(
                      children: [
                        Text('До закінчення (днів): ${dateToEnd.difference(dateNow).inDays}'),
                      ]
                    ) 
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Примітки: '),
                        Text('${widget.notes}'),
                      ],
                    ),
                  ),
                ]
              )
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Свердловини, відкачки і', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('точки наскрізного', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('зондування', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ]
                      )
                    ]
                  ) 
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Сверловини'),
                          Row(
                            children: [
                              buttonConstructor(Icons.view_list_rounded, Wells()),
                              buttonConstructor(Icons.add_circle_outline, AddWellDescription()),
                              buttonConstructor(Icons.edit),
                            ],
                          ),
                        ]
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Точки статичного зондування'),
                          Row(
                            children: [
                              buttonConstructor(Icons.view_list_rounded, Soundings()),
                              buttonConstructor(Icons.add_circle_outline, AddSoundingData()),
                              buttonConstructor(Icons.edit),
                            ],
                          ),
                        ]
                      ),
                    ]
                  ) 
                ),

              ]
            )
          ]
        ),

        bottomNavigationBar: Bottom(),
      );
  }

  
  Widget buttonConstructor(icon_type, [route]) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: ClipRRect (
        borderRadius: BorderRadius.circular(4.0),
        child: IconButton(  
            color: Colors.black,
            padding: EdgeInsets.all(0.0),
            icon: Icon(icon_type, size: 25.0),
            onPressed: ()=>{
               Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => route),
               )
            },
          )
      )
    );
  }
}