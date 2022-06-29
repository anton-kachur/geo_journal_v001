import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:geo_journal_v001/soundings/sounding_and_DB/SoundingDBClasses.dart';
import 'package:geo_journal_v001/wells/soil_and_DB/SoilSampleDBClasses.dart';
import 'package:geo_journal_v001/wells/well_and_DB/WellDBClasses.dart';
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

  var textFieldWidth = 320.0;


  // Function for getting data from Hive database
  getDataFromBox(var boxName) async {
    box = await Hive.openBox(boxName);
    boxSize = box.length;

    if ((await currentAccount) != null) {
      for (var key in box.keys) {
        if (
          (box.get(key)).login == (await currentAccount).login
        ) {
          return Future.value(box.get(key));  
        }
      }
    }
    
    
  }  


  // Function for adding data to database
  void addToBox() {

    box.put(
      'account${boxSize?? 0}', 
      UserAccountDescription(
        fieldValues['login'], 
        fieldValues['password'], 
        fieldValues['email'], 
        fieldValues['phoneNumber'], 
        fieldValues['position'],
        fieldValues['isRegistered'],
        fieldValues['isAdmin'],
        [ProjectDescription(
          'тест', '1', '12/12/2033', 'вул. Велика Васильківська, Київ', 'примітки', 
          [WellDescription(
            '1', '01/01/2023', 50.4536, 30.5164, '1', 
            [SoilForWellDescription('Пісок', 0.2, 0.5, 'примітки', '1', '1')]
          )], 
          [SoundingDescription(0.0, 2.234, 2.546, 'помітки', '1')]
        )]   
      )
    );

  }


  // Function for adding data to database
  void changeInBox() async {
    for (var key in box.keys) {
      if ((box.get(key)).login == (await currentAccount).login) {
        
        box.put(
          key, 
          UserAccountDescription(
            fieldValues['login'] == ''? (box.get(key)).login : fieldValues['login'],
            fieldValues['password'] == ''? (box.get(key)).password : fieldValues['password'], 
            fieldValues['email'] == ''? (box.get(key)).email : fieldValues['email'],
            fieldValues['phoneNumber'] == ''? (box.get(key)).phoneNumber : fieldValues['phoneNumber'],
            fieldValues['position'] == ''? (box.get(key)).position : fieldValues['position'],
            fieldValues['isRegistered'] == ''? (box.get(key)).isRegistered : fieldValues['isRegistered'],
            fieldValues['isAdmin'] == ''? (box.get(key)).isAdmin : fieldValues['isAdmin'],   
            (box.get(key)).projects    
          )
        );
        
        currentAccount = box.get(key);
        statusLogOut = false;
      }
    }

  }


  // Check if 'password' and 'confirm password' fields match and if email adsress is correctly written. 
  // If true - register new account, else - show alert dialog
  void checkIfSignUpCorrect() {
    fieldValues['isRegistered'] = true;
    addToBox();
    checkIfLogInCorrect();

    alert('Ви успішно зареєструвалися.\nЛаскаво просимо!', context); 
  }


  // Check if 'password' and 'confirm password' fields match and if email adsress is correctly written. 
  // If true - register new account, else - show alert dialog
  void checkIfChangeCorrect() {
    fieldValues['isRegistered'] = true;
    changeInBox();
    statusLogOut = false;

    alert('Ви успішно зареєструвалися.\nЛаскаво просимо!', context); 
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
            (box.get(key)).projects
          )
        );
        
        alert('Ви успішно увішли в акаунт', context);
        currentAccount = box.get(key);
        statusLogOut = false;
      }    
    }

    if (correct == 0) { alert('Перевірте будь-ласка введені дані', context); }
  }



  // Creates input fields if user wishes to register new account
  List<Widget> signUpTextFields() {
    return [
      createTextFieldsBlock(
        1, [20.0, 8.0], 
        ["*логін...", "*електронна пошта..."], 
        [TextInputType.text, TextInputType.emailAddress],
        [null, null],
        ['login', 'email']
      ),

      createTextFieldsBlock(
        2, [0.0, 8.0], 
        ["*пароль...", "*підтвердити пароль..."], 
        [TextInputType.text, TextInputType.text],
        [null, null],
        ['password', 'confirmPassword']
      ),

      createTextFieldsBlock(
        3, [0.0, 4.0], 
        ["номер телефону...", "позиція..."], 
        [TextInputType.phone, TextInputType.text],
        [null, null],
        ['phoneNumber', 'position']
      ),

      button(functions: [checkIfSignUpCorrect], text: "Зареєструватися", context: context, route: "/home", rightPadding: 104)
    ];
  }


  // Creates input fields if user wishes to change his/her account
  List<Widget> changeAccountTextFields(hintTextValues) {
    return [
      createTextFieldsBlock(
        1, [20.0, 8.0], 
        hintTextValues[0], 
        [TextInputType.text, TextInputType.emailAddress],
        [null, null],
        ['login', 'email']
      ),

      createTextFieldsBlock(
        2, [0.0, 8.0], 
        hintTextValues[1],
        [TextInputType.text, TextInputType.text],
        [null, null],
        ['password', 'confirmPassword']
      ),

      createTextFieldsBlock(
        3, [0.0, 4.0], 
        hintTextValues[2],
        [TextInputType.phone, TextInputType.text],
        [null, null],
        ['phoneNumber', 'position']
      ),

      button(functions: [checkIfChangeCorrect], text: "Зберегти зміни", context: context, route: "/home", rightPadding: 105),
    ];
  }


  // Creates input fields if user wishes to enter his/her account
  List<Widget> logInTextFields() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 15, 8),
        child: Text('Ви можете увійти за допомогою логіну, електронної пошти або номеру телефона'),
      ),

      createTextFieldsBlock(
        1, [20.0, 8.0], 
        ["логін...", "електронна пошта..."], 
        [TextInputType.text, TextInputType.emailAddress],
        [null, null],
        ['login', 'email']
      ),

      createTextFieldsBlock(
        2, [0.0, 4.0], 
        ["номер телефону...", "*пароль..."], 
        [TextInputType.phone, TextInputType.text],
        [null, null],
        ['phoneNumber', 'password']
      ),

      button(functions: [checkIfLogInCorrect], text: "Увійти", context: context, route: "/home", rightPadding: 102),
    ];
  }



  Widget getTitle() {
    if (widget.mode=='sign_up') return Text('Реєстрація'); 
    else if (widget.mode=='log_in') return Text('Увійти в акаунт');
    return Text('Налаштування акаунту');
  }



  @override
  Widget build(BuildContext context) {
    var boxData = getDataFromBox('accounts_data');

    
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
                title: getTitle(),
                automaticallyImplyLeading: false
              ),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (widget.mode == 'sign_up') 
                    for (var widget in signUpTextFields())
                      widget
                  else if (widget.mode == 'log_in')
                    for (var widget in logInTextFields())
                      widget
                  else 
                    for (var widget in changeAccountTextFields(
                      [[snapshot.data.login?? "логін...", snapshot.data.email?? "електронна пошта..."],
                      [snapshot.data.password?? "новий пароль...", "підтвердити новий пароль..."], 
                      [snapshot.data.phoneNumber?? "номер телефону...", snapshot.data.position?? "позиція..."]]
                    ))
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
  Widget textField(
    TextInputAction? textInputAction, String? labelText, TextInputType? keyboardType, 
    TextInputFormatter? inputFormatters, 
    {double? width, double? height, String? inputValueIndex, }
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

        obscureText: ((inputValueIndex == 'password' || inputValueIndex == 'confirmPassword'))? true : false,
        autocorrect: true,
        enableSuggestions: true,

        cursorRadius: const Radius.circular(10.0),
        cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: (widget.mode == 'change' && inputValueIndex == 'login')? TextStyle(fontSize: 12, color: Colors.black87) : TextStyle(fontSize: 12, color: Colors.grey.shade400),
          labelStyle: (widget.mode == 'change' && inputValueIndex == 'login')? TextStyle(fontSize: 12, color: lightingMode == ThemeMode.dark? Colors.white : Colors.black87) : TextStyle(fontSize: 12, color: Colors.grey.shade400),

          contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 5),
          
          focusedBorder: textFieldStyle,
          enabledBorder: textFieldStyle,
        ),
        
        onChanged: (String value) { 
          if (inputValueIndex != null) {
            if (widget.mode == 'change' && inputValueIndex == 'login') {
              fieldValues[inputValueIndex] = currentAccount.login;
            } else {
              
              fieldValues[inputValueIndex] = value; 
            }
          }
        },

        onFieldSubmitted: (String value) {
          
            var correct = 0;

            if (inputValueIndex == 'password') {
              value.length < 8? alert('Пароль надто короткий', context) : correct++;
              value.contains(RegExp(r'[A-Za-z0-9]'))? correct++ : alert('Пароль повинен містити хоча б одну літеру та цифру', context);
            } else if (inputValueIndex == 'email') {
              value.contains('@')? correct++ : alert('Введіть коректну адресу електронної пошти', context);
            } else if (inputValueIndex == 'confirmPassword') {
              fieldValues['password'] != value? alert('Введені паролі не співпадають', context) : correct++;
            }

            if (correct == 4) {
              fieldValues[inputValueIndex.toString()] = value; 
            }
          
        },
      ),
    );
  }
  



  // Function for creating widget of text fields, stored in block
  Widget createTextFieldsBlock(blockNumber, padding, hintTextVals, textInputTypes, inputFormatters, inputValueIndexes) {
    
    return Padding(
      padding: EdgeInsets.fromLTRB(20, padding[0], 20, padding[1]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          textField(
            TextInputAction.next, 
            hintTextVals[0], 
            textInputTypes[0], 
            inputFormatters[0],
            width: textFieldWidth,
            inputValueIndex: inputValueIndexes[0]
          ),

          SizedBox(height: 8),

          textField(
            blockNumber == 3? TextInputAction.done : TextInputAction.next, 
            hintTextVals[1], 
            textInputTypes[1], 
            inputFormatters[1],
            width: textFieldWidth,
            inputValueIndex: inputValueIndexes[1]
          ),

        ]
      )
    );
  }

}