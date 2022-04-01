import 'package:flutter/material.dart';
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
  var value;

  DatabaseSettingsPage(this.value);
  
  @override
  DatabaseSettingsPageState createState() => DatabaseSettingsPageState();
}


class DatabaseSettingsPageState extends State<DatabaseSettingsPage> {
  Map<int, String> fieldValues = {0: '', 1: '', 2: '', 3: ''};
  var elementToFind;
  var hintText;

  var boxSize;
  var box;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;

  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    var boxx;
    switch (boxName) {
      case 's_accounts':
        boxx = await Hive.openBox<AccountDescription>(boxName);    
        break;
      case 'soil_types':
        boxx = await Hive.openBox<SoilDescription>(boxName);
        break;
      case 's_projects':
        boxx = await Hive.openBox<ProjectDescription>(boxName);
        break;
    }
    
    boxSize = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    if (widget.value == 'soil_types' && fieldValues[0]!='')
      box.put('soil${boxSize+2}', SoilDescription.desc(fieldValues[0], fieldValues[1]));
    else if (widget.value == 's_accounts' && fieldValues[0]!='')
      box.put('account${boxSize+2}', AccountDescription(fieldValues[0], fieldValues[1], fieldValues[2], fieldValues[3]));
    else if (widget.value == 's_projects' && fieldValues[0]!='')
      box.put('project${boxSize+2}', ProjectDescription(fieldValues[0], fieldValues[1], fieldValues[2], fieldValues[3]));
    
