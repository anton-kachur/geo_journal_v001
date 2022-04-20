import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/soil_types/SoilTypesDBClasses.dart';
import 'package:geo_journal_v001/weather/WeatherDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for database settings
**************************************************************** */
class WeatherDatabaseSettingsPage extends StatefulWidget {

  WeatherDatabaseSettingsPage();
  
  @override
  WeatherDatabaseSettingsPageState createState() => WeatherDatabaseSettingsPageState();
}


class WeatherDatabaseSettingsPageState extends State<WeatherDatabaseSettingsPage> {
  var weatherValues = ['', ''];
  var elementToFind;
  var hintText;

  var boxSize;
  var box;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    var boxx;
    boxx = await Hive.openBox<WeatherDescription>('s_weather');    
    
    boxSize = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {
    box.put('weather${boxSize+2}', WeatherDescription(weatherValues));
    
    box.close();
    return Text('');
  }


  // Function for changing data in database
  Widget changeElementInBox(var element, var par1) {
    for (var key in box.keys) {
      if ((box.get(key)).weatherData[0] == element) {
        box.put(key, WeatherDescription([element.toString(), par1.toString()]));
      }
    }
    
    return Text('');
  }


  // Function for deleting data in database
  Widget deleteElementInBox(var element,) {
    for (var key in box.keys) {
      if ((box.get(key)).weatherData[0] == element) {
        box.delete(key);
      }
    }
    
    
    box.close();
    return Text('');
  }


  textFieldBlockForAdding() {
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

                cursorRadius: const Radius.circular(10.0),
                cursorColor: Colors.black,

                decoration: InputDecoration(
                  hintText: 'Місто...',
                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                  
                  focusedBorder: textFieldStyle,
                  enabledBorder: textFieldStyle,
                ),
                
                onChanged: (value) { 
                  weatherValues[0] = value; 
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

                cursorRadius: const Radius.circular(10.0),
                cursorColor: Colors.black,

                decoration: InputDecoration(
                  labelText: 'Погода...',
                  hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                  contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                  
                  focusedBorder: textFieldStyle,
                  enabledBorder: textFieldStyle,
                ),
                
                onFieldSubmitted: (String value) { weatherValues[1] = value; }
              )
            ),                          
          ]
        ),
      );
  }


  textFieldBlockForEditing() {
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

              cursorRadius: const Radius.circular(10.0),
              cursorColor: Colors.black,

              decoration: InputDecoration(
                labelText: 'Місто...',
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onFieldSubmitted: (String value) { elementToFind = value; }
            )
          ),

          Container(
            width: this.textFieldWidth,
            height: this.textFieldHeight,
            child: TextFormField(
              autofocus: false,
              textInputAction: TextInputAction.done,

              cursorRadius: const Radius.circular(10.0),
              cursorColor: Colors.black,

              decoration: InputDecoration(
                labelText: 'Погода...',
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onFieldSubmitted: (String value) { weatherValues[1] = value; }
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

    var boxData = getDataFromBox();
    //hintText = getHintTextByTypeOfDatabase();

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
                            Text('Прогнози погоди\n'),
                            Text('Додати елемент'),

                            textFieldBlockForAdding(),
                            
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
                            
                            textFieldBlockForEditing(),
                            
                            // Add button
                            Padding(
                              padding: EdgeInsets.fromLTRB(90.0, 7.0, 0.0, 0.0),
                              child: FlatButton(
                                minWidth: 150.0,
                                child: Text("Змінити", style: TextStyle(color: Colors.black87)),
                                onPressed: () => { 
                                  changeElementInBox(elementToFind, weatherValues[1]),
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

                                      cursorRadius: const Radius.circular(10.0),
                                      cursorColor: Colors.black,

                                      decoration: InputDecoration(
                                        labelText: 'Місто...',
                                        hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                        labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                                        contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                                        
                                        focusedBorder: textFieldStyle,
                                        enabledBorder: textFieldStyle,
                                      ),
                                      
                                      onFieldSubmitted: (String value) { elementToFind = value; }
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
                                      BoxShadow(color: Colors.grey.shade300, spreadRadius: -12.0, blurRadius: 12.0),
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