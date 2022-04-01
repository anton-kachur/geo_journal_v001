import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page with the list of projects
************************************************************************* */
class Projects extends StatefulWidget {
  Projects();
  
  @override
  ProjectsState createState() => ProjectsState();
}


class ProjectsState extends State<Projects>{
  var box;
  var box_size;

  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    var boxx = await Hive.openBox<ProjectDescription>(boxName);
    box_size = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }


  Widget waitingOrErrorWindow(var text, var context) {
    return Container(
      height: MediaQuery.of(context).size.height, 
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(130, MediaQuery.of(context).size.height/2, 0.0, 0.0),

        child: Text(
          text,
          style: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.black),
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox('s_projects');

    return FutureBuilder(
      future: boxData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Проекти')),

              body: Column(
                children: [
                  for (var element in snapshot.data)
                    Project(element.name, element.number, element.date, element.notes),
                  
                ]
              ),
              
              bottomNavigationBar: Bottom.dependOnPage('projects'),
            );
        }
      }
    );
  }
}
