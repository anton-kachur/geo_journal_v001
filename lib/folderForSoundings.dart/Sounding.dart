import 'package:flutter/material.dart';


/* *************************************************************************
 Classes for sounding
************************************************************************* */
class Sounding extends StatefulWidget {
  var depth;
  var qc;
  var fs;
  var notes;

  Sounding(this.depth, this.qc, this.fs, this.notes);
  
  @override
  SoundingState createState() => SoundingState();
}


class SoundingState extends State<Sounding>{

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
                child: Text('Точка №${widget.depth}')
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                child: Text('qc: ${widget.qc}'),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                child: Text('fs: ${widget.fs}'),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 15.0),
                child: Text('Примтітки: ${widget.notes}'),
              )
            ]
          ),
        ]
      )
    );
  }
}