import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/Application.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'dart:io';

/* ***************************************************************
  Classes for creating settings page
**************************************************************** */
class Settings extends StatefulWidget {
  var model;

  Settings(this.model);
  
  @override
  SettingsState createState() => SettingsState();
}


class SettingsState extends State<Settings>{
  var _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text('Налаштування')),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enable / disable dark mode 
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Темна тема'),
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeColor: Colors.black87,
                    value: _switchValue, 
                    onChanged: (value) {
                      setState(() {
                        widget.model.toggleMode();
                        _switchValue = value;
                      });
                    }
                  )
                )
              ]
            )
          ),

          // Change language
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Мова'),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('English'), value: 'en'),
                    PopupMenuItem(child: Text('Українська'), value: 'ua'),
                  ],
                  onSelected: (value) {
                    
                    Application.of(context).setLocale(Locale.fromSubtags(languageCode: value.toString()));
                    appLocale = Locale.fromSubtags(languageCode: value.toString());
                    setState(() {
                      
                    });
                  }
                    //=> 
                    //widget.model.setLocale(Locale.fromSubtags(languageCode: value.toString())); 
                  

                  //{  
                    //setState(() { widget.model.locale = Locale.fromSubtags(languageCode: value.toString()); });
                  //},
                ),
              ],
            ),
          ),

          // Account settings / registration
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Акаунт'),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Реєстрація'), value: 'sign_up'),
                    PopupMenuItem(child: Text('Увійти'), value: 'log_in'),
                  ],
                  onSelected: (value) {
                    setState(() { 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountPage(value))); 
                    });
                  },
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