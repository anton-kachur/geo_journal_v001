import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/projects/AddProjectDescription.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/wells/AddWellDescription.dart';


/* ********************************************************
  Classes for representing the bottom navigation bar
********************************************************* */
class Bottom extends StatefulWidget {
  var page = '';
  var changeableVal;

  Bottom();
  Bottom.dependOnPage(this.page, [this.changeableVal]);
  
  @override
  CreateBottom createState() => CreateBottom();
}


class CreateBottom extends State<Bottom>{
  int i = 0;
  late double iconSize;


  addIcon(var i) {
    return Icon(Icons.add_circle_outlined, color: Colors.black, size: 40);
  }

  editIcon(var i) {
    return Icon(Icons.edit, color: Colors.black, size: 40);
  }


  @override 
  Widget build(BuildContext context) {
    iconSize = (widget.page == '')? 27.0 : 23.0;

    return BottomNavigationBar(
      backgroundColor: Colors.white,
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
            icon: i==2? Icon(Icons.landscape_rounded, color: Colors.black, size: iconSize+7.0): Icon(Icons.landscape_rounded, color: Colors.black, size: iconSize+7.0),
            onPressed: () { setState(() { 
              i=2; 
              Navigator.pushNamed(context, '/soil_types');
              }); 
            }
          )
        ),
        
        if (widget.page!='' || widget.page=='project_page') 
          BottomNavigationBarItem(
            title: Text(''),
            icon: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.black45,
                  
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: (widget.page != 'project_page')? addIcon(i) : editIcon(i),
                  ),
                  
                  onTap: () {
                    setState(() {
                      i=5; 
                      if (widget.page == 'projects') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page)));
                      } else if (widget.page == 'wells') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWellDescription(widget.changeableVal)));
                      } else if (widget.page == 'soundings') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoundingData(widget.changeableVal)));
                      } else if (widget.page == 'soil_sample') {
                        Navigator.pushNamed(context, '/add_soil_sample_description'); 
                      } else if (widget.page == 'project_page') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page, widget.changeableVal)));
                      } 
                    });
                  },
                  
                )
              )
            ),
            
            
            /*IconButton(
              splashColor: Colors.transparent,
              icon: (widget.page != 'project_page')? addIcon(i) : editIcon(i),
              onPressed: () { 
                setState(() {
                  i=5; 
                  if (widget.page == 'projects') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page)));
                  } else if (widget.page == 'wells') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddWellDescription(widget.changeableVal)));
                  } else if (widget.page == 'soundings') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoundingData(widget.changeableVal)));
                  } else if (widget.page == 'soil_sample') {
                    Navigator.pushNamed(context, '/add_soil_sample_description'); 
                  } else if (widget.page == 'project_page') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page, widget.changeableVal)));
                  } 
                }); 
              }
            )*/
          ),

        BottomNavigationBarItem(
          title: Text(''),
          icon: IconButton(
            splashColor: Colors.transparent,
            icon: i==3? Icon(Icons.ac_unit_rounded, color: Colors.black, size: iconSize): Icon(Icons.ac_unit_rounded, color: Colors.black, size: iconSize),
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
              child: i==4? Icon(Icons.info_outline_rounded, color: Colors.black, size: iconSize): Icon(Icons.info_outline_rounded, color: Colors.black, size: iconSize),
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