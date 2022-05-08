import 'package:geo_journal_v001/projects/project_and_DB/Project.dart';
import 'package:geo_journal_v001/projects/project_and_DB/ProjectDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'AccountsDBClasses.g.dart';

/* ***************************************************************
  Hive class for saving accounts
**************************************************************** */
@HiveType(typeId: 111)
class UserAccountDescription extends HiveObject {
  @HiveField(0)
  var login;
  @HiveField(1)
  var password;
  @HiveField(2)
  var email;
  @HiveField(3)
  var phoneNumber;
  @HiveField(4)
  var position;
  @HiveField(5)
  var isRegistered;
  @HiveField(6)
  var isAdmin;
  @HiveField(7)
  List<ProjectDescription> projects;
  
  UserAccountDescription(
    this.login, this.password, 
    this.email, this.phoneNumber,
    this.position, this.isRegistered, 
    this.isAdmin, this.projects
  );

  @override
  String toString() {
    return '${this.login}  ${this.password}\n${this.email}\n${this.phoneNumber}\n${this.position}\nRegistered: ${this.isRegistered}\nIs admin: ${this.isAdmin}\nProjects:\n${this.projects}\n\n';
  }
}


