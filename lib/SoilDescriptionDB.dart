import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class SoilDescriptionDB extends StatelessWidget {
  @HiveField(0)
  final String description;
  
  SoilDescriptionDB(this.description);

  @override
  Widget build(BuildContext context) {
    return Text('dgtgdhhhhhhhhhhhhhh');
  }
}