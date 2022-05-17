import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/calculator/CalculatorPage.dart';


/* *************************************************************************
 Classes for page with the list of geological calculators
************************************************************************* */
class Calculators extends StatefulWidget {
  Calculators();
  
  @override
  CalculatorsState createState() => CalculatorsState();
}


class CalculatorsState extends State<Calculators>{

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text('Калькулятор'),
        automaticallyImplyLeading: false
      ),

      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [

              createCalcElement('Коефіцієнт спливання'),
              createCalcElement('Виштовхуюча сила'),
              createCalcElement('Густина грунту методом ріжучого кільця'),
              
            ]
          ),
        )
      ),
      
      bottomNavigationBar: Bottom('calculators'),
    );
  }


  // Create block for list with calculators
  Widget createCalcElement(String type) {

    return Container(

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black45, width: 1.0),
        )
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0), 
            child: Text(type) // name of calculator
          ),

          IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.arrow_forward_ios_rounded, size: 22),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage(type))); // move to page of calculator
            }
          ) 

        ]
      )

    );
  }

}