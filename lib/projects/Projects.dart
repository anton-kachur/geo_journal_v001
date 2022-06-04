import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page with the list of projects
************************************************************************* */
class Projects extends StatefulWidget {
  
  @override
  ProjectsState createState() => ProjectsState();
}


class ProjectsState extends State<Projects>{
  var box;
  
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    
    try {
      for (var key in box.keys) {
        if (box.get(key).login == (await currentAccount).login) {

          return Future.value(box.get(key));  
        
        }
      }
    } catch (e) {
      
    }
  }


  // Sort list of projects
  List<ProjectDescription> sortArray(List<ProjectDescription> array) {
    array.sort((a, b) => a.number.compareTo(b.number));

    return array;
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
                      
                      // output projects' list
                      if (currentAccount != null && snapshot.data != null)
                        for (var element in sortArray(snapshot.data.projects))
                          Project(element.name, element.number, element.date, element.address, element.notes)
                      else 
                        Project('тест', '1', '31/12/2023', 'вул. Велика Васильківська, Київ', 'Тестовий проект для прикладу'),
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



