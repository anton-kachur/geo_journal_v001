import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/wells/AddWellDescription.dart';
import 'package:geo_journal_v001/wells/Wells.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


/* *************************************************************************
 Classes for page of project
************************************************************************* */
class ProjectPage extends StatefulWidget {
  final name;
  final number;
  final date;
  final address;
  final notes;

  ProjectPage(this.name, this.number, this.date, this.address, this.notes);
  
  @override
  ProjectPageState createState() => ProjectPageState();
}


class ProjectPageState extends State<ProjectPage> {
  late GoogleMapController mapController; // controller for google map


  // Function for creating google map with controller
  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // Load map theme, depending on dark/light mode of an app 
    String value = await DefaultAssetBundle.of(context)
      .loadString(lightingMode == ThemeMode.dark? 'assets/map_style_dark.json' : 'assets/map_style_light.json');
    
    // Set map theme
    mapController.setMapStyle(value);
  }



  @override
  Widget build(BuildContext context) {
    
    var dateNow = DateTime.now(); // get current date

    var dateToEnd = DateTime(
      int.tryParse(widget.date.substring(6, 10)) ?? 0, 
      int.tryParse(widget.date.substring(3, 5)) ?? 0, 
      int.tryParse(widget.date.substring(0, 2)) ?? 0,
    );  // convert String date to DateTime


    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(widget.name),
          automaticallyImplyLeading: false
        ),

        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(

                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black45, width: 1.0),
                    )
                  ),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // Main project data
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 15.0, 0.0, 8.0),
                        child: Text('Номер: ${widget.number}'),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 15.0),
                        child: Text('Дата закінчення: ${widget.date} (${dateToEnd.difference(dateNow).inDays} днів)')
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 8.0),
                        child: Container(
                          width: 330,
                          child: Text('Адреса: ${widget.address}')
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 7.0, 0.0, 8.0),
                        child: Container(
                          width: 330,
                          child: Text('Нотатки: ${widget.notes}'),
                        ),
                      ),


                      // Google map
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 7.0, 0.0, 12.0),
                        child: Container(
                          height: 250,
                          width: 330,
                          child: Stack(
                            children: [
                              GoogleMap(
                                onMapCreated: onMapCreated,
                                initialCameraPosition: CameraPosition(target: LatLng(50.4333, 30.5167), zoom: 12.0),
                              )
                            ]
                          )
                        )
                      )

                    ]
                  )
                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // Wells and soundings part
                    Padding(
                      padding: EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Свердловини і точки ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Text('статичного зондування', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ]
                          )
                        ]
                      ) 
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Свердловини'),
                              Row(
                                children: [
                                  buttonConstructor(Icons.view_list_rounded, route: Wells(widget.number)),
                                  buttonConstructor(Icons.add_circle_outline, route: AddWellDescription(widget.number, 'add')),
                                ],
                              ),
                            ]
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Точки статичного зондування'),
                              Row(
                                children: [
                                  buttonConstructor(Icons.view_list_rounded, route: Soundings(widget.number)),
                                  buttonConstructor(Icons.add_circle_outline, route: AddSoundingData(widget.number, 'add')),
                                ],
                              ),
                            ]
                          ),

                        ]
                      ) 
                    ),
                  
                  ]
                )
              
              ]
            ),
          )
        ),

        bottomNavigationBar: Bottom("project_page", widget.name),
      );

  }


  // Function for creating buttons with route on project page
  Widget buttonConstructor(icon, {route}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: ClipRRect (
        borderRadius: BorderRadius.circular(4.0),
        child: IconButton(     
          padding: EdgeInsets.all(0.0),
          icon: Icon(icon, size: 25.0),
          onPressed: () {
            
            if (icon == Icons.view_list_rounded) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => route));
            } else if (currentAccountIsRegistered && icon == Icons.add_circle_outline) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => route));  
            } else {
              attentionAlert(context, 'Незареєстровані користувачі не мають доступу до даного елементу.\nМожливо, ви хочете зареєструватися?', materialRoute: AddAccountPage('sign_up'));
            }

          },
        )
      )
    );
  }

}