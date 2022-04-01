import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for the page of registration/authorization
**************************************************************** */
class AddAccountPage extends StatefulWidget {
  var mode;

  AddAccountPage(this.mode);
  
  @override
  AddAccountPageState createState() => AddAccountPageState();
}


class AddAccountPageState extends State<AddAccountPage> {
  var login;
  var password;
  var email;
  var phoneNumber;

  var box;
  var boxSize;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;

  late FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    var boxx = await Hive.openBox<AccountDescription>(boxName);
    boxSize = boxx.length;
    box = boxx;

    return Future.value(boxx.values);     
  }  

  // Function for adding data to database
  Widget addToBox() {
    box.put(
      'account${boxSize+2}', 
      AccountDescription(login, password, email, phoneNumber)
    );
    
    box.close();
    return Text('');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: (widget.mode=='sign_up')? Text('Реєстрація'): Text('Увійти в акаунт')),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          createTextFieldsBlock(20.0, 20.0, ["логін...", "пароль..."]),
          if (widget.mode == 'sign_up') createTextFieldsBlock(0.0, 20.0, ["електронна пошта...", "номер телефону..."], true),
         
          // Add button 
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),
            child: FlatButton(
              minWidth: 150.0,
              child: Text("Додати", style: TextStyle(color: Colors.black87)),
              onPressed: ()=>{ addToBox() },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black87,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ), 
            ),
          )

        ]
      ),

      bottomNavigationBar: Bottom(),
    );
  }

  // Function for creating widget of text fields, stored in block
  Widget createTextFieldsBlock(verticalPadding, horizontalPadding, hintTextVals, [isSecondBlockNeeded]) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text field for login input
          Container(
            width: this.textFieldWidth,
            height: this.textFieldHeight,
            child: TextFormField(
              focusNode: (isSecondBlockNeeded==true)? null : _focusNode,
              autofocus: false,
              textInputAction: TextInputAction.next,         

              decoration: InputDecoration(
                hintText: hintTextVals[0],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onChanged: (value) { this.login = value; }
            )
          ),

          // Text field for password input
          Container(
            width: this.textFieldWidth,
            height: this.textFieldHeight,
            child: TextFormField(
              autofocus: false,
              textInputAction: (isSecondBlockNeeded==true)? TextInputAction.done: TextInputAction.next,
              
              keyboardType: (hintTextVals[1] == "номер телефону...")? TextInputType.number : TextInputType.text,
              inputFormatters: [
                if (hintTextVals[1] == "номер телефону...") FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],

              decoration: InputDecoration(
                hintText: hintTextVals[1],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              onChanged: (value) { this.password = value; }
            )
          ),
        ]
      )
    );
  }
}