import 'package:flutter/material.dart';
import 'package:geo_journal_v001/AppUtilites.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:weather_icons/weather_icons.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:weather/weather.dart';

// States of downloading weather data
enum WeatherState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

/* ***************************************************************
  Classes for creating weather forecast of certain place (city)
**************************************************************** */
class WeatherForecast extends StatefulWidget {
  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  late WeatherFactory ws;
  var weather;

  List<Weather> weatherData = [];
  WeatherState state = WeatherState.NOT_DOWNLOADED;

  var cityName;
  var mode;

  double? latitude;
  double? longtitude;
  var textFieldWidth = 320.0;

  var box;
  var boxSize;


  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  // Function for getting 5-day forecast by latitude and longtitude
  void queryForecastByCoordinates() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      state = WeatherState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(latitude, longtitude);

    setState(() {
      weatherData = forecasts;
      state = WeatherState.FINISHED_DOWNLOADING;
    });
  }


  // Function for getting current weather by location
  void queryWeatherByCoordinates() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      state = WeatherState.DOWNLOADING;
    });

    weather = await ws.currentWeatherByLocation(latitude, longtitude);

    setState(() {
      weatherData = [weather];
      state = WeatherState.FINISHED_DOWNLOADING;
    });
  }


  // Function for getting 5-day forecast by latitude and longtitude
  void queryForecastByCityName() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      state = WeatherState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByCityName(cityName);
    setState(() {
      weatherData = forecasts;
      state = WeatherState.FINISHED_DOWNLOADING;
    });
  }


  // Function for getting current weather by location
  void queryWeatherByCityName() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      state = WeatherState.DOWNLOADING;
    });

    weather = await ws.currentWeatherByCityName(cityName);

    setState(() {
      weatherData = [weather];
      state = WeatherState.FINISHED_DOWNLOADING;
    });
  }


  getWeatherDescription(String sky) {
    if (sky.contains('clouds')) return Icon(Icons.wb_cloudy, size: 15);
    else if (sky.contains('snow')) return Icon(Icons.ac_unit, size: 15);
    else if (sky.contains('clear')) return Icon(Icons.wb_sunny, size: 15);
    else if (sky.contains('rain')) return Icon(WeatherIcons.rain, size: 15);
    else return Icon(Icons.wb_sunny);
  }


  // Function for representing weather data if it finished downloading
  Widget contentFinishedDownload() {

    return Center(
      child: ListView.separated(
        itemCount: weatherData.length,
        itemBuilder: (context, index) {

          return ListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${weatherData[index].areaName}, ${weatherData[index].country}\n${weatherData[index].date}\n" +
                    "Температура: ${weatherData[index].temperature.celsius != null? weatherData[index].temperature.celsius.round() : '?'} °С "
                  ),
                  WidgetSpan(child: getWeatherDescription(weatherData[index].weatherDescription)),
                  TextSpan(
                    text: "\nВідчувається: ${weatherData[index].tempFeelsLike.celsius != null? weatherData[index].tempFeelsLike.celsius.round() : '?'} °С\n" + 
                    "\nШвидкість вітру: ${weatherData[index].windSpeed?? '?'} м/с\n" +
                    "Схід: ${weatherData[index].sunrise?? '?'}\nЗахід: ${weatherData[index].sunset?? '?'}" 
                  ),
                ]
              )
            ),
          );
        },

        separatorBuilder: (context, index) {
          return Divider(thickness: weatherData[index].date.day != weatherData[index+1].date.day? 4 : 0.5);
        },

      ),
    );
  }

  // Function for creating widget of downloading
  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          Text('Зачекайте...', style: TextStyle(fontSize: 20)),
        ]
      ),
    );
  }

  // Function for creating widget if no downloading available
  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(''),
        ],
      ),
    );
  }

  // Function for setting state if weather data finished downloading
  Widget resultView() { 
    return state == WeatherState.FINISHED_DOWNLOADING? contentFinishedDownload() : state == WeatherState.DOWNLOADING? contentDownloading() : contentNotDownloaded();
  }


  // Function for saving latitude
  void saveLatitude(String input) {
    latitude = double.tryParse(input);
    mode = 'coords';
  }

  // Function for saving longtitude
  void saveLongtitude(String input) {
    longtitude = double.tryParse(input);
    mode = 'coords';
  }

  // Function for creating widget with text fields for latitude and longtitude
  Widget coordinateTextFields() {

    return Padding(
      padding: EdgeInsets.fromLTRB(17, 20, 17, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Container(
            width: textFieldWidth,

            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.next,
              
              cursorRadius: const Radius.circular(10.0),
              cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

              decoration: InputDecoration(
                labelText: (latitude == null)? 'Широта' : latitude.toString(),
                labelStyle: (longtitude != null)? TextStyle(color: lightingMode == ThemeMode.dark? Colors.white : Colors.black) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 0),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              keyboardType: TextInputType.number,
              onChanged: saveLatitude,
              onSubmitted: saveLatitude,
            )
          ),

          SizedBox(height: 8),

          Container(
            width: textFieldWidth,

            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.next,

              cursorRadius: const Radius.circular(10.0),
              cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,
              
              decoration: InputDecoration(
                labelText: (longtitude == null)? 'Довгота' : longtitude.toString(),
                labelStyle: (longtitude != null)? TextStyle(color: lightingMode == ThemeMode.dark? Colors.white : Colors.black) : TextStyle( fontSize: 12, color: Colors.grey.shade400),
                
                contentPadding: EdgeInsets.fromLTRB(7, 0, 5, 0),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ), 
              
              keyboardType: TextInputType.number,
              onChanged: saveLongtitude,
              onSubmitted: saveLongtitude,
            )
          ),
        ]
      )
    );
  }


    // Function for creating widget with text fields for latitude and longtitude
  Widget cityNameTextField() {

    return Padding(
      padding: EdgeInsets.fromLTRB(17, 6, 15, 17),
      child: Container(
        width: textFieldWidth,

        child: TextFormField(
          autofocus: false,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,

          cursorRadius: const Radius.circular(10.0),
          cursorColor: lightingMode == ThemeMode.dark? Colors.white : Colors.black,

          autocorrect: true,
          enableSuggestions: true,

          decoration: InputDecoration(
            labelText: 'Місто (англ)',
            labelStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
            
            contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 0),
            
            focusedBorder: textFieldStyle,
            enabledBorder: textFieldStyle,
          ),
          
          onChanged: (String value) { 
            cityName = value; 
            mode = 'city';          
          }
          
        )
      ),
    );
  }


  // Function for creating buttons
  Widget createButtons() {
    return Column(
        children: [

          Row(
            children: [
              button(functions: [mode == 'city'? queryWeatherByCityName : queryWeatherByCoordinates], text: 'Погода сьогодні', minWidth: 150.0, edgeInsetsGeometry: EdgeInsets.fromLTRB(17, 0, 0, 0)),
              button(functions: [mode == 'city'? queryForecastByCityName : queryForecastByCoordinates], text: 'Прогноз 5 днів', minWidth: 150.0, edgeInsetsGeometry: EdgeInsets.fromLTRB(25.8, 0, 0, 0)),
            ],
          ),

        ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown, 
        title: Text('Прогноз погоди'),
        actions: [
            
          PopupMenuButton(
            icon: Icon(Icons.info),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Київ'), value: [50.4333, 30.5167]),
              PopupMenuItem(child: Text('Львів'), value: [49.8383, 24.0232]),
              PopupMenuItem(child: Text('Одеса'), value: [46.4775, 30.7326]),
              PopupMenuItem(child: Text('Харків'), value: [49.9808, 36.2527]),
              PopupMenuItem(child: Text('Суми'), value: [50.9077, 34.7981]),
              PopupMenuItem(child: Text('Чернігів'), value: [51.5055, 31.2849]),
              PopupMenuItem(child: Text('Івано-Франківськ'), value: [48.9215, 24.7097]),
              PopupMenuItem(child: Text('Ужгород'), value: [48.6208, 22.28788]),
              PopupMenuItem(child: Text('Вінниця'), value: [49.23308, 28.46822]),
              PopupMenuItem(child: Text('Донецьк'), value: [48.01588, 37.80285]),
              PopupMenuItem(child: Text('Луганськ'), value: [48.5671, 39.3171]),
              PopupMenuItem(child: Text('Сімферополь'), value: [44.9572, 34.1108]),
            ],
            onSelected: (value) {
              latitude = (value as dynamic)[0];
              longtitude = (value as dynamic)[1];
              setState(() { mode = 'coords'; });
            },
          ),            
        ]
      ),

      body: Column(
        children: [
          coordinateTextFields(),
          cityNameTextField(),
          createButtons(),
          SizedBox(height: 15),
          Divider(height: 19.0, thickness: 1.0),
          Expanded(child: resultView())
        ],
      ),

      bottomNavigationBar: Bottom('forecasts'),
    );
  }
}