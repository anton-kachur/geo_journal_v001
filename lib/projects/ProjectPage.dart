import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/AddWellDescription.dart';
import 'package:geo_journal_v001/wells/Wells.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page of additional project
************************************************************************* */
class ProjectPage extends StatefulWidget {
  final String name;
  final String number;
  final String date;
  final String notes;

  const ProjectPage({Key? key, required this.name, required this.number, required this.date, required this.notes}): super(key: key);
  
  @override
  ProjectPageState createState() => ProjectPageState();

}


class ProjectPageState extends State<ProjectPage> {


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
                      Text('Номер: ${widget.number}'),
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
                        Text('Свердловини і точки ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('наскрізного зондування', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                        Text('Свердловини'),
                        Row(
                          children: [
                            buttonConstructor(Icons.view_list_rounded, route: Wells(widget.number)),
                            buttonConstructor(Icons.add_circle_outline, route: AddWellDescription(widget.number)),
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
                            buttonConstructor(Icons.view_list_rounded, route: Soundings(widget.number)),
                            buttonConstructor(Icons.add_circle_outline, route: AddSoundingData(widget.number)),
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

      bottomNavigationBar: Bottom.dependOnPage("project_page", widget.name),
    );
  }

  // Function for creating button widget
  Widget buttonConstructor(icon_type, {route}) {
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