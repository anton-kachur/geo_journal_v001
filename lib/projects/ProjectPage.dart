import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soundings/AddSoundingData.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/wells/AddWellDescription.dart';
import 'package:geo_journal_v001/wells/Wells.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../AppUtilites.dart';


/* *************************************************************************
 Classes for page of project
************************************************************************* */
class ProjectPage extends StatefulWidget {
  final name;
  final number;
  final date;
  final notes;

  ProjectPage(this.name, this.number, this.date, this.notes);
  
  @override
  ProjectPageState createState() => ProjectPageState();
}


class ProjectPageState extends State<ProjectPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    var dateNow = DateTime.now();

    var dateToEnd = DateTime(
      int.tryParse(widget.date.substring(6, 10)) ?? 0, 
      int.tryParse(widget.date.substring(3, 5)) ?? 0, 
      int.tryParse(widget.date.substring(0, 2)) ?? 0,
    );


    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(widget.name),
        automaticallyImplyLeading: false
      ),

      body: Column(
        children: [

          Container(
            height: 200.0,

            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black45, width: 1.0),
              )
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 8.0),
                  child: Row(
                    children: [
                      Text('Номер: ${widget.number}'),
                      SizedBox(width: 15.0),
                      Text('Дата закінчення: ${widget.date}'),
                    ]
                  ) 
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 8.0),
                  child: Row(
                    children: [
                      Text('До закінчення (днів): ${dateToEnd.difference(dateNow).inDays}'),
                    ]
                  ) 
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Примітки: '),
                      Text('${widget.notes}'),
                    ],
                  ),
                ),


                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 8.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                    ),
                  ),
                )
                

              ]
            )
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(13.0, 10.0, 0.0, 8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Свердловини і точки ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('наскрізного зондування', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ]
                    )
                  ]
                ) 
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Свердловини'),
                        Row(
                          children: [
                            buttonConstructor(Icons.view_list_rounded, route: Wells(widget.number)),
                            buttonConstructor(Icons.add_circle_outline, route: AddWellDescription(widget.number)),
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
                            buttonConstructor(Icons.add_circle_outline, route: AddSoundingData(widget.number)),
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

      bottomNavigationBar: Bottom("project_page", widget.name),
    );

  }


  // Function for creating buttons on project page
  Widget buttonConstructor(icon, {route}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: ClipRRect (
        borderRadius: BorderRadius.circular(4.0),
        child: IconButton(       
          color: Colors.black,
          padding: EdgeInsets.all(0.0),
          icon: Icon(icon, size: 25.0),
          onPressed: () {
            if (currentAccountIsRegistered)
              Navigator.push(context, MaterialPageRoute(builder: (context) => route));
            
          },
        )
      )
    );
  }

}