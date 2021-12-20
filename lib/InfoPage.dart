import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';


/* ***************************************************************
  Classes for creating information page
**************************************************************** */
class InfoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.brown, title: Text('Про застосунок')),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text('Застосунок для геологів'),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('Розробник: Качур А.В.'),
          ),
            
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Версія: 0.0.1'),
          )
        ]
      ),

      bottomNavigationBar: Bottom(),
    );
  }
}
