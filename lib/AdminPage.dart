import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/SoilTypes.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for creating page of administrator settings
**************************************************************** */
class AdminPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0.000001,
          backgroundColor: Colors.brown,
          title: Text('Адмін. сторінка', style: TextStyle(color: Colors.white)),
        )
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Database changes
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Налаштування бази даних'),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Користувачі'), value: 's_accounts'),
                    PopupMenuItem(child: Text('Проекти'), value: 's_projects'),
                    PopupMenuItem(child: Text('Типи грунтів'), value: 'soil_types'),
                    PopupMenuItem(child: Text('Погода'), value: 's_weather'),
                    PopupMenuItem(child: Text('Інші налаштування'), value: 's_other')
                  ],
                  onSelected: (value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePage(value)));
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15.0),
          ),
        ],
      ),
      
      bottomNavigationBar: Bottom(),
    );
  }
}


/* ***************************************************************
  Classes for database settings
**************************************************************** */
class ChangePage extends StatefulWidget {
  var value;

  ChangePage(this.value);
  
  @override
  ChangePageState createState() => ChangePageState();
}


class ChangePageState extends State<ChangePage> {
  var type_field_val;
  var desc_field_val;
  var box_size;
  var box;

  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    var boxx = await Hive.openBox<SoilDescription>(boxName);
    box_size = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  

  // Function for adding data to database
  Widget addToBox() {
    if (widget.value == 'soil_types' && type_field_val!='')
      box.put('soil${box_size+2}', SoilDescription.desc(type_field_val, desc_field_val));
    
    box.close();
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox(widget.value);

    return FutureBuilder(
      future: boxData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.brown, title: Text('Настройки базы данных')),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add element to DB
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Добавить элемент'),
                        
                        Container(
                          width: 98,
                          height: 32,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "тип грунта...",
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                              ),
                            ),
                            
                            onChanged: (value) {
                              this.type_field_val = value;
                              print("Soil type entered : $value");
                            }
                          )
                        ),

                        Container(
                          width: 98,
                          height: 32,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "описание...",
                              hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                              contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                              
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                              ),
                            ),
                            
                            onChanged: (value) {
                              this.desc_field_val = value;
                              print("Soil desc entered : $value");
                              print('SIZIIZIZEEEE: $box_size');
                            }

                          )
                        ),
                        
                        addToBox(),
                      ]
                    )
                  ),

                // Change element from DB
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Редактировать элемент'),
                    ]
                  )
                ),
                  
                // Delete element from DB
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Удалить элемент'),    
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
                          Text('Список элементов'),
                          
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

                              child: Text("${element.type}\n${element.description}"),
                            )
                          ]
                        ), 
                      ]
                    )
                  ),
                ],
              ),

              bottomNavigationBar: Bottom(),
            ); 
        }
      }     
    ); 
  }
}