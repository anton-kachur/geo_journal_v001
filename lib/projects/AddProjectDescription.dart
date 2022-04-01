import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add description of the new project
************************************************************************* */
class AddProjectDescription extends StatefulWidget {
  var value;
  var projectName;

  AddProjectDescription([this.value = 'projects', this.projectName = '']);
  
  @override
  AddProjectDescriptionState createState() => AddProjectDescriptionState();
}


class AddProjectDescriptionState extends State<AddProjectDescription>{
  var name;
  var number;
  var date;
  var notes;

  var boxSize;
  var box;


  var textFieldWidth = 135.0;
  var textFieldHeight = 32.0;

  late FocusNode _focusNode;
  Project projectSave = Project.blank();
  Project projectLoad = Project.blank();
  

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



  // Function for getting data from Hive database
  Future getDataFromBox() async {
    var boxx;
    
    boxx = await Hive.openBox<ProjectDescription>('s_projects');
    
    boxSize = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    box.put('project${boxSize+2}', ProjectDescription(name, number, date, notes));
    
    box.close();
    return Text('');
  }


  // Function for changing data in database
  Widget changeElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == widget.projectName) {

        box.put(key, ProjectDescription(name, number, date, notes));
      }
    }

    return Text('');
  }


  // Function for deleting data in database
  Widget deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == widget.projectName) {
        box.delete(key);
      }
    }
      
    box.close();
    return Text('');
  }


  getPageName() {
    if (widget.value == 'projects') return 'Ввести опис проекту';
    else if (widget.value == 'project_page') return 'Редагувати проект';
  }


    
  textFieldForAdd() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Text field block for project name and number
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Text field for project name input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    focusNode: _focusNode,
                    autofocus: false,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      hintText: (widget.value == 'project_page' && widget.projectName != '')? widget.projectName.toString() : 'Назва проекту',
                      hintStyle: (widget.value == 'project_page' && widget.projectName != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade500),
                      
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { 
                      name = value;    
                    }
                  )
                ),

                // Text field for project number input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],

                    decoration: InputDecoration(
                      hintText: 'Номер проекту',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { number = value; }
                  )
                ),        
              ]
            )
          ),

          // Text field block for end date and notes
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Text field for end date input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    ],

                    decoration: InputDecoration(
                      hintText: 'дата завершення (ДД-ММ-РРРР)',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { date = value; }
                  )
                ),

                // Text field for notes input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                      hintText: 'Помітки',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { notes = value; }
                  )
                ),           
              ]
            )
          ),    
        ]
      );
  }


  // Delete element from DB
  textFieldForDelete() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text('Видалити елемент'),
          
          /*Padding(
            padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                      hintText: 'Назва проекту',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { 
                      name = value; 
                    }
                  )
                ),

                
              ]
            ),
          ),*/

          
          
          // Add button
          Padding(
            padding: EdgeInsets.fromLTRB(90.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Видалити", style: TextStyle(color: Colors.black87)),
              onPressed: () => { 
                deleteElementInBox(),
                Navigator.push(context, MaterialPageRoute(builder: (context) => Projects())),
                /*setState(() {
                  
                })*/
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
      )
    );
  }



  // Change element from DB
  textFieldForChange() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text('Редагувати елемент'),
          
          textFieldForAdd(),

          // Add button
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Додати", style: TextStyle(color: Colors.black87)),
              onPressed: () {
                changeElementInBox();
                setState(() {});
                Navigator.push(context, MaterialPageRoute(builder: (context) => Projects()));
                //
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
      )
    );
  }


  // Add element to DB
  addProjectTextField() {
    return Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text('Додати елемент'),

              textFieldForAdd(),

              // Add button
              Padding(
                padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
                child: FlatButton(
                  minWidth: 150.0,
                  child: Text("Додати", style: TextStyle(color: Colors.black87)),
                  onPressed: () {
                    addToBox();
                    setState(() {});
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

            ],
          ),
        );
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
    var boxData = getDataFromBox();


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
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('${getPageName()}')),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      
                      if (widget.value == 'projects') addProjectTextField(),
                      if (widget.value == 'project_page') textFieldForChange(),
                      if (widget.value == 'project_page') textFieldForDelete(),

                    
                    ],
                  ),
                ),
              ),
              
              bottomNavigationBar: Bottom(),
            ); 
        }
      }     
    ); 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Ввести опис проекту'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Text field block for project name and number
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Text field for project name input
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
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { projectSave.name = value; }
                  )
                ),

                // Text field for project number input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],

                    decoration: InputDecoration(
                      hintText: 'Номер проекту',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { projectSave.number = value; }
                  )
                ),        
              ]
            )
          ),

          // Text field block for end date and notes
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Text field for end date input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    ],

                    decoration: InputDecoration(
                      hintText: 'дата завершення (ДД-ММ-РРРР)',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { projectSave.date = value; }
                  )
                ),

                // Text field for notes input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,
                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                      hintText: 'Помітки',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onChanged: (value) { projectSave.notes = value; }
                  )
                ),           
              ]
            )
          ),

          // Add button
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Додати", style: TextStyle(color: Colors.black87)),
              onPressed: () {

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