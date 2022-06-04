import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
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
  var elementToFind;
  var hintText;

  var boxSize;
  var box;

  Map<String, Object> fieldValues = {
    'login': '',
    'password': '',
    'email': '',
    'phoneNumber': '',
    'position': '',
    'isRegistered': false,
    'isAdmin': false
  };

  var textFieldWidth = 320.0;
  var textFieldHeight = 32.0;


  // Refresh page
  void refresh() { 
    setState(() {
      fieldValues['login'] = '';
      fieldValues['password'] = '';
      fieldValues['email'] = '';
      fieldValues['phoneNumber'] = '';
      fieldValues['position'] = '';
      fieldValues['isRegistered'] = false;
      fieldValues['isAdmin'] = false;
    }); 
  }


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    box = await Hive.openBox(boxName); 
    boxSize = box.length;  
    
    return Future.value(box.values);     
  }  


  // Function for adding data to database
  void addToBox() {
    
    box.put(
      'account${boxSize?? 0}', 
      UserAccountDescription(
        fieldValues['login'],
        fieldValues['password'],
        fieldValues['email'],
        fieldValues['phoneNumber'],
        fieldValues['position'], 
        false,
        fieldValues['isAdmin'],
         
        
        [ProjectDescription(
          'тест', '1', '12/12/2033', 'вул. Велика Вісильківська, Київ', 'примітки', 
          
          [WellDescription(
          '1', '01/01/2023', 50.4536, 30.5164, '1', 
          
          [SoilForWellDescription('Пісок', 0.2, 0.5, 'примітки', '1', '1')]
          )],

          [SoundingDescription(0.0, 2.234, 2.546, 'помітки', '1')]
        )]
      
      )
    );
    
  }


  // Function for changing data in database
  void changeElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).login == fieldValues['login']) {

        box.put(
          key, 
          UserAccountDescription(
            fieldValues['login'] == ''? box.get(key).login : fieldValues['login'],
            fieldValues['password'] == ''? box.get(key).password : fieldValues['password'],
            fieldValues['email'] == ''? box.get(key).email : fieldValues['email'],
            fieldValues['phoneNumber'] == ''? box.get(key).phoneNumber : fieldValues['phoneNumber'],
            fieldValues['position'] == ''? box.get(key).position : fieldValues['position'], 
            box.get(key).isRegistered,
            fieldValues['isAdmin']  == false? box.get(key).isAdmin : fieldValues['isAdmin'],
            box.get(key).projects
          )
        );

      }
    }
    
  }


  // Function for deleting data in database
  void deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).login == fieldValues['login']) {
        
        box.delete(key);
      
      }
    }
    
  }


  // Set hint text for text fields depending on database name
  getHintTextByTypeOfDatabase() {
    return ['Логін...', 'Пароль...', 'Електронна пошта...', 'Моб. телефон...', 'Посада...', 'Зробити адміном'];
  }


  // Create text field with parameters
  Widget textField(var textInputAction, var labelText, var keyboardType, var inputFormatters, {var width, var height, var inputValueIndex, var otherValue}) {
    
    return Container(
      width: width,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        maxLines: (inputValueIndex == 'password' || inputValueIndex == 'confirmPassword')? 1 : null,

        keyboardType: keyboardType,
        inputFormatters: [
           if (inputFormatters != null) inputFormatters
        ],

        cursorRadius: const Radius.circular(10.0),
        cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

        obscureText: (inputValueIndex == 'password' || inputValueIndex == 'confirmPassword')? true : false,
        autocorrect: true,
        enableSuggestions: true,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onChanged: (String value) { 
          if (inputValueIndex != null) { 
            fieldValues[inputValueIndex] = value; 
          }
        }

      )
    );

  }


  // Create block of text fields for add fields
  Widget textFieldBlock(var textFieldBlockNumber, var labelText, var keyboardTypes, var inputValueIndexes) {
    
    return Padding(
        padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            textField(
              textFieldBlockNumber == 3? TextInputAction.done : TextInputAction.next, 
              labelText[0],
              keyboardTypes[0],
              null,
              inputValueIndex: inputValueIndexes[0],
              width: textFieldWidth,
              height: textFieldHeight
            ),

            SizedBox(height: 8),

            if (textFieldBlockNumber == 3)
              PopupMenuButton(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: labelText[1] + " "),
                      WidgetSpan(child: Icon(Icons.auto_awesome, size: 20))
                    ]
                  ),
                ),
                
                itemBuilder: (context) => [
                  PopupMenuItem(child: Text('Так'), value: true),
                  PopupMenuItem(child: Text('Так, я не проти'), value: true),
                  PopupMenuItem(child: Text('Ні, я не проти'), value: true),
                  PopupMenuItem(child: Text('Ні'), value: false),
                ],

                onSelected: (bool value) {
                  fieldValues['isAdmin'] = value;
                }
              )
            
            else 
              textField(
                TextInputAction.next, 
                labelText[1], 
                keyboardTypes[1],
                null, 
                inputValueIndex: inputValueIndexes[1],
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
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text('Акаунти користувачів\n\nДодати елемент\n'),

                            // Create text fields for adding new data to database, stored in blocks
                            textFieldBlock(1, [hintText[0], hintText[1]], [TextInputType.text, TextInputType.text], ['login', 'password']), 
                            textFieldBlock(2, [hintText[2], hintText[3]], [TextInputType.emailAddress, TextInputType.phone], ['email', 'phoneNumber']),
                            textFieldBlock(3, [hintText[4], hintText[5]], [TextInputType.text, TextInputType.text], ['position', 'isAdmin']),
                            
                            button(functions: [addToBox, refresh], text: "Додати", rightPadding: 86),
                            
                          ],
                        ),
                      ),



                      // Change element from DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Редагувати елемент\n'),
                            
                            // Create text fields for editing data from database, stored in blocks
                            textFieldBlock(1, [hintText[0], hintText[1]], [TextInputType.text, TextInputType.text], ['login', 'password']), 
                            textFieldBlock(2, [hintText[2], hintText[3]], [TextInputType.emailAddress, TextInputType.phone], ['email', 'phoneNumber']),
                            textFieldBlock(3, [hintText[4], hintText[5]], [TextInputType.text, TextInputType.text], ['position', 'isAdmin']),
                            
                            button(functions: [changeElementInBox, refresh], text: "Змінити", rightPadding: 86),

                          ]
                        )
                      ),
                      


                      // Delete element from DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 19, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Видалити елемент\n'),
                            
                            Padding(
                              padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // Create text field for deleting data in database
                                  textField(
                                    TextInputAction.done, 
                                    hintText[0], 
                                    TextInputType.text,
                                    null, 
                                    inputValueIndex: 'login',
                                    width: textFieldWidth,
                                    height: textFieldHeight
                                  ),
                                      
                                ]
                              ),
                            ),

                            button(functions: [deleteElementInBox, refresh], text: "Видалити", rightPadding: 92),

                          ]
                        )
                      ),


                      // Get list of elements in DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [     

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Список елементів\n'),
                                
                                for (var element in snapshot.data)
                                  
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Container(
                                    
                                      width: 320,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        boxShadow: [
                                          BoxShadow(color: lightingMode == ThemeMode.dark? Colors.grey.shade800 : Colors.amber.shade50),
                                          
                                        ],
                                        border: Border.all(color: Colors.grey.shade700),
                                      ),

                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                                      child: Text("${element.toString()}", style: TextStyle(color: lightingMode == ThemeMode.dark? Colors.grey.shade300 : Colors.black),),
                                    )
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