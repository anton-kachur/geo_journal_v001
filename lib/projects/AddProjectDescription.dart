import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* *************************************************************************
 Classes for page where you can add/edit project with description 
************************************************************************* */
class AddProjectDescription extends StatefulWidget {
  final value;
  final projectName;
  final mode;

  AddProjectDescription({this.value = 'projects', this.projectName = '', this.mode});
  
  @override
  AddProjectDescriptionState createState() => AddProjectDescriptionState();
}


class AddProjectDescriptionState extends State<AddProjectDescription>{
  var box;
  var boxSize;

  Map<String, Object> fieldValues = {
    'name': '', 
    'number': '', 
    'date': '', 
    'address': '',
    'notes': ''
  };

  var textFieldWidth = 320.0;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');
    boxSize = box.length;

    return Future.value(box.values);     
  }  


  // Redirect to page with list of wells
  void redirect() {
    Navigator.pop(context, false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Projects()));
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
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        var userProjects = (await currentAccount).projects;
        userProjects.add(ProjectDescription(fieldValues['name'], fieldValues['number'], fieldValues['date'], fieldValues['address'], fieldValues['notes'], [], []));

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


  // Function for changing data in database
  changeElementInBox() async {
    
    for (var key in box.keys) {
      if ((await checkAccount(box.get(key))) == true) {
        
        var projects = (await currentAccount).projects;
        
        for (var element in projects) {
          if (element.name == widget.projectName) {

            projects[projects.indexOf(element)] = ProjectDescription(
              fieldValues['name'] == ''? element.name : fieldValues['name'], 
              fieldValues['number'] == ''? element.number : fieldValues['number'],
              fieldValues['date'] == ''? element.date : fieldValues['date'],
              fieldValues['address'] == ''? element.address : fieldValues['address'],
              fieldValues['notes'] == ''? element.notes : fieldValues['notes'], 
              element.wells, 
              element.soundings 
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


  // Function for deleting data in database
  Widget deleteElementInBox() {
    for (var key in box.keys) {
      if ((box.get(key)).name == widget.projectName) {
        box.delete(key);
      }
    }
      
    box.close();
    return Text('');
  }


  // Function for setting title of the add/edit page
  getPageName() {
    if (widget.value == 'projects') return 'Ввести опис проекту';
    else if (widget.value == 'project_page') return 'Редагувати проект';
  }


  // Create textField block for input
  Widget textFieldForAdd() {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Text field block for project name and number
          Padding(
            padding: EdgeInsets.fromLTRB(9, 8, 9, 2),
            child: Column(
              children: [

                textField(
                  TextInputAction.next, 
                  (widget.value == 'project_page' && widget.projectName != '')? widget.projectName.toString() : 'Назва проекту...',
                  (widget.value == 'project_page' && widget.projectName != '')? TextStyle(fontSize: 12, color: lightingMode == ThemeMode.dark? Colors.white : Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  (widget.value == 'project_page' && widget.projectName != '')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                  TextInputType.text, 
                  null,
                  String,
                  width: textFieldWidth,
                  inputValueIndex: 'name'
                ),

                SizedBox(height: 8),

                textField(
                  TextInputAction.next, 
                  'Номер проекту...', 
                  null, null,
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
                  'Адреса', 
                  null, null,
                  TextInputType.text, 
                  null,
                  String,
                  width: textFieldWidth,
                  inputValueIndex: 'address'
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


  // Text fields with button for adding new project
  Widget addProjectTextField() {
    
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          textFieldForAdd(),
          button(functions: [addToBox, redirect], text: "Додати", rightPadding: 93),

        ],
      ),
    );
  }


  // Text fields with button for editing project
  Widget changeProjectTextField() {

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          textFieldForAdd(),
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
                title: Text('${getPageName()}'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // create text fields for add/edit project, depending on page, where you're in
                      if (widget.value == 'projects') addProjectTextField(),
                      if (widget.value == 'project_page') changeProjectTextField(),
                    
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

        obscureText: (inputValueIndex == 'password' || inputValueIndex == 'confirmPassword')? true : false,
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
                fieldValues['name'] = widget.projectName;
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