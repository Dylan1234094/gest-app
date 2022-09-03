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
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("metrics")
        .orderBy('x', descending: false)
        .get();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Metric Name")),
        body: SingleChildScrollView(
          child: FutureBuilder<Object>(
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
                        ElevatedButton(
                            onPressed: () {}, child: const Text("H")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("D")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("S")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("M")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("3M"))
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
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('metrics')
                            .orderBy('x', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> metricsnapshot) {
                          if (!metricsnapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return _MetricCardList(
                            snapshot: metricsnapshot,
                          );
                        })
                  ]),
                );
              }),
        ));
  }
}

// Class for chart data source, this can be modified based on the data in Firestore
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}

class _MetricCardList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  const _MetricCardList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.only(),
          children: snapshot.data!.docs.map((document) {
            return _MetricCardDetail(document: document);
          }).toList()),
    );
  }
}

class _MetricCardDetail extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> document;

  const _MetricCardDetail({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp time = document['x'] as Timestamp;
    DateTime datetime = time.toDate();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${datetime.day}/${datetime.month}/${datetime.year} ',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16)),
            Text(document['y'].toString() + ' ' + document['unit'],
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
