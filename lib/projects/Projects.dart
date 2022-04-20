import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../AppUtilites.dart';


/* *************************************************************************
 Classes for page with the list of projects
************************************************************************* */
class Projects extends StatefulWidget {
  Projects();
  
  @override
  ProjectsState createState() => ProjectsState();
}


class ProjectsState extends State<Projects>{
  var boxSize;
  var box;
  
  
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox<ProjectDescription>('s_projects');
    boxSize = box.length;
    
    return Future.value(box.values);     
  }



  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox();
    

    return FutureBuilder(
      future: boxData,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
        if (snapshot.hasError) {
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          } else
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('Проекти'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      // output projects list
                      for (var element in snapshot.data)
                        Project(element.name, element.number, element.date, element.notes),
                      
                    ]
                  ),
                )
              ), 
              
              bottomNavigationBar: Bottom('projects'),
            );
        }
      }
    );
  }
  
}
