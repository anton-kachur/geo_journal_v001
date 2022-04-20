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
  final mode;

  AddAccountPage(this.mode);
  
  @override
  AddAccountPageState createState() => AddAccountPageState();
}


class AddAccountPageState extends State<AddAccountPage> {

  Map<String, Object> fieldValues = {
    'login': '', 
    'password': '', 
    'email': '', 
    'phoneNumber': '', 
    'position': '',
    'confirmPassword': '',
    'isRegistered': false,
    'isAdmin': false
  };

  var box;
  var boxSize;

  var textFieldWidth = 155.0;
  var textFieldHeight = 32.0;


  // Function for getting data from Hive database
  Future getDataFromBox(var boxName) async {
    box = await Hive.openBox<UserAccountDescription>(boxName);
    boxSize = box.length;
    
    return Future.value(box.values);     
  }  


  // Function for adding data to database
  Widget addToBox() {

    box.put(
      'account${boxSize+2}', 
      UserAccountDescription(
        fieldValues['login'], 
        fieldValues['password'], 
        fieldValues['email'], 
        fieldValues['phoneNumber'], 
        fieldValues['position'],
        fieldValues['isRegistered'],
        fieldValues['isAdmin'],
      )
    );
    
    box.close();
    return Text('');
  }


  // Check if 'password' and 'confirm password' fields match and if email adsress is correctly written. 
  // If true - register new account, else - show alert dialog
  void checkIfSignUpCorrect() {
    int correct = 0;
        
    fieldValues['password'] != fieldValues['confirmPassword']? alert('Введені паролі не співпадають') : correct++;
    fieldValues['email'].toString().contains('@')? correct++ : alert('Введіть коректну адресу електронної пошти');
    
    if (correct==2) { 
      fieldValues['isRegistered'] = true;
      addToBox();
      statusLogOut = false;

      alert('Ви успішно зареєструвалися.\nЛаскаво просимо!'); 
    } else { 
      alert('Перевірте будь ласка введені дані'); 
    }
  }


  // Check if 'password' and 'confirm password' fields match. 
  // If true - register new account, else - show mismatch alert dialog
  void checkIfLogInCorrect() {
    int correct = 0;

    for (var key in box.keys) {
      if ((
          (box.get(key)).login == fieldValues['login'] || 
          (box.get(key)).email == fieldValues['email'] || 
          (box.get(key)).phoneNumber == fieldValues['phoneNumber']) && 
          (box.get(key)).password == fieldValues['password']
        ) {
        
        correct++;

        box.get(key).isRegistered = true; 
    
        box.put(
          key, 
          UserAccountDescription(
            (box.get(key)).login, 
            (box.get(key)).password,
            (box.get(key)).email, 
            (box.get(key)).phoneNumber,
            (box.get(key)).position,
            true,
            (box.get(key)).isAdmin,
          )
        );
        
        alert('Ви успішно увішли в акаунт');
        currentAccount = box.get(key);
        statusLogOut = false;
        print("CURRENT ACCOUNT AFTER LOG IN: ${box.get(key).toString()}");
      }    
    }

    if (correct == 0) { alert('Перевірте будь-ласка введені дані'); }
  }


  // Alert dialog, which is shown if 'password' and 'confirm password' fields mismatch 
  alert(var alertText) {

    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: Text(alertText, style: TextStyle(fontSize: 18)),
          actions: [
            // Press 'OK' to proceed
            FlatButton(
              child: const Text('ОК'),
              onPressed: () { Navigator.of(context).pop(); },
            )
          ],
        );
      }
    );
  }


  // Creates input fields if user wishes to register new account
  List<Widget> signUpTextFields() {
    return [
      createTextFieldsBlock(
        1, [20.0, 20.0], 
        ["*логін...", "*електронна пошта..."], 
        [TextInputType.text, TextInputType.text],
        [FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9']")), FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9'@.]"))],
        ['login', 'email']
      ),

      createTextFieldsBlock(
        2, [5.0, 20.0], 
        ["*пароль...", "*підтвердити пароль..."], 
        [TextInputType.text, TextInputType.text],
        [FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9'!@#$%^&*]")), FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9'!@#$%^&*]"))],
        ['password', 'confirmPassword']
      ),

      createTextFieldsBlock(
        3, [10.0, 20.0], 
        ["номер телефону...", "позиція..."], 
        [TextInputType.number, TextInputType.text],
        [FilteringTextInputFormatter.allow(RegExp(r"[0-9]")), FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє']"))],
        ['phoneNumber', 'position']
      ),

      button(functions: [checkIfSignUpCorrect], text: "Зареєструватися", context: context, route: "/home"),
    ];
  }


  // Creates input fields if user wishes to enter his/her account
  List<Widget> logInTextFields() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
        child: Text('Ви можете увійти за допомогою логіну, пошти або номера телефона'),
      ),

      createTextFieldsBlock(
        1, [20.0, 20.0], 
        ["логін...", "електронна пошта..."], 
        [TextInputType.text, TextInputType.text],
        [FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9']")), FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9'@.]"))],
        ['login', 'email']
      ),

      createTextFieldsBlock(
        2, [0.0, 20.0], 
        ["номер телефону", "пароль..."], 
        [TextInputType.number, TextInputType.text],
        [FilteringTextInputFormatter.allow(RegExp(r"[0-9]")), FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zА-Яа-яЇїІіЄє0-9'!@#$%^&*]"))],
        ['phoneNumber', 'password']
      ),

      button(functions: [checkIfLogInCorrect], text: "Увійти", context: context, route: "/home"),
    ];
  }



  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox('accounts');

    
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
                title: (widget.mode=='sign_up')? Text('Реєстрація'): Text('Увійти в акаунт'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (widget.mode == 'sign_up') 
                    for (var widget in signUpTextFields())
                      widget
                  else 
                    for (var widget in logInTextFields())
                      widget
                  

                ]
              ),

              bottomNavigationBar: Bottom(),
            );
        }
      }
    );
  }



  // Create text field with parameters
  Widget textField(var textInputAction, var labelText, var keyboardType, var inputFormatters, {var width, var height, var inputValueIndex, var otherValue}) {
    return Container(
      width: width,
      height: height,
      child: TextFormField(
        autofocus: false,
        textInputAction: textInputAction,

        keyboardType: keyboardType,
        inputFormatters: [
          inputFormatters
        ],

        cursorRadius: const Radius.circular(10.0),
        cursorColor: Colors.black,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
          labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onFieldSubmitted: (String value) { 
          if (inputValueIndex != null) { fieldValues[inputValueIndex] = value; }
        }
      )
    );
  }
  



  // Function for creating widget of text fields, stored in block
  Widget createTextFieldsBlock(blockNumber, padding, hintTextVals, textInputTypes, inputFormatters, inputValueIndexes) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding[0], horizontal: padding[1]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          textField(
            TextInputAction.next, 
            hintTextVals[0], 
            textInputTypes[0], 
            inputFormatters[0],
            width: textFieldWidth,
            height: textFieldHeight,
            inputValueIndex: inputValueIndexes[0]
          ),

          textField(
            blockNumber == 3? TextInputAction.done : TextInputAction.next, 
            hintTextVals[1], 
            textInputTypes[1], 
            inputFormatters[1],
            width: textFieldWidth,
            height: textFieldHeight,
            inputValueIndex: inputValueIndexes[1]
          ),

        ]
      )
    );
  }

}