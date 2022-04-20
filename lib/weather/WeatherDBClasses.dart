import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


/* ***************************************************************
  Hive class for saving weather forecasts
**************************************************************** */
@HiveType(typeId: 2)
class WeatherDescription {
  @HiveField(0)
  var weatherData;
  
  WeatherDescription(this.weatherData);

  @override
  String toString() {
    return '${this.weatherData[0]}\n\n${this.weatherData[1]}';
  }
}


/* ***************************************************************
  Class for creating page of soil sample with description
**************************************************************** */
class WeatherDescriptionPage extends StatelessWidget{
  var weatherData;
  
  WeatherDescriptionPage(this.weatherData);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('weather'),
        automaticallyImplyLeading: false
      ),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text('${weatherData.toString()}'),
      )
    );
  }
}


class WeatherDescriptionAdapter extends TypeAdapter<WeatherDescription>{
  @override
  final typeId = 2;

  @override
  WeatherDescription read(BinaryReader reader) {
    final weatherData = reader.readStringList();
    return WeatherDescription(weatherData);
  }

  @override
  void write(BinaryWriter writer, WeatherDescription obj) {
    writer.writeStringList(obj.weatherData);
  }
}