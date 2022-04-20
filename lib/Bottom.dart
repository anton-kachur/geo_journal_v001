import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/projects/AddProjectDescription.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/wells/AddSoilSample.dart';
import 'package:geo_journal_v001/wells/AddWellDescription.dart';


/* ********************************************************
  Classes for representing the bottom navigation bar
********************************************************* */
class Bottom extends StatefulWidget {
  String page = '';
  var changeableVal;
  var secondChangeableVal;

  Bottom();
  Bottom.dependOnPage(this.page, [this.changeableVal, this.secondChangeableVal]);
  
  @override
  BottomState createState() => BottomState();
}


class BottomState extends State<Bottom> {
  late double iconSize;


  @override 
  Widget build(BuildContext context) {
    iconSize = (widget.page == '')? 27.0 : 23.0;  // set size of some icons

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      
      items: [
        
        // Button which opens page with all projects
        BottomNavigationBarItem(
          title: Text(''),

          icon: IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.list_alt, color: Colors.black, size: iconSize),

            onPressed: () {
              if (widget.page == 'projects' ) { } 
              else {
                setState(() { 
                  Navigator.pushNamed(context, '/projects_page'); 
                });
              }
            }

          )
        ),

        
        // Button which opens page with soil types and their description
        BottomNavigationBarItem(
          title: Text(''),

          icon: IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.landscape_rounded, color: Colors.black, size: iconSize+7.0),
            onPressed: () { 
              if (widget.page == 'soil_types' ) { } 
              else {
                setState(() {  
                  Navigator.pushNamed(context, '/soil_types');
                }); 
              }
            }
          )

        ),
        
        
        // When you're on some pages, like projects' page, you can add new project by 'add' button
        // on BottomNavigationBar or edit it. In the other cases there's no such buttons 
        if ((widget.page!='' || widget.page=='project_page') && currentAccountIsRegistered) 
          
          // Button which can be 'add' or 'edit' depending on page
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
                    // If you're in the page of some of your projects, you can edit it with 'edit' button
                    child: (widget.page != 'project_page')? Icon(Icons.add_circle_outlined, color: Colors.black, size: 40) : Icon(Icons.edit, color: Colors.black, size: 40),
                  ),
                  
                  // Routing to add/edit page of some element (project, well, etc.) depending on what page you're in
                  onTap: () {
                    setState(() {
                      if (widget.page == 'projects') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page)));
                      } else if (widget.page == 'wells') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWellDescription(widget.changeableVal)));
                      } else if (widget.page == 'soundings') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoundingData(widget.changeableVal)));
                      } else if (widget.page == 'soil_sample') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddSoilSample(widget.changeableVal, widget.secondChangeableVal)));
                      } else if (widget.page == 'project_page') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProjectDescription(widget.page, widget.changeableVal)));
                      } 
                    });
                  },
                  
                )
              )
            ),
            
          ),


        // Button which opens page with weather forecasts
        BottomNavigationBarItem(
          title: Text(''),

          icon: IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.ac_unit_rounded, color: Colors.black, size: iconSize),
            onPressed: () { 
              if (widget.page == 'forecasts' ) { } 
              else {
                setState(() { 
                  Navigator.pushNamed(context, '/forecasts_page'); 
                }); 
              }
            }

          )
        ),


        // Button which opens page with application info
        BottomNavigationBarItem(
          title: Text(''),

          icon: IconButton(
            splashColor: Colors.transparent,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Icon(Icons.info_outline_rounded, color: Colors.black, size: iconSize),
            ),

            onPressed: () { 
              if (widget.page == 'info_page' ) { } 
              else {
                setState(() { 
                  Navigator.pushNamed(context, '/info_page'); 
                }); 
              }
            }

          )
        )
        
      ]
    );
  }

}