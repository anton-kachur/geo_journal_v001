import 'package:flutter/material.dart';
import 'package:geo_journal_v001/admin_page/AdminPage.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:geo_journal_v001/InfoPage.dart';
import 'package:geo_journal_v001/projects/Projects.dart';
import 'package:geo_journal_v001/Settings.dart';
import 'package:geo_journal_v001/soil_types/SoilTypes.dart';
import 'package:geo_journal_v001/weather/WeatherForecasts.dart';
import 'package:geo_journal_v001/wells/AddSoilSample.dart';
import 'package:provider/provider.dart';
import 'package:translatable_text_field/translatable_text.dart';


var appLocale = Locale.fromSubtags(languageCode: 'ua');

/* ************************************************************
  Class for creating application and initializing 
  main settings of the app 
************************************************************ */
class Application extends StatefulWidget {
  Application();

  @override
  ApplicationState createState() => ApplicationState();
  static of(BuildContext context) => context.findAncestorStateOfType<ApplicationState>();
}


class ApplicationState extends State<Application> {
  Locale _locale = Locale.fromSubtags(languageCode: 'ua');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
      appLocale = value;
      print('NEW PROJECT LOCALE: ${_locale}');
    });
  }

  get getLocale => _locale;


  @override 
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider<ThemeModel>( 
      create: (_) => ThemeModel(), 
      child: Consumer<ThemeModel>( 
        builder: (_, model, __) { 
          return MaterialApp(

            //translations: LocaleString(),
            locale: _locale,

            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(), 
            themeMode: model.mode, // Decides which theme to show.
            debugShowCheckedModeBanner: false,

            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              'home': (context) => MainPage(),
              '/soil_types': (context) => SoilTypes(),
              '/info_page': (context) => InfoPage(),
              '/projects_page': (context) => Projects(),
              '/forecasts_page': (context) => WeatherForecast(),
              '/settings_page': (context) => Settings(model),
              '/admin_page': (context) => AdminPage(),
              //'/add_project_description': (context) => AddProjectDescription(),
              //'/add_well_description': (context) => AddWellDescription(),
              //'/add_sounding_description': (context) => AddSoundingData(),
              //'/add_soil_sample_description': (context) => AddSoilSample(),
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
  var model;
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
  var model;

  DragBox(this.initPos, this.model);

  @override
  DragBoxState createState() => DragBoxState();
}


class DragBoxState extends State<DragBox> with SingleTickerProviderStateMixin {
  static const buttonWidth = 210.0;
  Offset position = Offset(0.0, 0.0);

  // LIST OF LANGUAGE LOCALES
  /*final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'УКРАЇНСЬКА', 'locale': Locale('ru', 'UA')},
  ];


  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale();
  }*/

  
  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  void _setText() => setState(() {});

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
                      padding: EdgeInsets.fromLTRB(
                        width/5, 
                        height/24,
                        width, 
                        height
                      ),

                      child: Column(
                        children: [
                          buttonConstructor(['Сторінка адміністратора', 'Admin page'], '/admin_page', widget.model.mode),
                          buttonConstructor(['Прогноз погоди', 'Weather forecast'], '/forecasts_page', widget.model.mode),
                          buttonConstructor(['Про застосунок', 'About'], '/info_page', widget.model.mode),
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
                          buttonConstructor(['Сторінка адміністратора', 'Admin page'], '/admin_page', widget.model.mode),
                          buttonConstructor(['Прогноз погоди', 'Weather forecast'], '/forecasts_page', widget.model.mode),
                          buttonConstructor(['Про застосунок', 'About'], '/info_page', widget.model.mode),
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


  Widget buttonConstructor(text, route, mode) {
    return FlatButton(
      minWidth: buttonWidth,

      child: TranslatableText(
        style: TextStyle(color: (mode == ThemeMode.dark)? Colors.white70 : Colors.white),
        displayLanguage: appLocale == 'en'? Languages.english: Languages.ukrainian,
        options: [
          TranslateOption(
            language: Languages.ukrainian, 
            text: text[0],
          ),

          TranslateOption(
            language: Languages.english, 
            text: text[1],
          )
        ] 
      ), 
      
      onPressed: (){
        setState(() {
          
        });
        Navigator.pushNamed(context, route); 
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