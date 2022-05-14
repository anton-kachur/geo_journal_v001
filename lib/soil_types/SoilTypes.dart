import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/soil_types/SoilType.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Class for representing list with soil types
**************************************************************** */
class SoilTypes extends StatelessWidget {
  late final box;
  late final boxSize;


  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('soil_types');
    boxSize = box.length;

    return Future.value(box.values);     
  }  



  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Зачекайте...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Помилка: ${snapshot.error}'));
          else
            return Scaffold(

              appBar: AppBar(
                backgroundColor: Colors.brown, 
                title: Text('Типи грунтів'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // output soil types list
                      for (var element in snapshot.data)
                        SoilType(element.type, element.description, element.image),
                      
                    ]
                  ),
                ),
              ),
              
              bottomNavigationBar: Bottom('soil_types'),
            );
        }
      }
    );
  }

}