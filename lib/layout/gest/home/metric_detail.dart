// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gest_app/layout/gest/home/goals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class MetricDetailPage extends StatefulWidget {
  const MetricDetailPage({Key? key}) : super(key: key);

  @override
  State<MetricDetailPage> createState() => _MetricDetailPageState();
}

class _MetricDetailPageState extends State<MetricDetailPage> {
  List<_ChartData> chartData = <_ChartData>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("metrics").get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['x'].millisecondsSinceEpoch),
            y: e.data()['y']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Metric Name")),
        body: FutureBuilder<Object>(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text("H")),
                      ElevatedButton(onPressed: () {}, child: const Text("D")),
                      ElevatedButton(onPressed: () {}, child: const Text("S")),
                      ElevatedButton(onPressed: () {}, child: const Text("M")),
                      ElevatedButton(onPressed: () {}, child: const Text("3M"))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          primaryYAxis: NumericAxis(),
                          series: <ChartSeries<_ChartData, DateTime>>[
                            LineSeries<_ChartData, DateTime>(
                                dataSource: chartData,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y),
                          ])),
                  Container(
                      //! Boton "Ver Metas" si metrica es Actividad
                      child: (true)
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                    return const GoalsPage();
                                  }),
                                );
                              },
                              child: const Text("VER METAS"),
                            )
                          : null),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "DETALLE DE REGISTROS",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: const [
                              Text("07/05/2018 12:35 pm",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16))
                            ],
                          ),
                          Row(
                            children: const [
                              Text("58 kg",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              );
            }));
  }
}

// Class for chart data source, this can be modified based on the data in Firestore
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
