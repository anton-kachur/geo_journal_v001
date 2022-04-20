import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/info/InfoPageDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for app info database settings
**************************************************************** */
class InfoDatabaseSettingsPage extends StatefulWidget {
  var value;

  InfoDatabaseSettingsPage(this.value);
  
  @override
  InfoDatabaseSettingsPageState createState() => InfoDatabaseSettingsPageState();
}


class InfoDatabaseSettingsPageState extends State<InfoDatabaseSettingsPage> {
  Map<int, String> fieldValues = {0: '', 1: ''};
  var elementToFind;
  var hintText;

  var box;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;


  // Refresh page
  void refresh() { setState(() {}); }


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    box = await Hive.openBox<InfoDescription>(boxName);    
    
    return Future.value(box.values.first);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    box.put('info0', InfoDescription(
      'Застосунок для геологів', 
      fieldValues[0]=='Розробник: '? box.get('info0').developer: fieldValues[0], 
      fieldValues[1]=='Версія: '? box.get('info0').version: fieldValues[1]));
    
    box.close();
    return Text('');
  }


  // Create text field
  textField(var textInputAction, var labelText, var inputValueIndex) {

    return Container(
      width: textFieldWidth,
      height: textFieldHeight,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,

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
        
        onFieldSubmitted: (String value) { fieldValues[inputValueIndex] = labelText + ': ' + value; }
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
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text('Про застосунок\n'),
                            Text('Редагувати'),

                            Padding(
                              padding: EdgeInsets.fromLTRB(1.0, 7.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textField(TextInputAction.next, 'Розробник', 0),
                                  textField(TextInputAction.done, 'Версія', 1),                  
                                ]
                              ),
                            ),

                            button(functions: [addToBox, refresh], text: "Додати"),
                            
                          ],
                        ),
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

                                    child: Text("${snapshot.data.title}\n${snapshot.data.developer}\n${snapshot.data.version}"),
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