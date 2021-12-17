import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/folderForProjects/Project.dart';
import 'package:shared_preferences/shared_preferences.dart';


var projectsList = [Project('тест', '1', '23-12-2022', 'Тестовий проект для прикладу')];

/* *************************************************************************
 Classes for page with the list of projects
************************************************************************* */
class Projects extends StatefulWidget {
  Projects();
  
  @override
  ProjectsState createState() => ProjectsState();
}


class ProjectsState extends State<Projects>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Проекти'),
        ),

        body: Column(
          children: [
            for (var i in projectsList)
              i,
          ]
        ),

        bottomNavigationBar: Bottom.dependOnPage('projects'),
      );
  }
}
