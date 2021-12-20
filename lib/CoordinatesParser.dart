import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/Bottom.dart';
import 'package:http/http.dart' as http;


/* *************************************************************************
 Class for creating album if loading data from https was successful
************************************************************************* */
Future<Album> fetchAlbum(http.Client client) async {
  final response = await http
      .get(Uri.parse('https://raw.githubusercontent.com/mezgoodle/weather-bot/master/test/data.json'));

  if (response.statusCode == 200) {
    return Album().fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


/* *************************************************************************
 Classes of album where JSON data is extracted
************************************************************************* */
class Album {
  late final List<String> currentWeather;
  Map<String, String> coordsList = {};

  Album();
  Album.parsed({required this.currentWeather, required this.coordsList});

  // Function for extracting data from JSON
  fromJson(Map<String, dynamic> json) {
    this.currentWeather = json['current_weather'];
    
    for (var element in currentWeather) {
      var coordinates = element[2];
      coordsList['${element[0]}, ${element[1]}'] = '${coordinates[0]}, ${coordinates[1]}';
    }

    return Album.parsed(
      currentWeather: this.currentWeather,
      coordsList: this.coordsList,
    );
  }
}


/* *************************************************************************
 Classes for page with latitude and longtitude of some cities
************************************************************************* */
class CoordinatesParser extends StatefulWidget {
  const CoordinatesParser({Key? key}) : super(key: key);

  @override
  CoordinatesParserState createState() => CoordinatesParserState();
}


class CoordinatesParserState extends State<CoordinatesParser> {
  late final Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text('Отримати координати')),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return printData(snapshot.data!.coordsList);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),

      bottomNavigationBar: Bottom(),
    );
  }

  // Function for representing city with coordinates
  Widget printData(sd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var element in sd.entries)
          Text("${element.key}: ${element.value}"),
      ]
    );
  }
}