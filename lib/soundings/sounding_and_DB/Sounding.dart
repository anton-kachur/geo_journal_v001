import 'package:flutter/material.dart';


/* *************************************************************************
 Classes for sounding
************************************************************************* */
class Sounding extends StatefulWidget {
  final depth;
  final qc;
  final fs;
  final notes;

  final projectNumber;  // number of project, to which the well belongs

  Sounding(this.depth, this.qc, this.fs, this.notes, this.projectNumber);
  
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
                child: Text('Кінцева глибина: ${widget.depth}')
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
                child: Text('Примітки: ${widget.notes}'),
              )

            ]
          ),

        ]
      )
    );
  }

}