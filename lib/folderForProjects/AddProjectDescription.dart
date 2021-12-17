import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForProjects/Projects.dart';
import 'package:geo_journal_v001/folderForProjects/Project.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* *************************************************************************
 Classes for page where you can add description of the new project
************************************************************************* */
class AddProjectDescription extends StatefulWidget {
  AddProjectDescription();
  
  @override
  AddProjectDescriptionState createState() => AddProjectDescriptionState();
}


class AddProjectDescriptionState extends State<AddProjectDescription>{
  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;

  late FocusNode _focusNode;
  SharedPref sharedPref = SharedPref();
  Project projectSave = Project.blank();
  Project projectLoad = Project.blank();
  
  loadSharedPrefs() async {
    try {
      Project proj = Project.fromJson(await sharedPref.read("project"));
      setState(() {
        this.projectLoad = proj;
        projectsList.add(projectLoad);
      });
    } catch (Excepetion) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Nothing found!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var TextFieldStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Ввести опис проекту'),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      focusNode: _focusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'Назва проекту',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        projectSave.name = value;
                      }
                    )
                  ),

                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'номер проекту',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        projectSave.number = value;
                      }

                    )
                  ),        
                ]
              )
            ),



            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'дата завершення (ДД-ММ-РРРР)',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        projectSave.date = value;
                      }

                    )
                  ),

                  Container(
                    width: this.textFieldWidth,
                    height: this.textFieldHeight,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.done,

                      decoration: InputDecoration(
                        hintText: 'помітки',
                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                        
                        focusedBorder: TextFieldStyle,
                        enabledBorder: TextFieldStyle,
                      ),
                      
                      onChanged: (value) {
                        projectSave.notes = value;
                      }

                    )
                  ),           
                ]
              )
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
              child: FlatButton(
                minWidth: 150.0,
                child: Text("Додати", style: TextStyle(color: Colors.black87)),
                onPressed: () {
                  sharedPref.save("project", projectSave);
                  loadSharedPrefs();
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black87,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ), 
              ),
            )
            
          ]
        ),

        bottomNavigationBar: Bottom(),
    );
  }
}



class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)?? '');
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}