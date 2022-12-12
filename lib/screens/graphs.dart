import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';


class Graphs extends StatefulWidget {

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  num moisture = 0;
  num temperature = 0;
  num co2 = 0;
  num drops = 0;
  late List<LiveData> co2ChartData;
  late List<LiveData> moistureChartData;
  late List<LiveData> temperatureChartData;
  late List<LiveData> dropsChartData;
  late ChartSeriesController _co2ChartSeriesController;
  late ChartSeriesController _moistureChartSeriesController;
  late ChartSeriesController _temperatureChartSeriesController;
  late ChartSeriesController _dropsChartSeriesController;
  late var timer;
  final databaseRef = FirebaseDatabase.instance.ref('test/');
  @override
  void initState() {
    co2ChartData = getChartData();
    moistureChartData = getChartData();
    temperatureChartData = getChartData();
    dropsChartData = getChartData();
    if (mounted) {
      timer = Timer.periodic( Duration(seconds: 1), allGraphs);
    }
    super.initState();
    databaseRef.onValue.listen((event) {
      if(event.snapshot.exists){
        Map<String, dynamic> _post = Map<String, dynamic>.from(event.snapshot.value as Map);
        co2 = _post['co2'];
        moisture = _post["moisure"];
        temperature = _post["temp"];
        drops = _post["rain"];
      }
    });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => {Navigator.pushReplacementNamed(context, 'Home')},
                ),
                ListTile(
                  leading: Icon(Icons.show_chart),
                  title: Text('Graphs'),
                  onTap: () => {Navigator.pushReplacementNamed(context, 'Graphs')},
                )
              ],
            ),
          ),
          backgroundColor: const Color(0xffF7F8FA),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            centerTitle: true,
            title: Text("Sandy"),
            backgroundColor: Colors.green.withOpacity(0.8),
            elevation: 0,
          ),
          body: Column(
    children: <Widget>[
    Expanded(
    child: Container(
    color: Colors.green.withOpacity(0.8),
    child: Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
    ),
    ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                    Container(
                      margin: const EdgeInsets.all(4),
                      height: 280,
                      child: SfCartesianChart(
                          series: <LineSeries<LiveData, int>>[
                            LineSeries<LiveData, int>(
                              onRendererCreated: (ChartSeriesController controller) {
                                _co2ChartSeriesController = controller;
                              },
                              dataSource: co2ChartData,
                              color: Colors.blue,
                              xValueMapper: (LiveData list, _) => list.time,
                              yValueMapper: (LiveData list, _) => list.value,
                            )
                          ],
                          primaryXAxis: NumericAxis(
                              interval: 1,
                              title: AxisTitle(text: 'Time (seconds)')),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Co2 (%)'))),
                    ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, int>>[
                          LineSeries<LiveData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _moistureChartSeriesController = controller;
                            },
                            dataSource: moistureChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData list, _) => list.time,
                            yValueMapper: (LiveData list, _) => list.value,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Moisture (%)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, int>>[
                          LineSeries<LiveData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _temperatureChartSeriesController = controller;
                            },
                            dataSource: temperatureChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData list, _) => list.time,
                            yValueMapper: (LiveData list, _) => list.value,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Temperature (°C)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, int>>[
                          LineSeries<LiveData, int>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _dropsChartSeriesController = controller;
                            },
                            dataSource: dropsChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData list, _) => list.time,
                            yValueMapper: (LiveData list, _) => list.value,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Rain drops (%)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),)))]
          ),
        ));
  }



  int time = 0;
  void updateCo2DataSource() {
    if(time > 10){
      co2ChartData.removeAt(0);
    }
    co2ChartData.add(LiveData(++time, co2));
    _co2ChartSeriesController.updateDataSource(
        addedDataIndex: co2ChartData.length - 1);
    setState(() {});
  }

  void updateMoistureDataSource() {
    if(time > 10){
      moistureChartData.removeAt(0);
    }
    moistureChartData.add(LiveData(time, moisture));
    _moistureChartSeriesController.updateDataSource(
        addedDataIndex: moistureChartData.length - 1);
    setState(() {});
  }

  void updateTemperatureDataSource() {
    if(time > 10){
      temperatureChartData.removeAt(0);
    }
    temperatureChartData.add(LiveData(time, temperature));
    _temperatureChartSeriesController.updateDataSource(
        addedDataIndex: temperatureChartData.length - 1);
    setState(() {});
  }
  void updateDropsDataSource() {
    if(time > 10){
      dropsChartData.removeAt(0);
    }
    dropsChartData.add(LiveData(time, drops));
    _dropsChartSeriesController.updateDataSource(
        addedDataIndex: dropsChartData.length - 1);
    setState(() {});
  }

  void allGraphs(Timer timer){
    updateCo2DataSource();
    updateDropsDataSource();
    updateMoistureDataSource();
    updateTemperatureDataSource();
  }
  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
    ];
  }
}



class LiveData {
  LiveData(this.time, this.value);
  final int time;
  final num value;
}