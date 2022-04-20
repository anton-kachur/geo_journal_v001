import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/accounts/AccountPage.dart';
import 'package:geo_journal_v001/admin_page/AdminPage.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/info/InfoPage.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/Settings.dart';
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
          
          lightingMode = model.mode;

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
    
    return SafeArea(
      child: Stack(
        children: [
          DragBox(Offset(0.0, 0.0), widget.model),
        ],
      ),
    );
  }
}



/* ************************************************************
  Class for creating draggable box with buttons on the 
  main page
************************************************************ */
class DragBox extends StatefulWidget {
  final Offset initPos;
  final model;

  DragBox(this.initPos, this.model);

  @override
  DragBoxState createState() => DragBoxState();
}


class DragBoxState extends State<DragBox> with SingleTickerProviderStateMixin {
  Offset position = Offset(0.0, 0.0);


  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
                
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage((widget.model.mode == ThemeMode.dark)? "assets/black_mount_wallpaper.jpg" : "assets/white_mount_wallpaper.jpg"),
                      fit: BoxFit.cover,
                    )
                  ),

                  child: Stack(
                    children: [
                      Positioned(
                        left: position.dx,
                        top: position.dy,

                        child: Draggable(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(width/5, height/24, width, height),

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
                          
                          onDraggableCanceled: (velocity, offset) { setState(() { position = offset; }); },

                          feedback: Padding(
                            padding: EdgeInsets.fromLTRB(width/5, height/24, width, height),
                            child: Column(
                              children: [
                                if (snapshot.data[0] == true && snapshot.data[1] == true)
                                  buttonConstructor('Сторінка адміністратора', widget.model.mode, route: '/admin_page'),
                                
                                if (snapshot.data[0] == true && snapshot.data[1] == false)
                                  buttonConstructor('Налаштування акаунта', widget.model.mode, materialRoute: true),

                                buttonConstructor('Прогноз погоди', widget.model.mode, route: '/forecasts_page'),
                                buttonConstructor('Про застосунок', widget.model.mode, route: '/info_page'),
                              ]
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),
              ),
              
              bottomNavigationBar: Bottom(),
          );
        
      }
    );
  }


  // Create buttons on home page
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