import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for database settings
**************************************************************** */
class SoilDatabaseSettingsPage extends StatefulWidget {
  final value;

  SoilDatabaseSettingsPage(this.value);
  
  @override
  SoilDatabaseSettingsPageState createState() => SoilDatabaseSettingsPageState();
}


class SoilDatabaseSettingsPageState extends State<SoilDatabaseSettingsPage> {
  Map<String, String> fieldValues = {
    'type': '',
    'description': '',
    'link': ''
  };

  var boxSize;
  var box;

  var textFieldWidth = 320.0;
  var textFieldHeight = 32.0;


  // Refresh page
  void refresh() { 
    setState(() {
      fieldValues['type'] = ''; 
      fieldValues['description'] = '';
      fieldValues['link'] = '';
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
    box.put('soil$boxSize', SoilDescription(fieldValues['type'], fieldValues['description'], image: fieldValues['link']));
  }


  // Function for changing data in database
  void changeElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).type == fieldValues['type']) {

        box.put(
          key, 
          SoilDescription(
            fieldValues['type'] == ''? box.get(key).type : fieldValues['type'], 
            fieldValues['description'] == ''? box.get(key).description : fieldValues['description'], 
            image: fieldValues['link'] == ''? box.get(key).image : fieldValues['link']
          )
        );
      
      }
    }
        
  }


  // Function for deleting data in database
  void deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).type == fieldValues['type']) {
        
        box.delete(key);
      
      }
    }
    
  }


  // Create text field with parameters
  Widget textField(var textInputAction, var labelText, var keyboardType, var inputFormatters, {var width, var height, var inputValueIndex}) {
    
    return Container(
      width: width,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        maxLines: null,

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
  Widget textFieldBlock() {
    
    return Padding(
        padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
        
        child: Column(
          children: [

            textField(
              TextInputAction.newline, 
              'Тип грунту...',
              TextInputType.multiline,
              null,  
              inputValueIndex: 'type',
              width: textFieldWidth,
              height: textFieldHeight
            ),

            SizedBox(height: 8),

            textField(
              TextInputAction.newline, 
              'Опис...', 
              TextInputType.multiline,
              null,  
              inputValueIndex: 'description',
              width: textFieldWidth,
              height: textFieldHeight
            ),

            SizedBox(height: 8),

            textField(
              TextInputAction.done, 
              'Посилання на фото...', 
              TextInputType.url,
              null,  
              inputValueIndex: 'link',
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
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text('Типи грунтів\n\nДодати елемент\n'),
                            
                            textFieldBlock(),
                            
                            button(functions: [addToBox, refresh], text: "Додати", rightPadding: 93),
                            
                          ],
                        ),
                      ),



                      // Change element from DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Редагувати елемент\n'),
                            
                            textFieldBlock(),
                            
                            button(functions: [changeElementInBox, refresh], text: "Змінити", rightPadding: 92),

                          ]
                        )
                      ),
                      


                      // Delete element from DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 19.0, 0.0),
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
                                    'Тип грунту...', 
                                    TextInputType.text,
                                    null, 
                                    inputValueIndex: 'type',
                                    width: textFieldWidth,
                                    height: textFieldHeight
                                  ),
                                      
                                ]
                              ),
                            ),

                            button(functions: [deleteElementInBox, refresh], text: "Видалити", rightPadding: 98),

                          ]
                        )
                      ),


                      // Get list of elements in DB
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [     

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Список елементів\n'),
                                
                                for (var element in snapshot.data)
                                  Container(
                                    width: 320,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      boxShadow: [
                                        BoxShadow(color: Colors.amber.shade50),
                                        BoxShadow(color: Colors.white, spreadRadius: -12.0, blurRadius: 12.0),
                                      ],
                                      border: Border.all(color: Colors.grey.shade800),
                                    ),

                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                                    child: Text("${element.toString()}", style: TextStyle(color: lightingMode == ThemeMode.dark? Colors.black : Colors.white),),
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