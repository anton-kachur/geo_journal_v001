import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountsDBClasses.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/soundings/Soundigs.dart';
import 'package:hive_flutter/hive_flutter.dart';


// Light/dark mode of an app
var lightingMode;

// Current user account
var currentAccountBox;
var currentAccountBoxSize;
var currentAccount = getCurrentAccountFromBox();
bool currentAccountIsRegistered = false;
bool statusLogOut = false;


// Function for getting current account from Hive database
getCurrentAccountFromBox() async {
  currentAccountBox = await Hive.openBox<UserAccountDescription>('accounts');
  currentAccountBoxSize = currentAccountBox.length;
  
  for (var key in currentAccountBox.keys) {
    if ((currentAccountBox.get(key)).isRegistered == true) {
      print("${currentAccountBox.get(key).toString()}");
      return currentAccountBox.get(key);
    }
  }

}



// Function for logging out
Future<bool> logOutFromAccount() async {
    
  for (var key in currentAccountBox.keys) {
    if (
      (currentAccountBox.get(key)).login == (await currentAccount).login &&
      (currentAccountBox.get(key)).password == (await currentAccount).password
    ) {
      currentAccountBox.put(
          key, 
          UserAccountDescription(
            (currentAccountBox.get(key)).login, 
            (currentAccountBox.get(key)).password,
            (currentAccountBox.get(key)).email, 
            (currentAccountBox.get(key)).phoneNumber,
            (currentAccountBox.get(key)).position,
            false,
            (currentAccountBox.get(key)).isAdmin,
          )
        );

      currentAccount = null;
      statusLogOut = true;
      return true;
    }
  }

  return false;

}


// Check if user is registered
Future checkIfUserIsRegistered() async { 
  var isRegistered = false;
  var isAdmin = false;
  
  if (currentAccount != null) {
    try {
      isRegistered = (await currentAccount).isRegistered;
    } catch(e) {}

    try {
      isAdmin = (await currentAccount).login == 'admin';
    } catch(e) {}
  }

  currentAccountIsRegistered = isRegistered;

  return [isRegistered, (isAdmin == true && isRegistered == true)? true : false];
}


Widget waitingOrErrorWindow(var text, var context) {
  return Container(
    height: MediaQuery.of(context).size.height, 
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.fromLTRB(130, MediaQuery.of(context).size.height/2, 0.0, 0.0),

      child: Text(
        text,
        style: TextStyle(fontSize: 20, decoration: TextDecoration.none, color: Colors.black),
      ),
    )
  );
}


// Text field border decoration #1
/*OutlineInputBorder textFieldStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
);*/


// Text field border decoration #2
OutlineInputBorder textFieldStyle = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.grey.shade700, width: 2.0),
);



// Function which creates standart app button
Widget button({List<Function>? functions, String? text, BuildContext? context, String? route, List? routingArgs, double? minWidth, EdgeInsetsGeometry? edgeInsetsGeometry}) {
  return Padding(
    padding: edgeInsetsGeometry?? EdgeInsets.fromLTRB(100.0, 7.0, 0.0, 0.0),

    child: FlatButton(
      minWidth: minWidth?? 150.0,
      child: Text(text!, style: TextStyle(color: lightingMode==ThemeMode.dark? Colors.white : Colors.black87)),

      onPressed: () {
        for (var func in functions!) {
          func();
        }

        if (route!=null && context!=null) { 
          switch(route) {
            case '/projects_page': Navigator.of(context).popUntil(ModalRoute.withName(route)); break;
            case '/home': Navigator.pushNamedAndRemoveUntil(context, route, ModalRoute.withName(route)); break;
            case 'soundings': Navigator.push(context, MaterialPageRoute(builder: (context) => Soundings(routingArgs![0]))); break;
            case 'projects': Navigator.push(context, MaterialPageRoute(builder: (context) => Projects())); break;
          } 
        }
      },

      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: lightingMode==ThemeMode.dark? Colors.white : Colors.black87,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),

    ),
  );
}



// Alert dialog, shown if you are to delete something 
onDeleteAlert(BuildContext context, String? text, Function function, String route) {
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(''),
        content: Text('Ви дійсно бажаєте видалити $text?', style: TextStyle(fontSize: 18)),
        actions: [
          
          FlatButton(
            child: const Text('Так'),
            onPressed: () { 
              function();
              Navigator.of(context).pop(); 
              Navigator.pushReplacementNamed(context, route);
            },
          ),

          FlatButton(
            child: const Text('Ні'),
            onPressed: () { 
              Navigator.of(context).pop(); 
            },
          )

        ],
      );
    }
  );
}


/*Widget textField(var textInputAction, var labelText, var keyboardType, var inputFormatters, {var width, var height, var inputValueIndex, var otherValue}) {
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
          else { 
            if (otherValue == 'find') { elementToFind = value; } 
            else { fieldValues[otherValue] = value; }
          }
        }
      )
    );
  }*/
