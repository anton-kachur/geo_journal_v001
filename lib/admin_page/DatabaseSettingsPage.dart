import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for database settings
**************************************************************** */
class DatabaseSettingsPage extends StatefulWidget {
  final value;

  DatabaseSettingsPage(this.value);
  
  @override
  DatabaseSettingsPageState createState() => DatabaseSettingsPageState();
}


class DatabaseSettingsPageState extends State<DatabaseSettingsPage> {
  Map<int, String> fieldValues = {0: '', 1: '', 2: '', 3: '', 4: '', 5: '', 6: '', 7: '', 8: ''};
  var elementToFind;
  var hintText;
  var formatters;

  var boxSize;
  var box;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;


  // Refresh page
  void refresh() { setState(() {}); }


  // Check if some values in fieldValues are empty
  bool isEmpty(List indexes) {
    int counter = 0;
    for (var i in fieldValues.values) {
      if (i[indexes[counter]] == '') return true;  
    } 
    
    return false;
  }


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    switch (boxName) {
      case 'accounts':
        box = await Hive.openBox<UserAccountDescription>(boxName);    
        break;
      case 'soil_types':
        box = await Hive.openBox<SoilDescription>(boxName);
        break;
      case 's_projects':
        box = await Hive.openBox<ProjectDescription>(boxName);
        break;
    }
    
    boxSize = box.length;

    return Future.value(box.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    if (widget.value == 'soil_types' && !isEmpty([0, 1]))
      box.put('soil${boxSize+2}', SoilDescription.desc(fieldValues[0], fieldValues[1]));

    else if (widget.value == 'accounts' && !isEmpty([0, 1, 2, 3]))
      box.put('account${boxSize+2}', UserAccountDescription(fieldValues[0], fieldValues[1], fieldValues[2], fieldValues[3], '', true, false));
    
    else if (widget.value == 's_projects' && !isEmpty([0, 1, 2, 3]))
      box.put('project${boxSize+2}', ProjectDescription(fieldValues[0], fieldValues[1], fieldValues[2], fieldValues[3]));
    
    return Text('');
  }


  // Function for changing data in database
  Widget changeElementInBox() {
    if (widget.value == 'soil_types') {
      for (var key in box.keys) {
        if ((box.get(key)).type == elementToFind) {

          box.put(key, SoilDescription.desc(elementToFind, fieldValues[1]));
        
        }
      }
    } else if (widget.value == 'accounts') {
      for (var key in box.keys) {
        if ((box.get(key)).login == elementToFind) {

          box.put(
            key, 
            UserAccountDescription(
              elementToFind, 
              fieldValues[1] == ''? box.get(key).password : fieldValues[1], 
              fieldValues[2] == ''? box.get(key).email : fieldValues[2],
              fieldValues[3] == ''? box.get(key).phoneNumber : fieldValues[3],
              '', true, false
            )
          );

        }
      }
    } else if (widget.value == 's_projects') {
      for (var key in box.keys) {
        if ((box.get(key)).name == elementToFind) {

          box.put(
            key, 
            ProjectDescription(
              elementToFind, 
              fieldValues[1] == ''? box.get(key).number : fieldValues[1], 
              fieldValues[2] == ''? box.get(key).date : fieldValues[2],
              fieldValues[3] == ''? box.get(key).notes : fieldValues[3]
            )
          );

        }
      }
    }
    
    return Text('');
  }


  // Function for deleting data in database
  Widget deleteElementInBox() {
    if (widget.value == 'soil_types') {
      for (var key in box.keys) {
        if ((box.get(key)).type == elementToFind) {
          
          box.delete(key);
        
        }
      }
    } else if (widget.value == 'accounts') {
      for (var key in box.keys) {
        if ((box.get(key)).login == elementToFind) {
          
          box.delete(key);
        
        }
      }
    }  else if (widget.value == 's_projects') {
      for (var key in box.keys) {
        if ((box.get(key)).name == elementToFind) {
          
          box.delete(key);
        
        }
      }
    }
    
    return Text('');
  }

  
  // Set page title depending on database name
  getNameByTypeOfDatabase() {
    switch (widget.value) {
      case 'accounts': return 'Акаунти користувачів';
      case 's_projects': return 'Проекти';
      case 'soil_types': return 'Типи грунтів';
      case 's_weather': return 'Погода';
      case 's_other': return 'Інші налаштування';
    }
  }


  // Set hint text for text fields depending on database name
  getHintTextByTypeOfDatabase([var blockNumber]) {
    if (widget.value == 'accounts') {
      return ['Логін...', 'Пароль...', 'Електронна пошта...', 'Моб. телефон...', 'Посада', 'Зробити адміном (так/ні)'];
    } else if (widget.value == 'soil_types') {
      return ['Тип грунту...', 'Опис...'];
    } else if (widget.value == 's_projects') {
      return ['Назва проекту...', 'Номер...', 'Дата закінчення...', 'Примітки...'];
    }
  }


