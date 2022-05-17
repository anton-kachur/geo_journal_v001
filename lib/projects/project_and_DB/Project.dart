import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/AddProjectDescription.dart';
import 'package:geo_journal_v001/projects/ProjectPage.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for project
************************************************************************* */
class Project extends StatefulWidget {
  final name;
  final number;
  final date;
  final address;
  final notes;

  Project(this.name, this.number, this.date, this.address, this.notes);
  
  @override
  ProjectState createState() => ProjectState();
}


class ProjectState extends State<Project>{
  var box;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    
    return Future.value(box.values);     
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
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        var projects = (await currentAccount).projects;
        print("$projects");

        projects.removeWhere((item) => item.name == widget.name);
    
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



  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data retreived from database
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
                children: [

                  Container(
                    width: 312,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Project name, id and address
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${widget.name}      id: ${widget.number}\n${widget.address}'),
                              ]
                            )
                          ),
                        ),
                        

                        Padding(
                          padding: EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                
                                // Project end date
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(Icons.calendar_today)
                                          ),
                                          
                                          TextSpan(text: ' ${widget.date}  '),
                                        ]
                                      )
                                    ),
                                  ) 
                                ),
                                
                                
                                // Move to project editing page
                                WidgetSpan(
                                  child: IconButton(        
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
                                ),
                                

                                // Delete project 
                                WidgetSpan(
                                  child: IconButton( 
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
                                )

                              ]
                            ),
                          ),
                  
                        ),

                      ]
                    )
                  ),


                  // Move to project page
                  IconButton(    
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,

                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),

                    icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ProjectPage(
                          widget.name, widget.number, widget.date,
                          widget.address, widget.notes
                        )
                        )
                      );
                    }
                  ),

                ]
              )
            );
            
        }
      }
    );
  }
  
}