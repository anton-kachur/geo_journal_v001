import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';

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
  List<Weather> weatherData = [];
  WeatherState state = WeatherState.NOT_DOWNLOADED;
  double? latitude;
  double? longtitude;
  static const buttonWidth = 155.0;
  var textFieldWidth = 155.0;
  var textFieldHeight = 40.0;


  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  // Function for getting 5-day forecast by latitude and longtitude
  void queryForecast() async {
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
  void queryWeather() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      state = WeatherState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(latitude, longtitude);
    setState(() {
      weatherData = [weather];
      state = WeatherState.FINISHED_DOWNLOADING;
    });
  }

  // Function for representing weather data if it finished downloading
  Widget contentFinishedDownload() {
    return Center(
      child: ListView.separated(
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(weatherData[index].toString()),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
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
          Text(
            'Дані завантажуються...',
            style: TextStyle(fontSize: 20),
          ),

          Container(
              margin: EdgeInsets.only(top: 50),
              child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
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
          Text(
            '...',
          ),
        ],
      ),
    );
  }

  // Function for setting state if weather data finished downloading
  Widget resultView() => state == WeatherState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : state == WeatherState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();


  // Function for saving latitude
  void saveLatitude(String input) {
    latitude = double.tryParse(input);
    print(latitude);
  }

  // Function for saving longtitude
  void saveLongtitude(String input) {
    longtitude = double.tryParse(input);
    print(longtitude);
  }

  // Function for creating widget with text fields for latitude and longtitude
  Widget coordinateInputs() {
    var textFieldStyle = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(17, 20, 17, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: textFieldWidth,
            height: textFieldHeight,
            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.next,

              decoration: InputDecoration(
                hintText: 'Широта',
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.fromLTRB(7, 5, 5, 0),
                
                focusedBorder: textFieldStyle,
                enabledBorder: textFieldStyle,
              ),
              
              keyboardType: TextInputType.number,
              onChanged: saveLatitude,
              onSubmitted: saveLatitude,
            )
          ),

          Container(
            width: textFieldWidth,
            height: textFieldHeight,
            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.next,
              
              decoration: InputDecoration(
                hintText: 'Довгота',
                hintStyle: TextStyle( fontSize: 12, color: Colors.grey.shade400),
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

  // Function for creating buttons
  Widget createButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buttonConstructor('Погода сьогодні', queryWeather),
        buttonConstructor('Прогноз погоди', queryForecast),
      ],
    );
  }

  // Function for creating button widget
  Widget buttonConstructor(text, action) {
    return FlatButton(
      minWidth: buttonWidth,
      child: Text(text, style: TextStyle(color: Colors.black87)),
      onPressed: action,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black87,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown, 
        title: Text('Прогноз погоди'),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.map),
            onPressed: (){ Navigator.pushNamed(context, '/coordinates_parser_page'); },
          ),
            
          PopupMenuButton(
            icon: Icon(Icons.info),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Київ (50.4536, 30.5164)'), value: [50.4536, 30.5164]),
              PopupMenuItem(child: Text('Львів (49.8383, 24.0232)'), value: [49.8383, 24.0232]),
              PopupMenuItem(child: Text('Одеса (46.4775, 30.7326)'), value: [46.4775, 30.7326]),
              PopupMenuItem(child: Text('Харків (49.9808, 36.2527)'), value: [49.9808, 36.2527]),
            ],
            onSelected: (value) {
              this.latitude = (value as dynamic)[0];
              this.longtitude = (value as dynamic)[1];
            },
          ),            
        ]
      ),

      body: Column(
        children: [
          coordinateInputs(),
          createButtons(),
          SizedBox(height: 15),
          Text('Результати:', style: TextStyle(fontSize: 20)),
          Divider(height: 20.0, thickness: 2.0),
          Expanded(child: resultView())
        ],
      ),

      bottomNavigationBar: Bottom(),
    );
  }
}