import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/wells/Wells.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add new well with description
************************************************************************* */
class AddWellDescription extends StatefulWidget {
  final projectNumber;  // number of project, to which the well belongs
  var wellNumber; // is needed when the mode == 'edit'
  final mode;

  AddWellDescription.editing(this.projectNumber, this.wellNumber, this.mode);
  AddWellDescription(this.projectNumber, this.mode);
  
  @override
  AddWellDescriptionState createState() => AddWellDescriptionState();
}


class AddWellDescriptionState extends State<AddWellDescription> {
  var box;
  var projectBox;
  var boxSize;

  Map<String, Object> fieldValues = {
    'number': '', 
    'date': '', 
    'latitude': '', 
    'longtitude': ''
  };


  var textFieldWidth = 320.0;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    boxSize = box.length;

    return Future.value(box.values);     
  }


  // Function fro checking the current account
  Future<bool> checkAccount(var account) async {
    return (account.login == (await currentAccount).login &&
      account.password == (await currentAccount).password &&
      account.email == (await currentAccount).email &&
      account.phoneNumber == (await currentAccount).phoneNumber &&
      account.position == (await currentAccount).position &&
      account.isAdmin == (await currentAccount).isAdmin)? Future<bool>.value(true): Future<bool>.value(false);
  }


  // Function for adding data to database
  addToBox() async {
    var projects = (await currentAccount).projects;

    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        for (var element in projects) {
          if (element.number == widget.projectNumber) {

            if (compareTwoDates(fieldValues['date'].toString(), element.date.toString())) {
            
              projects[projects.indexOf(element)] = ProjectDescription(
                element.name, 
                element.number,
                element.date,
                element.address,
                element.notes,
                element.wells + [ 
                  WellDescription(
                    fieldValues['number'], 
                    fieldValues['date'],
                    fieldValues['latitude'],
                    fieldValues['longtitude'],
                    widget.projectNumber,
                    []
                  )
                ],
                element.soundings,
              );

              box.put(
                key, UserAccountDescription(
                (await currentAccount).login,
                (await currentAccount).password,
                (await currentAccount).email,
                (await currentAccount).phoneNumber,
                (await currentAccount).position,
                true,
                (await currentAccount).isAdmin,
                projects
                )
              );
            } else {
              alert('Дата буріння не може бути більше, або дорівнювати кінцевій даті проекту', context);
            }
          
          }
        }

      }
    }
  }


  // Function for changing data in database
  changeElementInBox() async {
    var projects = (await currentAccount).projects;
    var wells;
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {

        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            wells = project.wells;

            for (var well in wells) {
              if (well.number == widget.wellNumber) {
                
                if (compareTwoDates(fieldValues['date'].toString(), project.date.toString())) {
                  wells[wells.indexOf(well)] = WellDescription(
                    fieldValues['number'] == ''? well.number : fieldValues['number'], 
                    fieldValues['date'] == ''? well.date : fieldValues['date'],
                    fieldValues['latitude'] == 0.0? well.latitude : fieldValues['latitude'],
                    fieldValues['longtitude'] == 0.0? well.longtitude : fieldValues['longtitude'],
                    widget.projectNumber,
                    well.samples,
                    image: well.image
                  );

                  projects[projects.indexOf(project)] = ProjectDescription(
                    project.name, 
                    project.number,
                    project.date,
                    project.address,
                    project.notes, 
                    wells, 
                    project.soundings 
                  );

                  box.put(
                    key, UserAccountDescription(
                    (await currentAccount).login,
                    (await currentAccount).password,
                    (await currentAccount).email,
                    (await currentAccount).phoneNumber,
                    (await currentAccount).position,
                    true,
                    (await currentAccount).isAdmin,
                    projects
                    )
                  );
                } else {
                  alert('Дата буріння не може бути більше, менше або дорівнювати кінцевій даті проекту', context);
                }

              }
            }

          }
        }
      }
    }
  }


  // Redirect to page with list of wells
  void redirect() {
    Navigator.pop(context, false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Wells(widget.projectNumber)));
  }


  // Creates text field block for input
  Widget textFieldsForAdd() {

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
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '')? widget.wellNumber.toString() : 'Номер свердловини...',
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '')? TextStyle(fontSize: 12, color: lightingMode == ThemeMode.dark? Colors.white : Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                String,
                width: textFieldWidth,
                inputValueIndex: 'number'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Дата буріння\n(ДД/ММ/РРРР)', 
                null, null,
                TextInputType.datetime, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                String,
                width: textFieldWidth,
                inputValueIndex: 'date'
              ),
                      
              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Широта...', 
                null, null,
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                double,
                width: textFieldWidth,
                inputValueIndex: 'latitude'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.done, 
                'Довгота...', 
                null, null,
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                double,
                width: textFieldWidth,
                inputValueIndex: 'longtitude'
              ),
      
            ]
          )
        ),

      ]
    );

  }


  // Change element from DB
  Widget changeWellTextField() {

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          textFieldsForAdd(),
          button(functions: [changeElementInBox, redirect], text: "Змінити", rightPadding: 92),

        ]
      )
    );
  }


  // Add element to DB
  Widget addWellTextField() {
    
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          
          textFieldsForAdd(),
          button(functions: [addToBox, redirect], text: "Додати", rightPadding: 93),

        ],
      ),
    );
  }


  // Convert String date to DateTime
  DateTime dateParse(String date) {
    return DateTime(
      int.tryParse(date.substring(6, 10)) ?? 0, 
      int.tryParse(date.substring(3, 5)) ?? 0, 
      int.tryParse(date.substring(0, 2)) ?? 0,
    );
  }



  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data, retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown,
                title: Text('Ввести дані свердловини'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // create text fields for add/edit well, depending on mode
                      if (widget.mode == 'add') addWellTextField(),
                      if (widget.mode == 'edit') changeWellTextField(),
                    
                    ],
                  ),
                ),
              ),

              bottomNavigationBar: Bottom(),
            );
          }
        }
    );
  }


  // Create text field with parameters
  Widget textField(
    TextInputAction? textInputAction, String? labelText, 
    TextStyle? hintStyle, TextStyle? labelStyle, TextInputType? keyboardType, 
    TextInputFormatter? inputFormatters, Type? parseType,
    {double? width, double? height, String? inputValueIndex}
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
          if (inputValueIndex != null) {    
            if (value == '' && widget.mode == 'add') {
              alert('Дане поле потрібно заповнити', context);
            } else { 
              if (inputValueIndex == 'number' && widget.mode == 'edit') {
                fieldValues['number'] = widget.wellNumber;
              } 

              if (parseType == double) 
                fieldValues[inputValueIndex] = double.tryParse(value) == null? 0.0 : double.parse(value);
              else if (parseType == int)
                fieldValues[inputValueIndex] = int.tryParse(value) == null? 0: int.parse(value);
              else 
                fieldValues[inputValueIndex] = value;
            }
          }
        }

      )
    );
  }
  

}