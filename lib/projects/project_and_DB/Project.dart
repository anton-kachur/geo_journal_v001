import 'package:flutter/material.dart';
import 'package:geo_journal_v001/projects/ProjectPage.dart';


/* *************************************************************************
 Classes for project
************************************************************************* */
class Project extends StatefulWidget {
  var name;
  var number;
  var date;
  var notes;

  Project(this.name, this.number, this.date, this.notes);

  Project.blank();
  Project.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    number = json['number'],
    date = json['date'],
    notes = json['notes'];

  // Function for converting data to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'number': number,
    'date': date,
    'notes': notes,
  };
  
  @override
  ProjectState createState() => ProjectState();
}


class ProjectState extends State<Project>{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black45, width: 1.0),
            )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 0.0),
                child: Text('${widget.name}')
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.insert_drive_file),
                        Text('${widget.number}'),
                      ]
                    ),

                    SizedBox(width: 15.0),
                    
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded),
                        SizedBox(width: 3.0),
                        Text('${widget.date}'),
                      ]
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(150.0, 0.0, 0.0, 0.0),
                      child: IconButton(        
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => ProjectPage(
                              name: '${widget.name}', 
                              number: '${widget.number}', 
                              date: '${widget.date}',
                              notes: '${widget.notes}'
                            )
                            )
                          );
                        }
                      ),
                    )      
                  ]
                ) 
              )
            ]
          )
        )
      ]
    );
  }
}