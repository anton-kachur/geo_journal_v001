import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_journal_v001/app_components/Bottom.dart';
import 'package:geo_journal_v001/app_components/appUtilites.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


/* *************************************************************************
 Classes for page of graphic, made from soundings' data
************************************************************************* */
class SoundingsPage extends StatefulWidget {
  final projectNumber;
  
  SoundingsPage(this.projectNumber);

  @override
  SoundingsPageState createState() => SoundingsPageState();
}


class SoundingsPageState extends State<SoundingsPage> {
  var box;
  var boxSize;
  var boxData;
  var zoomPanBehavior;
  

  // Function for getting data from Hive database
  Future getDataFromBox() async {
    box = await Hive.openBox('accounts_data');

    try {
      for (var key in box.keys) {
        if (box.get(key).login == (await currentAccount).login) {
          boxSize = box.length;
      
          return Future.value(box.get(key));  
        
        }
      }  
    } catch (e) {}   
  }  

  
  // Fucntion for getting chart data from box
  List<ChartData> getDataFromFuture(var snapshotData) {
    final List<ChartData> chartData = [];

    if (currentAccount != null) 
        for (var element in snapshotData.projects)
          if (element.number == widget.projectNumber)
            for (var sounding in element.soundings)
             chartData.add(ChartData(sounding.depth, qc: sounding.qc, fs: sounding.fs));

    chartData.sort((a, b) => a.depth.compareTo(b.depth)); // sort chart data

    return chartData;    
  }



  @override
  void initState() {
    zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    boxData = getDataFromBox();


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
                title: Text('Графік'),
                automaticallyImplyLeading: false
              ),

              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),

                      // Create chart for qc, fs and height
                      child: SfCartesianChart(
                        
                        zoomPanBehavior: zoomPanBehavior,
                        primaryXAxis: NumericAxis(title: AxisTitle(text: 'Глибина (м)'), isVisible: true),
                        legend: Legend(position: LegendPosition.bottom, isVisible: true, title: LegendTitle(text: '')),
                        
                        series: <CartesianSeries>[

                          // Series for qc and height
                          LineSeries<ChartData, double>(
                            legendItemText: 'qc(МПа)',
                            dataSource: getDataFromFuture(snapshot.data),
                            xValueMapper: (ChartData coefficients, _) => coefficients.depth,
                            yValueMapper: (ChartData coefficients, _) => coefficients.qc,
                          ),

                          // Series for fs and height
                          LineSeries<ChartData, double>(
                            legendItemText: 'fs(кПа)',
                            dataSource: getDataFromFuture(snapshot.data),
                            xValueMapper: (ChartData coefficients, _) => coefficients.depth,
                            yValueMapper: (ChartData coefficients, _) => coefficients.fs,
                          )

                        ]
                      )
                    )
                  )

                ),
              ),

              bottomNavigationBar: Bottom(),
            );
        }
      }
    );

  }
}


/* *************************************************************************
 Class for storing sounding data for chart
************************************************************************* */
class ChartData {
  final double depth;
  var qc;
  var fs;
  
  ChartData(this.depth, {this.qc, this.fs});

  @override
  String toString() {
    return 'Depth: $depth, qc: $qc, fs: $fs\n';
  }
}