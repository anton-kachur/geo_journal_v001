import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';


class AccountPage extends StatefulWidget {
  var mode;

  AccountPage(this.mode);
  
  @override
  AccountPageState createState() => AccountPageState();
}


class AccountPageState extends State<AccountPage> {
  var login;
  var password;
  var email;
  var phoneNumber;

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
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: (widget.mode=='sign_up')? Text('Реєстрація'): Text('Увійти в акаунт'),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createTextFieldsBlock(20.0, 20.0, ["логін...", "пароль..."]),
            if (widget.mode == 'sign_up') createTextFieldsBlock(0.0, 20.0, ["електронна пошта...", "номер телефону..."], true),
          ]
        ),

        bottomNavigationBar: Bottom(),
    );
  }


  Widget createTextFieldsBlock(verticalPadding, horizontalPadding, hintTextVals, [isSecondBlockNeeded]) {
    var TextFieldStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            width: this.textFieldWidth,
            height: this.textFieldHeight,
            child: TextFormField(
              focusNode: (isSecondBlockNeeded==true)? null:_focusNode,
              autofocus: false,
              textInputAction: TextInputAction.next,
              

              decoration: InputDecoration(
                hintText: hintTextVals[0],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade500),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: TextFieldStyle,
                enabledBorder: TextFieldStyle,
              ),
              
              onChanged: (value) {
                this.login = value;
                print("Name entered : $value");
              }
            )
          ),

          Container(
            width: this.textFieldWidth,
            height: this.textFieldHeight,
            child: TextFormField(
              autofocus: false,
              textInputAction: (isSecondBlockNeeded==true)? TextInputAction.done: TextInputAction.next,

              decoration: InputDecoration(
                hintText: hintTextVals[1],
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
                
                focusedBorder: TextFieldStyle,
                enabledBorder: TextFieldStyle,
              ),
              
              onChanged: (value) {
                this.password = value;
                print("Name entered : $value");
              }

            )
          ),
          
        ]
      )
    );
  }

}