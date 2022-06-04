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
bool currentAccountIsAdmin = false;
bool statusLogOut = false;


// Function for getting current account from Hive database
getCurrentAccountFromBox() async {
  currentAccountBox = await Hive.openBox('accounts_data');
  currentAccountBoxSize = currentAccountBox.length;
  
  for (var key in currentAccountBox.keys) {
    if ((currentAccountBox.get(key)).isRegistered == true) {
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
            (currentAccountBox.get(key)).projects,            
          )
        );

      currentAccount = null;
      statusLogOut = true;
      currentAccountIsRegistered = false;
      currentAccountIsAdmin = false;
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
      isRegistered = (await currentAccount).isRegistered == true;
    } catch(e) {}

    try {
      isAdmin = (await currentAccount).login == 'admin';
    } catch(e) {}
  } else {
    return [false, false];
  }

  currentAccountIsRegistered = isRegistered;
  currentAccountIsAdmin = isAdmin;

  return [isRegistered, (isAdmin == true && isRegistered == true)? true : false];
}


// Window which displays error or waiting
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



// Text field border decoration
OutlineInputBorder textFieldStyle = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.grey.shade700, width: 2.0),
);



// Function which creates standart app button
Widget button({List<Function>? functions, String? text, BuildContext? context, String? route, List? routingArgs, double? minWidth, EdgeInsetsGeometry? edgeInsetsGeometry, double? rightPadding}) {
  
  return Padding(
    padding: edgeInsetsGeometry?? EdgeInsets.fromLTRB((rightPadding == null? 0.0 : rightPadding), 7.0, 0.0, 0.0),

    child: FlatButton(
      minWidth: minWidth?? 150.0,
      child: Text(text!, style: TextStyle(color: lightingMode==ThemeMode.dark? Colors.white : Colors.black87)),

      onPressed: () {
        for (var func in functions!) {
          func();
        }

        if (route!=null && context!=null) { 
          switch(route) {
            case '/projects_page': Navigator.pop(context, false); break;
            case '/home': Navigator.pushNamedAndRemoveUntil(context, route, ModalRoute.withName(route)); break;
            case 'soundings': Navigator.push(context, MaterialPageRoute(builder: (context) => Soundings(routingArgs![0]))); break;
            case 'projects': Navigator.push(context, MaterialPageRoute(builder: (context) => Projects())); break;
          } 
        }
      },

      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: lightingMode==ThemeMode.dark? Colors.white : Colors.black87,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),

    ),
  );
}



// Alert dialog, shown if you are to delete something 
onDeleteAlert(BuildContext context, String? text, Function function, {String? route, var materialPageRoute}) {
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
              Navigator.pop(context, false); 
              if (route!=null) Navigator.pushReplacementNamed(context, route);
              if (materialPageRoute!=null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => materialPageRoute));
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



// Alert dialog, shown if you are to delete something 
attentionAlert(BuildContext context, String? text, {String? route, var materialRoute}) {
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(''),
        content: Text('$text', style: TextStyle(fontSize: 18)),
        actions: [
          
          FlatButton(
            child: const Text('Так'),
            onPressed: () {
              Navigator.of(context).pop(); 
              if (route != null) 
                Navigator.pushReplacementNamed(context, route);
              else 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => materialRoute));
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


// Alert dialog
alert(var alertText, var context) {

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


// Function that compares 2 String dates
bool compareTwoDates(String date1, String date2) {
  List<String> splitDate1 = date1.split("/");
  List<String> splitDate2 = date2.split("/");
  var dateNow = DateTime.now();

  DateTime date1Vals = DateTime.parse(splitDate1[2] + "-" + splitDate1[1] + "-" + splitDate1[0]);
  DateTime date2Vals = DateTime.parse(splitDate2[2] + "-" + splitDate2[1] + "-" + splitDate2[0]);

  return (date1Vals.difference(date2Vals).inDays > 0 || dateNow.difference(date2Vals).inDays < 0)? false : true;
}

