import 'package:flutter/material.dart';


/* *************************************************************************
  Classes for soil samples
************************************************************************* */
class SoilSample extends StatefulWidget {
  var name;
  var depthStart;
  var depthEnd;
  var notes;
  
  var wellNumber;
  var projectNumber;

  SoilSample(this.name, this.depthStart, this.depthEnd, this.notes, this.wellNumber, this.projectNumber);
  
  @override
  SoilSampleState createState() => SoilSampleState();
}


class SoilSampleState extends State<SoilSample>{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black45, width: 1.0),
            )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                child: Text('${widget.name}')
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                child: Text('${widget.depthStart}-${widget.depthEnd} м'),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 8.0),
                child: Text('Примітки: ${widget.notes}'),
              ),
            ]
          )
        )
      ]
    );
  }
}