  // Set settings for text fields (input type and allowed keyboard values) depending on database name
  getKeyboardTypeAndAllowedValues() {
    if (widget.value == 'accounts') {
      return [
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9']"))], 
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9'!@#$%^&*']"))], 
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє@.']"))], 
        [TextInputType.number, FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))],
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))], 
      ];
    } else if (widget.value == 'soil_types') {
      return [
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))], 
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))], 
      ];
    } else if (widget.value == 's_projects') {
      return [
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))], 
        [TextInputType.number, FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))], 
        [TextInputType.datetime, FilteringTextInputFormatter.allow(RegExp(r"[0-9/]"))], 
        [TextInputType.text, FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))]
      ];
    }
  }


  // Create text field with parameters
  Widget textField(var textInputAction, var labelText, var keyboardType, var inputFormatters, {var width, var height, var inputValueIndex, var otherValue}) {
    
    return Container(
      width: width,
      height: height,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,

        keyboardType: keyboardType,
        inputFormatters: [
          inputFormatters
        ],

        cursorRadius: const Radius.circular(10.0),
        cursorColor: Colors.black,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onFieldSubmitted: (String value) { 
          if (inputValueIndex != null) { fieldValues[inputValueIndex] = value; }
          else { 
            if (otherValue == 'find') { elementToFind = value; } 
            else { fieldValues[otherValue] = value; }
          }
        }

      )
    );

  }


  // Create block of text fields for add fields
  Widget textFieldBlockForAdding(var textFieldBlockNumber, var labelText) {
    
    return Padding(
        padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            textField(
              TextInputAction.next, 
              labelText[0],
              textFieldBlockNumber == 1? formatters[0][0] : formatters[2][0],
              textFieldBlockNumber == 1? formatters[0][1] : formatters[2][1], 
              inputValueIndex: textFieldBlockNumber == 1? 0 : 2,
              width: textFieldWidth,
              height: textFieldHeight
            ),

            textField(
              textFieldBlockNumber == 1? TextInputAction.next : TextInputAction.done, 
              labelText[1], 
              textFieldBlockNumber == 1? formatters[1][0] : formatters[3][0],
              textFieldBlockNumber == 1? formatters[1][1] : formatters[3][1], 
              inputValueIndex: textFieldBlockNumber == 1? 1 : 3,
              width: textFieldWidth,
              height: textFieldHeight
            ),

            /*if (widget.value == 'accounts')
              textField(
                textFieldBlockNumber != 3? TextInputAction.next : TextInputAction.done, 
                labelText[2], 
                textFieldBlockNumber == 1? formatters[1][0] : formatters[3][0],
                textFieldBlockNumber == 1? formatters[1][1] : formatters[3][1], 
                inputValueIndex: textFieldBlockNumber == 1? 1 : 3,
                width: textFieldWidth,
                height: textFieldHeight
              ),*/
                         
          ]
        ),
      );
  }


  // Create block of text fields for editing
  textFieldBlockForEditing(var textFieldBlockNumber, var labelText) {

    return Padding(
      padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          textField(
            TextInputAction.next, 
            labelText[0], 
            textFieldBlockNumber == 1? formatters[0][0] : formatters[2][0],
            textFieldBlockNumber == 1? formatters[0][1] : formatters[2][1], 
            otherValue: textFieldBlockNumber == 1? 'find' : 2,
            width: textFieldWidth,
            height: textFieldHeight
          ),

          textField(
            textFieldBlockNumber == 1? TextInputAction.next : TextInputAction.done, 
            labelText[1], 
            textFieldBlockNumber == 1? formatters[1][0] : formatters[3][0],
            textFieldBlockNumber == 1? formatters[1][1] : formatters[3][1], 
            inputValueIndex: textFieldBlockNumber == 1? 1 : 3,
            width: textFieldWidth,
            height: textFieldHeight
          ),

        ]
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    // Retreive data from database, 
    // set hint text for text fields and
    // set input settings for them  
    var boxData = getDataFromBox(widget.value);
    hintText = getHintTextByTypeOfDatabase();
    formatters = getKeyboardTypeAndAllowedValues();


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
                title: Text('Налаштування бази даних'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // Add element to DB
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text('${getNameByTypeOfDatabase()}\n'), // title
                            Text('Додати елемент'),

                            // Create text fields for adding new data to database, stored in blocks
                            textFieldBlockForAdding(1, [hintText[0], hintText[1]]), 
                            (widget.value != 'soil_types')? textFieldBlockForAdding(2, [hintText[2], hintText[3]]) : Text(''),
                            
                            button(functions: [addToBox, refresh], text: "Додати"),
                            
                          ],
                        ),
                      ),



                      // Change element from DB
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Редагувати елемент'),
                            
                            // Create text fields for editing data from database, stored in blocks
                            textFieldBlockForEditing(1, [hintText[0], hintText[1]]),
                            (widget.value != 'soil_types')? textFieldBlockForEditing(2, [hintText[2], hintText[3]]) : Text(''),
                            
                            button(functions: [changeElementInBox, refresh], text: "Змінити"),

                          ]
                        )
                      ),
                      


                      // Delete element from DB
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Видалити елемент'),
                            
                            Padding(
                              padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // Create text field for deleting data in database
                                  textField(
                                    TextInputAction.done, 
                                    hintText[0], 
                                    formatters[0][0],
                                    formatters[0][1], 
                                    otherValue: 'find',
                                    width: textFieldWidth,
                                    height: textFieldHeight
                                  ),
                                      
                                ]
                              ),
                            ),

                            button(functions: [deleteElementInBox, refresh], text: "Видалити"),

                          ]
                        )
                      ),


                      // Get list of elements in DB
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [     

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Список елементів'),
                                
                                for (var element in snapshot.data)
                                  Container(
                                    width: 330,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      boxShadow: [
                                        BoxShadow(color: Colors.amber.shade50),
                                        BoxShadow(color: Colors.white, spreadRadius: -12.0, blurRadius: 12.0),
                                      ],
                                      border: Border.all(color: Colors.grey.shade800),
                                    ),

                                    child: Text("${element.toString()}"),
                                  )
                                  
                              ]
                            ), 

                          ]
                        )
                      ),

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