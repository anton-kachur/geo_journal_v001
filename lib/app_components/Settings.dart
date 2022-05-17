import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';


/* ***************************************************************
  Classes for creating settings page
**************************************************************** */
class Settings extends StatefulWidget {
  final model;

  Settings(this.model);
  
  @override
  SettingsState createState() => SettingsState();
}


class SettingsState extends State<Settings>{
  var switchDarkModeValue = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text('Налаштування'),
        automaticallyImplyLeading: false
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Enable / disable dark mode 
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text('Темна тема'),
                
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeColor: Colors.black87,
                    value: switchDarkModeValue, 
                    onChanged: (value) {
                      setState(() {
                        widget.model.toggleMode();
                        switchDarkModeValue = value;
                        lightingMode = widget.model.mode;
                      });
                    }
                  )
                )

              ]
            )
          ),


          // Account settings / registration / log out
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text('Акаунт'),
                
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Реєстрація'), value: 'sign_up'),
                    PopupMenuItem(child: Text('Увійти'), value: 'log_in'),
                    if (currentAccount!=null) PopupMenuItem(child: Text('Вийти з акаунту'), value: 'log_out'),
                  ],

                  onSelected: (value) {
                    if (value == 'log_out') {
                      bool logOutStatus = false;

                      FutureBuilder(
                        future: logOutFromAccount(),  // data retreived from database
                        builder: (BuildContext context, AsyncSnapshot snapshot) {

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return waitingOrErrorWindow('Зачекайте...', context);
                          } else {
                            if (snapshot.hasError) {
                              return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
                            } else {
                              if (snapshot.data == true) logOutStatus = true;
                              return Text('');
                            }
                          }
                        }
                      );

                      
                      if (logOutStatus == false) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                      }

                    } else {
                      setState(() { 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountPage(value))); 
                      });
                    }
                  },
                  
                ),

              ],
            ),
          ),


          if (currentAccountIsRegistered && currentAccountIsAdmin == false) 
            // Account settings
            Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text('Налаштування акаунту'),
                  
                  IconButton(    
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,

                    padding: EdgeInsets.fromLTRB(1.0, 0.0, 0.0, 7.0),

                    icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountPage('change')));
                    }
                  ),

                ],
              ),
            ), 

          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text('Вийти'),
                
                IconButton(    
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  padding: EdgeInsets.fromLTRB(1.0, 0.0, 0.0, 7.0),

                  icon: Icon(Icons.exit_to_app, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Ви дійсно бажаєте вийти?'),
                          content: Text('', style: TextStyle(fontSize: 18)),
                          actions: [
                            
                            FlatButton(
                              child: const Text('Так'),
                              onPressed: () { exit(0); },
                            ),

                            FlatButton(
                              child: const Text('Ні'),
                              onPressed: () { Navigator.of(context).pop(); },
                            )

                          ],
                        );
                      }
                    );
                    
                  }
                ),

              ],
            ),
          ),

        ],
      ),

      bottomNavigationBar: Bottom(),
    );
  }
}