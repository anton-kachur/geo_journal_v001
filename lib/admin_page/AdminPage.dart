import 'package:flutter/material.dart';
import 'package:geo_journal_v001/admin_page/DatabaseSettingsPage.dart';
import 'package:geo_journal_v001/admin_page/SoilDataBaseSettings.dart';
import 'package:geo_journal_v001/admin_page/InfoDataBaseSettings.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';


/* ***************************************************************
  Classes for creating page of administrator settings
**************************************************************** */
class AdminPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0.000001,
          backgroundColor: Colors.brown,
          title: Text('Адмін. сторінка', style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: false
        )
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Database changes
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text('Налаштування бази даних'),
                PopupMenuButton(

                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Користувачі'), value: 'accounts_data'),
                    PopupMenuItem(child: Text('Типи грунтів'), value: 'soil_types'),
                    PopupMenuItem(child: Text('Інформація'), value: 'info')
                  ],

                  onSelected: (value) {
                    if (value == 'accounts_data')
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DatabaseSettingsPage(value)));
                    else if (value == 'info')
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoDatabaseSettingsPage(value)));
                    else if (value == 'soil_types')
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SoilDatabaseSettingsPage(value)));
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15.0),
          ),

        ],
      ),
      
      bottomNavigationBar: Bottom(),
    );
  }
  
}