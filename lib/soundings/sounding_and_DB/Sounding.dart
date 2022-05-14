import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/soundings/SoundingPage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../AppUtilites.dart';


/* *************************************************************************
 Classes for sounding
************************************************************************* */
class Sounding extends StatefulWidget {
  final depth;
  final qc;
  final fs;
  final notes;
  final image;

  final projectNumber;  // number of project, to which the well belongs

  Sounding(this.depth, this.qc, this.fs, this.notes, this.projectNumber, this.image);
  
  @override
  SoundingState createState() => SoundingState();
}


class SoundingState extends State<Sounding>{
  var box;
  var image;

  
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
  }


  // Check current account
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
    var projects = (await currentAccount).projects;
    var soundings;

    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {

        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            soundings = project.soundings;

            for (var sounding in soundings) {
              if (sounding.depth == widget.depth) {

                soundings.removeWhere((item) => item.depth == widget.depth);
    
                projects[projects.indexOf(project)] = ProjectDescription(
                  project.name, 
                  project.number,
                  project.date,
                  project.address,
                  project.notes, 
                  project.wells, 
                  soundings
                );

                box.put(
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

          }
        }

      }
    }
  }


  
  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();

    return FutureBuilder(
      future: boxData,  // data, retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Container(

              decoration: BoxDecoration(
                border: Border(
                bottom: BorderSide(color: Colors.black45, width: 1.0),
                )
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // Main sounding data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                        child: Text('Глибина: ${widget.depth} м')
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: Text('qc: ${widget.qc} МПа'),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: Text('fs: ${widget.fs} кПа'),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                        child: Container(
                          width: 180,
                          child: Text('Нотатки: ${widget.notes}'),
                        )
                      )
                    ]
                  ),


                  Row(
                    children: [
                      
                      // Move to sounding editing page
                      IconButton(        
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        icon: Icon(Icons.edit, size: 23),
                        onPressed: () {

                          if (currentAccountIsRegistered) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoundingData.edit(widget.projectNumber, widget.depth, 'edit')));
                          } else {
                            attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                          }

                        }
                      ),


                      // Delete sounding
                      IconButton(        
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        icon: Icon(Icons.delete, size: 23),
                        onPressed: () {
                          
                          if (currentAccountIsRegistered) {
                            onDeleteAlert(context, 'дану точку', deleteElementInBox, materialPageRoute: Soundings(widget.projectNumber));
                            setState(() { });
                          } else {
                            attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
                          }
                          
                        }
                      ),


                      // Move to chart page
                      IconButton(    
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,

                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 13.0, 0.0),

                        icon: Icon(Icons.show_chart, size: 24),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => SoundingsPage(widget.projectNumber)
                            )
                          );
                        }
                      ),
                      
                      
                    ]
                  ),

                ]
              )
            );
        }
      }
    );   
  }

}