    box.close();
    return Text('');
  }


  // Function for changing data in database
  Widget changeElementInBox(var element, var par1, [var par2, var par3]) {
    if (widget.value == 'soil_types') {
      for (var key in box.keys) {
        if ((box.get(key)).type == element) {
          box.put(key, SoilDescription.desc(element, par1));
        }
      }
    } else if (widget.value == 's_accounts') {
      for (var key in box.keys) {
        if ((box.get(key)).login == element) {
          box.put(key, AccountDescription(element, par1, par2, par3));
        }
      }
    } else if (widget.value == 's_projects') {
      for (var key in box.keys) {
        if ((box.get(key)).name == element) {
          box.put(key, ProjectDescription(element, par1, par2, par3));
        }
      }
    }
    
    box.close();
    return Text('');
  }


  // Function for deleting data in database
  Widget deleteElementInBox(var element,) {
    if (widget.value == 'soil_types') {
      for (var key in box.keys) {
        if ((box.get(key)).type == element) {
          box.delete(key);
        }
      }
    } else if (widget.value == 's_accounts') {
      for (var key in box.keys) {
        if ((box.get(key)).login == element) {
          box.delete(key);
        }
      }
    }  else if (widget.value == 's_projects') {
      for (var key in box.keys) {
        if ((box.get(key)).name == element) {
          box.delete(key);
        }
      }
    }
    
    box.close();
    return Text('');
  }

  
  getNameByTypeOfDatabase() {
    switch (widget.value) {
      case 's_accounts': return 'Акаунти користувачів';
      case 's_projects': return 'Проекти';
      case 'soil_types': return 'Типи грунтів';
      case 's_weather': return 'Погода';
      case 's_other': return 'Інші налаштування';
    }
  }

  getHintTextByTypeOfDatabase([var blockNumber]) {
    if (widget.value == 's_accounts') {
      return ['Логін...', 'Пароль...', 'Електронна пошта...', 'Моб. телефон...'];
    } else if (widget.value == 'soil_types') {
      return ['Тип грунту...', 'Опис...'];
    } else if (widget.value == 's_projects') {
      return ['Назва проекту...', 'Номер...', 'Дата закінчення...', 'Примітки...'];
    }/* else if (widget.value == 's_accounts') {
      return (blockNumber == 1)? ['Логін...', 'Пароль...'] : ['Електронна пошта...', 'Моб. телефон...'];
    } else if (widget.value == 's_accounts') {
      return (blockNumber == 1)? ['Логін...', 'Пароль...'] : ['Електронна пошта...', 'Моб. телефон...'];
    }*/
  }


  textFieldBlockForAdding(var blockNumber, var text) {
    return Padding(
        padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Container(
              width: textFieldWidth,
              height: textFieldHeight,
              child: TextFormField(
                autofocus: false,
                textInputAction: TextInputAction.next,

                decoration: InputDecoration(
                  hintText: text[0],
                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                  
                  focusedBorder: textFieldStyle,
                  enabledBorder: textFieldStyle,
                ),
                
                onChanged: (value) { 
                  if (blockNumber == 1)
                    fieldValues[0] = value; 
                  else
                    fieldValues[2] = value;
                }
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
                  hintText: text[1],
                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                  
                  focusedBorder: textFieldStyle,
                  enabledBorder: textFieldStyle,
                ),
                
                onChanged: (value) {
                  if (blockNumber == 1)
                    fieldValues[1] = value; 
                  else
                    fieldValues[3] = value;
                }
              )
            ),                          
          ]
        ),
      );
  }


  textFieldBlockForEditing(var blockNumber, var text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
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
                hintText: text[0],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onChanged: (value) {
                if (blockNumber == 1)
                  elementToFind = value;
                else
                  fieldValues[2] = value; 
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
                hintText: text[1],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onChanged: (value) { 
                if (blockNumber == 1)
                  fieldValues[1] = value;
                else
                  fieldValues[3] = value;
              }
            )
          ),
        ]
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

    var boxData = getDataFromBox(widget.value);
    hintText = getHintTextByTypeOfDatabase();

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
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Налаштування бази даних')),
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
                            Text('${getNameByTypeOfDatabase()}\n'),
                            Text('Додати елемент'),

                            textFieldBlockForAdding(1, [hintText[0], hintText[1]]),
                            (widget.value != 'soil_types')? textFieldBlockForAdding(2, [hintText[2], hintText[3]]) : Text(''),
                            
                            // Add button
                            Padding(
                              padding: EdgeInsets.fromLTRB(90.0, 7.0, 0.0, 0.0),
                              child: FlatButton(
                                minWidth: 150.0,
                                child: Text("Додати", style: TextStyle(color: Colors.black87)),
                                
                                onPressed: () => { 
                                  addToBox(),
                                  setState(() {})
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
                      ),



                      // Change element from DB
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Редагувати елемент'),
                            
                            textFieldBlockForEditing(1, [hintText[0], hintText[1]]),
                            (widget.value != 'soil_types')? textFieldBlockForEditing(2, [hintText[2], hintText[3]]) : Text(''),
                            
                            // Add button
                            Padding(
                              padding: EdgeInsets.fromLTRB(90.0, 7.0, 0.0, 0.0),
                              child: FlatButton(
                                minWidth: 150.0,
                                child: Text("Змінити", style: TextStyle(color: Colors.black87)),
                                onPressed: () => { 
                                  changeElementInBox(elementToFind, fieldValues[1], fieldValues[2], fieldValues[3]),
                                  setState(() {
                                    
                                  })
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
                                
                                  Container(
                                    width: this.textFieldWidth,
                                    height: this.textFieldHeight,
                                    child: TextFormField(
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,

                                      decoration: InputDecoration(
                                        hintText: hintText[0],
                                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                        
                                        focusedBorder: textFieldStyle,
                                        enabledBorder: textFieldStyle,
                                      ),
                                      
                                      onChanged: (value) { 
                                        elementToFind = value; 
                                      }
                                    )
                                  ),

                                  
                                ]
                              ),
                            ),

                            
                            
                            // Add button
                            Padding(
                              padding: EdgeInsets.fromLTRB(90.0, 7.0, 0.0, 0.0),
                              child: FlatButton(
                                minWidth: 150.0,
                                child: Text("Видалити", style: TextStyle(color: Colors.black87)),
                                onPressed: () => { 
                                  deleteElementInBox(elementToFind),
                                  setState(() {
                                    
                                  })
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