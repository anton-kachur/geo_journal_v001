import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/wells/WellPage.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add soil sample with description
************************************************************************* */
class AddSoilSample extends StatefulWidget {
  final wellNumber; // number of well, to which the soil sample belongs
  final projectNumber; // number of project, to which the soil sample belongs
  final mode;
  var name; // soil sample name, which is needed when the mode == 'edit'

  AddSoilSample.editing(this.name, this.wellNumber, this.projectNumber, this.mode);
  AddSoilSample(this.wellNumber, this.projectNumber, this.mode);
  
  @override
  AddSoilSampleState createState() => AddSoilSampleState();
}


class AddSoilSampleState extends State<AddSoilSample> {

  Map<String, Object> fieldValues = {
    'name': '', 
    'depthStart': '', 
    'depthEnd': '', 
    'notes': ''
  };

  var boxSize;
  var box;
  var projectBox;
  var wellBox;

  var textFieldWidth = 320.0;


  // Redirect to page with list of wells
  void redirect() {
    Navigator.pop(context, false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => WellPage(widget.wellNumber, widget.projectNumber)));
  }


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    boxSize = box.length;

    return Future.value(box.values);     
  }


  // Check current account
  Future<bool> checkAccount(var account) async {
    return (account.login == (await currentAccount).login &&
      account.password == (await currentAccount).password &&
      account.email == (await currentAccount).email &&
      account.phoneNumber == (await currentAccount).phoneNumber &&
      account.position == (await currentAccount).position &&
      account.isAdmin == (await currentAccount).isAdmin)? Future<bool>.value(true): Future<bool>.value(false);
  }


  // Check if start depth is less than final depth  
  List<bool> checkIfAllCorrect() {
    return fieldValues['depthStart'] == '' || fieldValues['depthEnd'] == ''? 
      [false]:
      [double.parse(fieldValues['depthStart'].toString()) >= double.parse(fieldValues['depthEnd'].toString())? false : true];
  }



  // Function for adding data to database
  addToBox() async {
    var projects = (await currentAccount).projects;
    var wells;

    if (checkIfAllCorrect()[0]) {
      for (var key in box.keys) {
        if ((await checkAccount(box.get(key))) == true) {
          
          for (var project in projects) {
            if (project.number == widget.projectNumber) {

              wells = project.wells;

              for (var well in wells) {
                if (well.projectNumber == widget.projectNumber && well.number == widget.wellNumber) {

                  wells[wells.indexOf(well)] = WellDescription(
                    well.number, 
                    well.date,
                    well.latitude,
                    well.longtitude,
                    well.projectNumber,
                    well.samples + [ 
                      SoilForWellDescription(
                        fieldValues['name'], 
                        fieldValues['depthStart'],
                        fieldValues['depthEnd'],
                        fieldValues['notes'],
                        widget.wellNumber,
                        widget.projectNumber,
                        image: null
                      )
                    ],
                    image: well.image,
                  );
              
                  projects[projects.indexOf(project)] = ProjectDescription(
                    project.name, 
                    project.number,
                    project.date,
                    project.address,
                    project.notes,
                    wells,
                    project.soundings,
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

                }
              }
            
            }
          }

        }
      }
    } else {
      alert('Початкова глибина не може бути більше або дорівнювати кінцевій глибині', context);
    }
  }


  // Function for changing data in database
  changeElementInBox() async {
    var projects = (await currentAccount).projects;
    var wells;
    var samples;
    
    if (checkIfAllCorrect()[0]) {
      for (var key in box.keys) {
        if ((await checkAccount(box.get(key))) == true) {

          for (var project in projects) {
            if (project.number == widget.projectNumber) {

              wells = project.wells;

              for (var well in wells) {
                if (well.projectNumber == widget.projectNumber && well.number == widget.wellNumber) {

                  samples = well.samples;

                  for (var sample in samples) {
                    if (sample.name == widget.name) {

                      samples[samples.indexOf(sample)] = SoilForWellDescription(
                        fieldValues['name'] == ''? sample.name : fieldValues['name'], 
                        fieldValues['depthStart'] == ''? sample.depthStart : fieldValues['depthStart'],
                        fieldValues['depthEnd'] == ''? sample.depthEnd : fieldValues['depthEnd'],
                        fieldValues['notes'] == ''? sample.notes : fieldValues['notes'],
                        widget.wellNumber,
                        widget.projectNumber,
                        image: sample.image
                      );

                      wells[wells.indexOf(well)] = WellDescription(
                        well.number, 
                        well.date,
                        well.latitude,
                        well.longtitude,
                        well.projectNumber,
                        samples,
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

                    }
                  }

                }
              }

            }
          }
        }
      }
    } else {
      alert('Початкова глибина не може бути більше або дорівнювати кінцевій глибині', context);
    }
  }


  // Text field block for input
  Widget textFieldsForAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Text field block for soil type and start depth
        Padding(
          padding: EdgeInsets.fromLTRB(9, 8, 9, 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              textField(
                TextInputAction.next, 
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '' && widget.name != '')? widget.name.toString() : 'Тип грунту...',
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '' && widget.name != '')? TextStyle(fontSize: 12, color: lightingMode == ThemeMode.dark? Colors.white : Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                (widget.mode == 'edit' && widget.projectNumber != '' && widget.wellNumber != '' && widget.name != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  
                TextInputType.text, 
                null,
                String,
                width: textFieldWidth,
                inputValueIndex: 'name'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Початкова глибина (м)', 
                null, null,
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                String,
                width: textFieldWidth,
                inputValueIndex: 'depthStart'
              ),
              
              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Кінцева глибина (м)', 
                null, null,
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                String,
                width: textFieldWidth,
                inputValueIndex: 'depthEnd'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.newline, 
                'Нотатки...', 
                null, null,
                TextInputType.multiline, 
                null,
                String,
                width: textFieldWidth,
                inputValueIndex: 'notes'
              ),
     
            ]
          )
        ),

      ]
    );
  }


  // Change element from DB
  Widget changeSoilSampleTextField() {

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
  Widget addSoilTextField() {
    
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
                title: Text('Ввести дані грунту'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // create text fields for add/edit soil sample, depending on mode
                      if (widget.mode == 'add') addSoilTextField(),
                      if (widget.mode == 'edit') changeSoilSampleTextField(),
                    
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

        maxLines: (inputValueIndex == 'notes')? null : 1,

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
              if (inputValueIndex == 'name' && widget.mode == 'edit') {
                fieldValues['name'] = widget.name;
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