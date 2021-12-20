import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AnimationLogo.dart';
import 'package:geo_journal_v001/folderForProjects/AddProjectDescription.dart';
import 'package:geo_journal_v001/AdminPage.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/InfoPage.dart';
import 'package:geo_journal_v001/folderForProjects/Projects.dart';
import 'package:geo_journal_v001/Settings.dart';
import 'package:geo_journal_v001/SoilTypes.dart';
import 'package:geo_journal_v001/CoordinatesParser.dart';
import 'package:geo_journal_v001/weatherForecasts.dart';
import 'package:provider/provider.dart';


/* ************************************************************
  Class for creating application and initializing 
  main settings of the app 
************************************************************ */
class Application extends StatelessWidget {
  @override 
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider<ThemeModel>( 
      create: (_) => ThemeModel(), 
      child: Consumer<ThemeModel>( 
        builder: (_, model, __) { 
          return MaterialApp(
            //locale: Locale.fromSubtags(languageCode: 'en_US'),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(), 
            themeMode: model.mode, // Decides which theme to show.
            debugShowCheckedModeBanner: false,

            initialRoute: '/welcome_page',
            routes: <String, WidgetBuilder>{
              'home': (context) => MainPage(),
              '/welcome_page': (context) => WelcomePage(),
              '/soil_types': (context) => SoilTypes(),
              '/info_page': (context) => InfoPage(),
              '/projects_page': (context) => Projects(),
              '/forecasts_page': (context) => WeatherForecast(),
              '/settings_page': (context) => Settings(model),
              '/admin_page': (context) => AdminPage(),
              '/add_project_description': (context) => AddProjectDescription(),
              '/coordinates_parser_page': (context) => CoordinatesParser(),
            },

            home: MainPage(),
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
  MainPage();

  @override
  MainPageState createState() => MainPageState();
}


class MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          DragBox(Offset(0.0, 0.0)),
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

  DragBox(this.initPos);

  @override
  DragBoxState createState() => DragBoxState();
}


class DragBoxState extends State<DragBox> with SingleTickerProviderStateMixin {
  static const buttonWidth = 210.0;
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
    
    return Scaffold(   
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            elevation: 0.000001,
            backgroundColor: Colors.brown,
            title: Text('GeoJournal', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.settings),
                  onPressed: (){ Navigator.pushNamed(context, '/settings_page'); },
                )
              ]
          )
        ),

        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/black_mount_wallpaper.jpg"),
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
                      padding: EdgeInsets.fromLTRB(
                        width/5, 
                        height/24,
                        width, 
                        height
                      ),

                      child: Column(
                        children: [
                          buttonConstructor('Сторінка адміністратора', '/admin_page'),
                          buttonConstructor('Прогноз погоди', '/forecasts_page'),
                          buttonConstructor('Про застосунок', '/info_page'),
                        ]
                      ),
                    ),
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        position = offset;
                      });
                    },
                    feedback: Padding(
                      padding: EdgeInsets.fromLTRB(
                        width/5, 
                        height/24,
                        width, 
                        height
                      ),

                      child: Column(
                        children: [
                          buttonConstructor('Сторінка адміністратора', '/admin_page'),
                          buttonConstructor('Прогноз погоди', '/forecasts_page'),
                          buttonConstructor('Про застосунок', '/info_page'),
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


  Widget buttonConstructor(text, route) {
    return FlatButton(
      minWidth: buttonWidth,
      child: Text(text, style: TextStyle(color: Colors.white70)),
      onPressed: (){ Navigator.pushNamed(context, route); },
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white70,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ), 
    );
  }
}