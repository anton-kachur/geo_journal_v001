import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add description of the new sounding
************************************************************************* */
class AddSoundingData extends StatefulWidget {
  final projectNumber;  // number of project, to which the sounding belongs
  final mode;
  var depth;   // is needed when the mode == 'edit'
  
  AddSoundingData(this.projectNumber, this.mode);
  AddSoundingData.edit(this.projectNumber, this.depth, this.mode);
  
  @override
  AddSoundingDataState createState() => AddSoundingDataState();
}


class AddSoundingDataState extends State<AddSoundingData>{
  var box;
  var boxSize; 

  Map<String, Object> fieldValues = {
    'depth': 0.0, 
    'qc': 0.0, 
    'fs': 0.0, 
    'notes': ''
  };


  var textFieldWidth = 320.0;


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


  // Function for adding data to database
  addToBox() async {
    var userProjects = (await currentAccount).projects;

    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        for (var element in userProjects) {
          if (element.number == widget.projectNumber) {
            
            userProjects[userProjects.indexOf(element)] = ProjectDescription(
              element.name, 
              element.number,
              element.date,
              element.address,
              element.notes, 
              element.wells, 
              element.soundings + [SoundingDescription(
                  fieldValues['depth'], 
                  fieldValues['qc'],
                  fieldValues['fs'],
                  fieldValues['notes'],
                  widget.projectNumber
                )
              ]
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
              userProjects
              )
            );
          
          }
        }

      }
    }
  }


  // Function for changing data in database
  changeElementInBox() async {
    var projects = (await currentAccount).projects;
    var soundings;
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {

        for (var project in projects) {
          if (project.number == widget.projectNumber) {

            soundings = project.soundings;

            for (var sounding in soundings) {
              if (sounding.depth == fieldValues['depth']) {

                soundings[soundings.indexOf(sounding)] = SoundingDescription(
                  fieldValues['depth'] == 0.0? sounding.depth : fieldValues['depth'], 
                  fieldValues['qc'] == 0.0? sounding.qc : fieldValues['qc'],
                  fieldValues['fs'] == 0.0? sounding.fs : fieldValues['fs'],
                  fieldValues['notes'] == ''? sounding.notes : fieldValues['notes'],
                  widget.projectNumber,
                  image: sounding.image
                );

                projects[projects.indexOf(project)] = ProjectDescription(
                  project.name, 
                  project.number,
                  project.date,
                  project.address,
                  project.notes, 
                  project.wells, 
                  soundings 
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


  // Redirect to page with list of wells
  void redirect() {
    Navigator.pop(context, false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Soundings(widget.projectNumber)));
  }

  
  // Text field block for input
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
                'Глибина (м)', 
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                double,
                width: textFieldWidth,
                inputValueIndex: 'depth'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Введіть qc (МПа)', 
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                double,
                width: textFieldWidth,
                inputValueIndex: 'qc'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.next, 
                'Введіть fs (кПа)', 
                TextInputType.number, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                double,
                width: textFieldWidth,
                inputValueIndex: 'fs'
              ),

              SizedBox(height: 8),

              textField(
                TextInputAction.newline, 
                'Нотатки...', 
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

  
  // Text fields with button for adding new sounding (mode == 'add')
  Widget addSoundingTextField() {
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


  // Text fields with button for editing sounding (mode == 'edit')
  Widget editSoundingTextField() {
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



  @override
  Widget build(BuildContext context) {
    
    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data retreived from database
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
                title: Text('Ввести дані'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // create text fields for add/edit sounding, depending on mode
                      if (widget.mode == 'add') addSoundingTextField(),
                      if (widget.mode == 'edit') editSoundingTextField(),

                      
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
    TextInputAction? textInputAction, String? labelText, TextInputType? keyboardType, 
    TextInputFormatter? inputFormatters, Type? parseType,
    {double? width, double? height, String? inputValueIndex}
  ) {
    return Container(
      width: width,

      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,
        maxLines: (inputValueIndex == 'notes')? null : 1,

        keyboardType: keyboardType,
        inputFormatters: [
          if (inputFormatters != null) inputFormatters
        ],

        obscureText: (inputValueIndex == 'password' || inputValueIndex == 'confirmPassword')? true : false,
        autocorrect: true,
        enableSuggestions: true,

        cursorRadius: const Radius.circular(10.0),
        cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onChanged: (String value) { 
          if (inputValueIndex != null) {
            if (value == '' && widget.mode == 'add') {
              alert('Дане поле потрібно заповнити', context);
            } else { 
              if (inputValueIndex == 'depth' && widget.mode == 'edit') {
                fieldValues['depth'] = widget.depth;
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