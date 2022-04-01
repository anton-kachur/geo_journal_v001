import 'package:flutter/material.dart';
import 'package:geo_journal_v001/wells/WellPage.dart';


/* *************************************************************************
 Classes for well
************************************************************************* */
class Well extends StatefulWidget {
  var number;
  var date;
  var latitude;
  var longtitude;

  var projectNumber;

  Well(this.number, this.date, this.latitude, this.longtitude, this.projectNumber);
  
  @override
  WellState createState() => WellState();
}


class WellState extends State<Well>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
        bottom: BorderSide(color: Colors.black45, width: 1.0),
        )
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                child: Text('Свердловина №${widget.number}')
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                child: Text('Дата буріння: ${widget.date}'),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                child: Text('Координати: (${widget.latitude}, ${widget.longtitude})'),
              )
            ]
          ),
  
          IconButton(        
            splashColor: Colors.transparent,
            icon: Icon(Icons.arrow_forward_ios, size: 20),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => WellPage(widget.number))
              );
            }
          ),
        ]
      )
    );
  }
}