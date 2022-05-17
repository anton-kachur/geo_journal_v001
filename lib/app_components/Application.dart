import 'package:flutter/material.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/admin_page/AdminPage.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/Settings.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:geo_journal_v001/calculator/Calculators.dart';
import 'package:geo_journal_v001/info/InfoPage.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/soil_types/SoilTypes.dart';
import 'package:geo_journal_v001/weather/WeatherForecasts.dart';
import 'package:provider/provider.dart';


/* ************************************************************
  Classes for creating application and initializing 
  main settings of the app 
************************************************************ */
class Application extends StatefulWidget {
  Application();

  @override
  ApplicationState createState() => ApplicationState();
}


class ApplicationState extends State<Application> {

  @override 
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider<ThemeModel>( 
      create: (_) => ThemeModel(), 
      child: Consumer<ThemeModel>( 
        builder: (_, model, __) { 
          
          lightingMode = model.mode;  // set light/dark theme

          return MaterialApp(

            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(), 
            themeMode: model.mode, // Decides which theme to show.
            debugShowCheckedModeBanner: false,

            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/home': (context) => MainPage(model),
              '/soil_types': (context) => SoilTypes(),
              '/info_page': (context) => InfoPage(),
              '/calculators': (context) => Calculators(),
              '/projects_page': (context) => Projects(),
              '/forecasts_page': (context) => WeatherForecast(),
              '/settings_page': (context) => Settings(model),
              '/admin_page': (context) => AdminPage(),
            },

            home: MainPage(model),
          );
        }, 
      ), 
    );
  }
}


/* ************************************************************
  Class for setting light/dark mode
************************************************************ */
class ThemeModel with ChangeNotifier { 
  ThemeMode _mode; 
  ThemeMode get mode => _mode; 
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode; 
  void toggleMode() { 
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light; 
    notifyListeners(); 
  } 
}


/* ************************************************************
  Classes for creating main page of an app 
************************************************************ */
class MainPage extends StatefulWidget {
  final model;
  MainPage([this.model]);

  @override
  MainPageState createState() => MainPageState();
}


class MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var registerStatus = checkIfUserIsRegistered();

    return FutureBuilder(
      future: registerStatus,  // data retreived from database
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        
          if (snapshot.hasError)
            return waitingOrErrorWindow('Помилка: ${snapshot.error}', context);
          else
            return Scaffold(
              
              appBar: PreferredSize(
                
                preferredSize: Size.fromHeight(60),

                child: AppBar(
                  elevation: 0.000001,
                  backgroundColor: Colors.brown,
                  title: Text('GeoJournal', style: TextStyle(color: Colors.white)),
                  automaticallyImplyLeading: false,
                      
                  actions: [
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.settings),
                      onPressed: () { Navigator.pushNamed(context, '/settings_page'); }
                    )
                  ]
                )

              ),

              body: Container(
                  width: width,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage((widget.model.mode == ThemeMode.dark)? "assets/black_mount_wallpaper.jpg" : "assets/white_mount_wallpaper.jpg"),
                      fit: BoxFit.cover,
                    )
                  ),

                  child: 
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),

                        child: Column(
                          children: [
                            if (snapshot.data[0] == true && snapshot.data[1] == true)
                              buttonConstructor('Сторінка адміністратора', widget.model.mode, route: '/admin_page'),
                            
                            if (snapshot.data[0] == true && snapshot.data[1] == false)
                              buttonConstructor('Налаштування акаунта', widget.model.mode, materialRoute: true),

                            buttonConstructor('Прогноз погоди', widget.model.mode, route: '/forecasts_page'),
                            buttonConstructor('Про застосунок', widget.model.mode, route: '/info_page'),
                          ]
                        )
                      ),  

                  
              ),
              
              bottomNavigationBar: Bottom(),
          );
        
      }
    );
  }


  // Create buttons on home page with routing
  Widget buttonConstructor(String? text, ThemeMode? mode, {String? route, bool materialRoute = false}) {
    return FlatButton(
      minWidth: 210.0,

      child: Text(text!, style: TextStyle(color: (mode == ThemeMode.dark)? Colors.white70 : Colors.white)), 
      
      onPressed: () { 
        if (materialRoute == false) {
          Navigator.pushNamed(context, route!); 
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountPage('change')));
        }
      },
      
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: (mode == ThemeMode.dark)? Colors.white70 : Colors.white,
          width: (mode == ThemeMode.dark)? 1.0 : 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),

    );
  }

}