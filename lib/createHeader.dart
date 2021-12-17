import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateHeader extends StatelessWidget {
  var model;

  CreateHeader(this.model);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0.000001,
          backgroundColor: Colors.blue.shade400,
          title: Text('GeoJournal v0.0.1', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              icon: Icon(Icons.settings_display),
              onPressed: () => model.toggleMode(),
            )
          ]
        )
      );
  }
}

