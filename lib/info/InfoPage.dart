import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/info/InfoPageDBClasses.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Classes for creating information page
**************************************************************** */
class InfoPage extends StatelessWidget {
  late final box;
  
  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox<InfoDescription>('info');
    
    return Future.value(box.values.first);     
  }



  @override
  Widget build(BuildContext context) {

    var boxData = getDataFromBox();


    return FutureBuilder(
      future: boxData,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingOrErrorWindow('Зачекайте...', context);
        } else {
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(

              appBar: AppBar( 
                backgroundColor: Colors.brown, 
                title: Text('Про застосунок'),
                automaticallyImplyLeading: false
              ),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Info data
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    child: Text(snapshot.data.title),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(snapshot.data.developer),
                  ),
                    
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(snapshot.data.version),
                  )

                ]
              ),

              bottomNavigationBar: Bottom(),
            );
        }
      }
    );
  }
  
}
