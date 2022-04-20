import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add/edit project with description 
************************************************************************* */
class AddProjectDescription extends StatefulWidget {
  final value;
  final projectName;

  AddProjectDescription([this.value = 'projects', this.projectName = '']);
  
  @override
  AddProjectDescriptionState createState() => AddProjectDescriptionState();
}


class AddProjectDescriptionState extends State<AddProjectDescription>{
  var name;
  var number;
  var date;
  var notes;

  var box;
  var boxSize;
  

  var textFieldWidth = 135.0;
  var textFieldHeight = 32.0;

  late FocusNode _focusNode;
  

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
    box = await Hive.openBox<ProjectDescription>('s_projects');
    boxSize = box.length;

    return Future.value(box.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    box.put('project${boxSize+2}', ProjectDescription(name, number, date, notes));
    
    return Text('');
  }


  // Function for changing data in database
  Widget changeElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == widget.projectName) {

        box.put(
          key, 
          ProjectDescription(
            name == null? box.get(key).name : name, 
            number ==null? box.get(key).number : number,
            date == null? box.get(key).date : date,
            notes == null? box.get(key).notes : notes,
          )
        );
      
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


  // Function to set title of the add/edit page
  getPageName() {
    if (widget.value == 'projects') return 'Ввести опис проекту';
    else if (widget.value == 'project_page') return 'Редагувати проект';
  }


  // Create textfield for add page
  Widget textFieldForAdd() {

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

                    cursorRadius: const Radius.circular(10.0),
                    cursorColor: Colors.black,

                    decoration: InputDecoration(
                      labelText: (widget.value == 'project_page' && widget.projectName != '')? widget.projectName.toString() : 'Назва проекту',
                      hintStyle: (widget.value == 'project_page' && widget.projectName != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      labelStyle: (widget.value == 'project_page' && widget.projectName != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onFieldSubmitted: (String value) { name = value; }

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

                    cursorRadius: const Radius.circular(10.0),
                    cursorColor: Colors.black,

                    decoration: InputDecoration(
                      labelText: 'Номер проекту',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onFieldSubmitted: (String value) { number = value; }
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

                    cursorRadius: const Radius.circular(10.0),
                    cursorColor: Colors.black,

                    decoration: InputDecoration(
                      labelText: 'дата завершення (ДД-ММ-РРРР)',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onFieldSubmitted: (String value) { date = value; }
                  )
                ),

                // Text field for notes input
                Container(
                  width: this.textFieldWidth,
                  height: this.textFieldHeight,

                  child: TextFormField(
                    autofocus: false,
                    textInputAction: TextInputAction.done,

                    cursorRadius: const Radius.circular(10.0),
                    cursorColor: Colors.black,

                    decoration: InputDecoration(
                      labelText: 'Помітки',
                      hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                      
                      contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                      
                      focusedBorder: textFieldStyle,
                      enabledBorder: textFieldStyle,
                    ),
                    
                    onFieldSubmitted: (String value) { notes = value; }
                  )
                ),           
              ]
            )
          ),    
        ]
      );
  }


  // Change element from DB
  Widget textFieldForChange() {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text('Редагувати елемент'),
          textFieldForAdd(),
          button(functions: [changeElementInBox], text: "Змінити", context: context, route: 'projects'),

        ]
      )
    );
  }


  // Add element to DB
  Widget addProjectTextField() {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          
          Text('Додати елемент'),
          textFieldForAdd(),
          button(functions: [addToBox], text: "Додати", context: context, route: '/projects_page'),

        ],
      ),
    );
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
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('${getPageName()}'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // create text fields for add/edit project, depending on page, where you're in
                      if (widget.value == 'projects') addProjectTextField(),
                      if (widget.value == 'project_page') textFieldForChange(),
                    
                    ],
                  ),
                ),
              ),
              
              bottomNavigationBar: Bottom(),
            ); 
        }
      }     
    ); 
  }
  
}