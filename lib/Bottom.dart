import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/folderForProjects/Projects.dart';

/* ********************************************************
  Classes for representing the bottom bar
********************************************************* */
class Bottom extends StatefulWidget {
  var page = '';

  Bottom();
  Bottom.dependOnPage(this.page);
  
  @override
  CreateBottom createState() => CreateBottom();
}


class CreateBottom extends State<Bottom>{
  int i = 0;
  var iconSize = 23.0;

  @override 
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        
        items: [
          BottomNavigationBarItem(
            title: Text(''),
            icon: IconButton(
              splashColor: Colors.transparent,
              icon: i==1? Icon(Icons.list_alt, color: Colors.black, size: iconSize): Icon(Icons.list_alt, color: Colors.black, size: iconSize),
              onPressed: () { setState(() { 
                i=1; 
                Navigator.pushNamed(context, '/projects_page'); 
                }); 
              }
            )
          ),
          
          BottomNavigationBarItem(
            title: Text(''),
            icon: IconButton(
              splashColor: Colors.transparent,
              icon: i==2? Icon(Icons.description_outlined, color: Colors.black, size: iconSize): Icon(Icons.description_outlined, color: Colors.black, size: iconSize),
              onPressed: () { setState(() { 
                i=2; 
                Navigator.pushNamed(context, '/soil_types');
                }); 
              }
            )
          ),
          
          BottomNavigationBarItem(
            title: Text(''),
            icon: IconButton(
              splashColor: Colors.transparent,
              icon: i==5? Icon(Icons.add_circle_outlined, color: Colors.black45, size: 40): Icon(Icons.add_circle_outlined, color: Colors.black, size: 40),
              onPressed: () { 
                setState(() {
                  i=5; 
                  if (widget.page == 'projects') {
                    Navigator.pushNamed(context, '/add_project_description');
                  }
                }); 
              }
            )
          ),

          BottomNavigationBarItem(
            title: Text(''),
            icon: IconButton(
              splashColor: Colors.transparent,
              icon: i==3? Icon(Icons.wb_sunny, color: Colors.black, size: iconSize): Icon(Icons.wb_sunny, color: Colors.black, size: iconSize),
              onPressed: () { setState(() { 
                i=3;
                Navigator.pushNamed(context, '/forecasts_page'); 
              }); 
              }
            )
          ),

          BottomNavigationBarItem(
            title: Text(''),
            icon: IconButton(
              splashColor: Colors.transparent,
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: i==4? Icon(Icons.info, color: Colors.black, size: iconSize): Icon(Icons.info, color: Colors.black, size: iconSize),
              ),
              onPressed: () { setState(() { 
                i=4; 
                Navigator.pushNamed(context, '/info_page'); 
              }); 
              }
            )
          )
        ]
    );
  }
}