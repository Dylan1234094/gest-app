// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gest_app/layout/gest/home/goals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class MetricDetailPage extends StatefulWidget {
  const MetricDetailPage(
      {Key? key,
      required this.userType,
      required this.vitalSignName,
      required this.vitalSign,
      required this.unit,
      required this.rtoken})
      : super(key: key);
  final String userType;
  final String vitalSignName;
  final String vitalSign;
  final String unit;
  final String rtoken;

  @override
  State<MetricDetailPage> createState() => _MetricDetailPageState();
}

class _MetricDetailPageState extends State<MetricDetailPage> {
  List<_ChartData> chartData = <_ChartData>[];
  String bpType = "sistolic"; //only for blood pressure data

  String startDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -7)));
  String endDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    if (widget.vitalSign == "presArt") {
      getPresArtData().then((results) {});
    } else {
      getVitalData().then((results) {});
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getVitalData() async {
    var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
    Map data = {'vitalSign': widget.vitalSign, 'rtoken': widget.rtoken, 'startDate': startDate, 'endDate': endDate};
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      var vitalArray = await json.decode(response.body) as List;
      for (var element in vitalArray) {
        print(intl.DateFormat('dd/MM/yyyy HH:mm:ss').format(
            Timestamp.fromMillisecondsSinceEpoch(((int.parse(element['endNanos']) / 1000000) - 1).round()).toDate()));
        print(element['value']);
      }
      List<_ChartData> list = vitalArray
          .map((e) => _ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
              y: e['value']))
          .toList();
      setState(() {
        chartData = list;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPresArtData() async {
    List<_ChartData> list;
    var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
    Map data = {'vitalSign': widget.vitalSign, 'rtoken': widget.rtoken, 'startDate': startDate, 'endDate': endDate};
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      var bpJson = await json.decode(response.body);

      var sistolicArray = bpJson["sistolic"] as List;
      var diastolicArray = bpJson["diastolic"] as List;

      if (bpType == "sistolic") {
        list = sistolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      } else {
        list = diastolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      }
      setState(() {
        chartData = list;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<_ChartData>> getVitalDataList() async {
    List<_ChartData> list = [];
    var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
    Map data = {'vitalSign': widget.vitalSign, 'rtoken': widget.rtoken, 'startDate': startDate, 'endDate': endDate};
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      var vitalArray = await json.decode(response.body) as List;
      for (var element in vitalArray) {
        print(intl.DateFormat('dd/MM/yyyy HH:mm:ss').format(
            Timestamp.fromMillisecondsSinceEpoch(((int.parse(element['endNanos']) / 1000000) - 1).round()).toDate()));
        print(element['value']);
      }
      list = vitalArray
          .map((e) => _ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
              y: e['value']))
          .toList();
    } catch (e) {
      print(e);
    }
    return list;
  }

  Future<List<_ChartData>> getPresArtDataList() async {
    List<_ChartData> list = [];
    var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
    Map data = {'vitalSign': widget.vitalSign, 'rtoken': widget.rtoken, 'startDate': startDate, 'endDate': endDate};
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      var bpJson = await json.decode(response.body);

      var sistolicArray = bpJson["sistolic"] as List;
      var diastolicArray = bpJson["diastolic"] as List;

      if (bpType == "sistolic") {
        list = sistolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      } else {
        list = diastolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return list;
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
            title: Text(widget.vitalSignName)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        startDate = "2022-09-12";
                        getVitalData().then((results) {
                          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {});
                          });
                        });
                      },
                      child: const Text("H")),
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
                      yValueMapper: (_ChartData data, _) => data.y,
                    ),
                  ],
                ),
              ),
              Container(
                  //! Boton "Sistolica y Diastolica" si metrica es Presión Arterial
                  child: (widget.vitalSign == "presArt")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  bpType = "sistolic";
                                  getPresArtData().then((results) {
                                    setState(() {});
                                  });
                                },
                                child: const Text("Presión sistólica")),
                            ElevatedButton(
                                onPressed: () {
                                  bpType = "diastolic";
                                  getPresArtData().then((results) {
                                    setState(() {});
                                  });
                                },
                                child: const Text("Presión diastólica"))
                          ],
                        )
                      : null),
              Container(
                  //! Boton "Ver Metas" si metrica es Actividad
                  child: (widget.vitalSign == "actFisica" && widget.userType == "gest")
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (BuildContext context) {
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
              FutureBuilder<List<_ChartData>>(
                  future: widget.vitalSign == "presArt" ? getPresArtDataList() : getVitalDataList(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.waiting):
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case (ConnectionState.done):
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Algo salió mal..."),
                          );
                        }
                        return _MetricCardList(data: snapshot, unit: widget.unit);
                      default:
                        return const Text("Algo salió mal");
                    }
                  })
            ]),
          ),
        ));
  }
}

// Class for chart data source, this can be modified
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final double? y;
}

class _MetricCardList extends StatelessWidget {
  final AsyncSnapshot<List<_ChartData>> data;
  final String unit;

  const _MetricCardList({Key? key, required this.data, required this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.data!.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text("No se encontró ningún registro"),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.only(),
            children: data.data!.map((document) {
              return _MetricCardDetail(
                document: document,
                unit: unit,
              );
            }).toList()),
      );
    }
  }
}

class _MetricCardDetail extends StatelessWidget {
  final _ChartData document;
  final String unit;

  const _MetricCardDetail({Key? key, required this.document, required this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime datetime = document.x!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${datetime.day}/${datetime.month}/${datetime.year} ',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16)),
            Text(document.y.toString() + " " + unit,
                textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

void getRefreshToken() async {
  var url = 'https://upc-cloud-test.azurewebsites.net/api/test/first';
  Map data = {'name': "Prueba123"};
  var body = json.encode(data);
  try {
    var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
    print(response.body);
  } catch (e) {
    print(e);
  }
}
