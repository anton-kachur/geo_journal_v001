import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/info/InfoPageDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for app info database settings
**************************************************************** */
class InfoDatabaseSettingsPage extends StatefulWidget {
  final value;

  InfoDatabaseSettingsPage(this.value);
  
  @override
  InfoDatabaseSettingsPageState createState() => InfoDatabaseSettingsPageState();
}


class InfoDatabaseSettingsPageState extends State<InfoDatabaseSettingsPage> {
  Map<int, String> fieldValues = {0: '', 1: ''};
  var elementToFind;
  var hintText;

  var box;

  var textFieldWidth = 320.0;


  // Refresh page
  void refresh() { setState(() {}); }


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    box = await Hive.openBox<InfoDescription>(boxName);    
    
    return Future.value(box.values.first);     
  }  


  // Function for adding data to database
  void addToBox() {
    box.put('info0', InfoDescription(
      'Застосунок для геологів', 
      fieldValues[0] == 'Розробник: '? (box.get('info0')).developer : fieldValues[0], 
      fieldValues[1] == 'Версія: '? (box.get('info0')).version : fieldValues[1])
    );
    
    box.close();
  }


  // Create text field
  Widget textField(var textInputAction, var labelText, var inputValueIndex) {

    return Container(
      width: textFieldWidth,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,

        cursorRadius: const Radius.circular(10.0),
        cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,
        enableSuggestions: true,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onChanged: (String value) { fieldValues[inputValueIndex] = labelText + ': ' + value; }
      )
    );
  }



  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox(widget.value); // data retreived from database

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
                            Text('Про застосунок\n'),
                            Text('Редагувати\n'),

                            Padding(
                              padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  textField(TextInputAction.next, 'Розробник', 0),

                                  SizedBox(height: 8),

                                  textField(TextInputAction.done, 'Версія', 1),                  
                                
                                ]
                              ),
                            ),

                            button(functions: [addToBox, refresh], text: "Змінити", rightPadding: 92),
                            
                          ],
                        ),
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
                                Text('Eлемент\n'),

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

                                      child: Text("${snapshot.data.title}\n${snapshot.data.developer}\n${snapshot.data.version}", style: TextStyle(color: lightingMode == ThemeMode.dark? Colors.grey.shade300 : Colors.black),),
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