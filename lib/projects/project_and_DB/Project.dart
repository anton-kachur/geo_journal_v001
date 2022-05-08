import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/AddProjectDescription.dart';
import 'package:geo_journal_v001/projects/ProjectPage.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for project
************************************************************************* */
class Project extends StatefulWidget {
  final name;
  final number;
  final date;
  final notes;

  Project(this.name, this.number, this.date, this.notes);
  
  @override
  ProjectState createState() => ProjectState();
}


class ProjectState extends State<Project>{
  var thisProjectBox;
  var projectSoundingsBox;
  var projectWellsBox;
  var projectSoilSamplesBox;


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    thisProjectBox = await Hive.openBox(boxName);
    //projectSoundingsBox = await Hive.openBox<SoundingDescription>('s_soundings');
    //projectWellsBox = await Hive.openBox<WellDescription>('s_wells');
    //projectSoilSamplesBox = await Hive.openBox<SoilForWellDescription>('well_soil_samples');

    return Future.value(thisProjectBox.values);     
  }


  Future<bool> checkAccount(var account) async {
    return (account.login == (await currentAccount).login &&
        account.password == (await currentAccount).password &&
        account.email == (await currentAccount).email &&
        account.phoneNumber == (await currentAccount).phoneNumber &&
        account.position == (await currentAccount).position &&
        account.isAdmin == (await currentAccount).isAdmin)? Future<bool>.value(true): Future<bool>.value(false);
  }


  // Function for deleting data in database
  deleteElementInBox() async {
    for (var key in thisProjectBox.keys) {
      if ((await checkAccount(thisProjectBox.get(key))) == true) {
        
        var projects = (await currentAccount).projects;
        print("$projects");

        projects.removeWhere((item) => item.name == widget.name);
    
            thisProjectBox.put(
              key, UserAccountDescription(
              (await currentAccount).login,
              (await currentAccount).password,
              (await currentAccount).email,
              (await currentAccount).phoneNumber,
              (await currentAccount).position,
              true,
              (await currentAccount).isAdmin,
              projects
              )
            );

      }
    }

    /*// Find SOUNDINGS, connected with project in database and delete them
    for (var key in projectSoundingsBox.keys) {
      if ((projectSoundingsBox.get(key)).projectNumber == widget.number) { projectSoundingsBox.delete(key); }
    }
    
    // Find WELLS, connected with project in database and delete them
    for (var wellKey in projectWellsBox.keys) {

      if ((projectWellsBox.get(wellKey)).projectNumber == widget.number) {

        // If we find specific wells, then find SOIL SAMPLES, connected with those wells in database and delete them
        for (var key in projectSoilSamplesBox.keys) {
          if ((projectSoilSamplesBox.get(key)).wellNumber == projectWellsBox.get(wellKey).number && widget.number == projectSoilSamplesBox.get(key).projectNumber) {
            projectSoilSamplesBox.delete(key);
          }
        }
        
        projectWellsBox.delete(wellKey); // Delete well
      }   
    }

    // Find PROJECT in database and delete it
    for (var key in thisProjectBox.keys) {
      if ((thisProjectBox.get(key)).number == widget.number) { thisProjectBox.delete(key); }
    }*/
        
  }



  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox('accounts_data');


    return FutureBuilder(
      future: boxData,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
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
                        child: Row(
                          children: [
                            Text('${widget.name}'),
                            
                            SizedBox(width: 15.0),
                            
                            Text('id: ${widget.number}'),
                          ]
                        )
                      ),
                      

                      Padding(
                        padding: EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                        child: Row(
                          children: [
                                
                            Icon(Icons.calendar_today),
                            SizedBox(width: 3.0),
                            Text('${widget.date}'),
                          

                            SizedBox(width: 10.0),
                            
                            IconButton(        
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,

                              icon: Icon(Icons.edit, size: 23),
                              onPressed: () {
                                if (currentAccountIsRegistered) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(value: "project_page", projectName: widget.name, mode: 'edit')));
                                } else {
                                  attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                                }
                              }
                            ),

                            IconButton( 
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,

                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 26.0, 0.0),
                              splashRadius: 15.0,
                              icon: Icon(Icons.delete, size: 23),
                              onPressed: () {
                                if (currentAccountIsRegistered) {
                                  onDeleteAlert(context, 'даний проект', deleteElementInBox, route: '/projects_page');
                                } else {
                                  attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                                }
                              },
                            ),

                            IconButton(    
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,

                              padding: EdgeInsets.fromLTRB(100.0, 0.0, 0.0, 30.0),

                              icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => ProjectPage(
                                    '${widget.name}', 
                                    '${widget.number}', 
                                    '${widget.date}',
                                    '${widget.notes}'
                                  )
                                  )
                                );
                              }
                            ),

                          ]
                        ) 
                      ),

                    ]
                  )
                ),

              ]
            );
            
        }
      }
    );
  }
  
}