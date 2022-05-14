import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../AppUtilites.dart';


/* *************************************************************************
 Classes for page of geological calculator
************************************************************************* */
class CalculatorPage extends StatefulWidget {
  final type;
  
  CalculatorPage(this.type);

  @override
  CalculatorPageState createState() => CalculatorPageState();
}


class CalculatorPageState extends State<CalculatorPage> {
  var hintText;
  var result;
  
  Map<int, double> fieldValues = {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0};
  
  var textFieldWidth = 320.0;


  // Refresh page
  void refresh() { setState(() {}); }



  @override
  Widget build(BuildContext context) {

    hintText = setHintText();


    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text(widget.type),
        automaticallyImplyLeading: false
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            
            // Text fields for values input and button for calculating result
            textFieldsBlock(),
            button(functions: [calculate, refresh], text: "Порахувати", rightPadding: 93),
            SizedBox(height: 8),
            Text("    ${result?? ''}"),

          ],
        ),
      )
    );
  }


  // Function for calculating result depending on type
  void calculate() {
    switch (widget.type) { 
      case 'Коефіцієнт спливання': 
        try {
          result = "K = " + (1.0 - (fieldValues[0]! / fieldValues[1]!)).toString();
        } catch(e) { alert('На нуль ділити не можна', context); }
        break;
      case 'Виштовхуюча сила':
        try {
          result = "Fa = " + (fieldValues[0]! * 9.81 * fieldValues[1]!).toString() + " H";
        } catch(e) { alert('На нуль ділити не можна', context); }
        break;
      case 'Густина грунту методом ріжучого кільця':
        try {
          result = "ρ = " + ((fieldValues[1]! - fieldValues[0]!)/fieldValues[2]!).toString() + " (кг/м^3)";
        } catch(e) { alert('На нуль ділити не можна', context); }
        break;
    }
  }


  // Set hint text for text fields
  setHintText() {
    switch (widget.type) { 
      case 'Коефіцієнт спливання': return ['Густина рідини ρ (кг/м^3)', 'Густина сталі ρ (кг/м^3)']; 
      case 'Виштовхуюча сила': return ['Густина рідини ρ (кг/м^3)', 'Об\'єм тіла V (м^3)'];
      case 'Густина грунту методом ріжучого кільця': return ['Маса пустого ріжучого кільця m1 (кг)', 'Маса ріжучого кільця з грунтом m2 (кг)', 'Об\'єм кільця V (м^3)'];
    }
  }


  // Fuction that creates textField block for values input
  Widget textFieldsBlock() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(9, 8, 9, 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                textField(
                  TextInputAction.next, 
                  hintText[0], 
                  null, null,
                  TextInputType.number, 
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  width: textFieldWidth,
                  inputValueIndex: 0
                ),

                SizedBox(height: 8),

                textField(
                  hintText.length > 2? TextInputAction.next : TextInputAction.done, 
                  hintText[1], 
                  null, null,
                  TextInputType.number, 
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  width: textFieldWidth,
                  inputValueIndex: 1
                ),

                SizedBox(height: 8),

                if (hintText.length == 3)
                  textField(
                    hintText.length > 3? TextInputAction.next : TextInputAction.done, 
                    hintText[2], 
                    null, null,
                    TextInputType.number, 
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    width: textFieldWidth,
                    inputValueIndex: 2
                  ),
       
              ]
            )
          ),

        ]
      );
  }


  // Create text field with parameters
  Widget textField(
    TextInputAction? textInputAction, String? labelText, 
    TextStyle? hintStyle, TextStyle? labelStyle, TextInputType? keyboardType, 
    TextInputFormatter? inputFormatters, 
    {double? width, double? height, int? inputValueIndex}
  ) {
    return Container(
      width: width,
      
      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,

        keyboardType: keyboardType,
        inputFormatters: [
          if (inputFormatters != null) inputFormatters
        ],

        autocorrect: true,
        enableSuggestions: true,

        cursorRadius: const Radius.circular(10.0),
        cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: hintStyle != null? hintStyle : TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: labelStyle != null? hintStyle : TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onChanged: (String value) { 
          if (inputValueIndex != null)    
            fieldValues[inputValueIndex] = double.tryParse(value) == null? 0.0 : double.parse(value);
          
        }

      )
    );
  }

}