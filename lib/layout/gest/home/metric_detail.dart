// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/home/goals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

import '../../../utilities/designs.dart';

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

class _MetricDetailPageState extends State<MetricDetailPage>
    with SingleTickerProviderStateMixin {
  List<_ChartData> chartData = <_ChartData>[];
  String bpType = "sistolic"; //only for blood pressure data

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'SEMANA'),
    Tab(text: 'MES'),
    Tab(text: 'BIMESTRE'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.vitalSignName,
              style: kTituloCabezera.copyWith(fontSize: 15)),
          centerTitle: true,
          bottom: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 10),
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MetricDataPage(
              userType: widget.userType,
              vitalSign: widget.vitalSign,
              vitalSignName: widget.vitalSignName,
              rtoken: widget.rtoken,
              unit: widget.unit,
              startDate: intl.DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().add(const Duration(days: -7))),
              endDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            ),
            MetricDataPage(
              userType: widget.userType,
              vitalSign: widget.vitalSign,
              vitalSignName: widget.vitalSignName,
              rtoken: widget.rtoken,
              unit: widget.unit,
              startDate: intl.DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().add(const Duration(days: -30))),
              endDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            ),
            MetricDataPage(
              userType: widget.userType,
              vitalSign: widget.vitalSign,
              vitalSignName: widget.vitalSignName,
              rtoken: widget.rtoken,
              unit: widget.unit,
              startDate: intl.DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().add(const Duration(days: -60))),
              endDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricDataPage extends StatefulWidget {
  const MetricDataPage(
      {Key? key,
      required this.userType,
      required this.vitalSignName,
      required this.vitalSign,
      required this.unit,
      required this.rtoken,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  final String userType;
  final String vitalSignName;
  final String vitalSign;
  final String unit;
  final String rtoken;
  final String startDate;
  final String endDate;

  @override
  State<MetricDataPage> createState() => _MetricDataPageState();
}

class _MetricDataPageState extends State<MetricDataPage> {
  List<_ChartData> chartData = <_ChartData>[];
  String bpType = "sistolic"; //only for blood pressure data

  Future<void> getVitalData() async {
    var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
    Map data = {
      'vitalSign': widget.vitalSign,
      'rtoken': widget.rtoken,
      'startDate': widget.startDate,
      'endDate': widget.endDate
    };
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      var vitalArray = await json.decode(response.body) as List;
      for (var element in vitalArray) {
        print(intl.DateFormat('dd/MM/yyyy HH:mm:ss').format(
            Timestamp.fromMillisecondsSinceEpoch(
                    ((int.parse(element['endNanos']) / 1000000) - 1).round())
                .toDate()));
        print(element['value']);
      }
      List<_ChartData> list = vitalArray
          .map((e) => _ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  ((int.parse(e['endNanos']) / 1000000) - 1).round()),
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
    Map data = {
      'vitalSign': widget.vitalSign,
      'rtoken': widget.rtoken,
      'startDate': widget.startDate,
      'endDate': widget.endDate
    };
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      var bpJson = await json.decode(response.body);

      var sistolicArray = bpJson["sistolic"] as List;
      var diastolicArray = bpJson["diastolic"] as List;

      if (bpType == "sistolic") {
        list = sistolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(
                    ((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      } else {
        list = diastolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(
                    ((int.parse(e['endNanos']) / 1000000) - 1).round()),
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
    Map data = {
      'vitalSign': widget.vitalSign,
      'rtoken': widget.rtoken,
      'startDate': widget.startDate,
      'endDate': widget.endDate
    };
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      var vitalArray = await json.decode(response.body) as List;
      for (var element in vitalArray) {
        print(intl.DateFormat('dd/MM/yyyy HH:mm:ss').format(
            Timestamp.fromMillisecondsSinceEpoch(
                    ((int.parse(element['endNanos']) / 1000000) - 1).round())
                .toDate()));
        print(element['value']);
      }
      list = vitalArray
          .map((e) => _ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  ((int.parse(e['endNanos']) / 1000000) - 1).round()),
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
    Map data = {
      'vitalSign': widget.vitalSign,
      'rtoken': widget.rtoken,
      'startDate': widget.startDate,
      'endDate': widget.endDate
    };
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      var bpJson = await json.decode(response.body);

      var sistolicArray = bpJson["sistolic"] as List;
      var diastolicArray = bpJson["diastolic"] as List;

      if (bpType == "sistolic") {
        list = sistolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(
                    ((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      } else {
        list = diastolicArray
            .map((e) => _ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(
                    ((int.parse(e['endNanos']) / 1000000) - 1).round()),
                y: e['value']))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SfCartesianChart(
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
                  : null,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              //! Boton "Ver Metas" si metrica es Actividad
              child: (widget.vitalSign == "actFisica" &&
                      widget.userType == "gest")
                  ? ElevatedButton(
                      child: const Text('VER METAS DE ACTIVIDAD FÍSICA',
                          style: TextStyle(fontSize: 10.0)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colorPrincipal),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        fixedSize:
                            MaterialStateProperty.all(const Size(350.0, 30.0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return const GoalsPage();
                          }),
                        );
                      },
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Divider(color: colorSecundario),
            ),
            FutureBuilder<List<_ChartData>>(
              future: widget.vitalSign == "presArt"
                  ? getPresArtDataList()
                  : getVitalDataList(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case (ConnectionState.waiting):
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case (ConnectionState.done):
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Algo salió mal..."));
                    }
                    return MetricList(data: snapshot, unit: widget.unit);
                  default:
                    return const Center(child: Text("Algo salió mal..."));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

// Class for chart data source, this can be modified
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}

class MetricList extends StatelessWidget {
  final AsyncSnapshot<List<_ChartData>> data;
  final String unit;

  const MetricList({Key? key, required this.data, required this.unit})
      : super(key: key);

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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: data.data!.map((document) {
              return MetricDetail(
                document: document,
                unit: unit,
              );
            }).toList()),
      );
    }
  }
}

class MetricDetail extends StatelessWidget {
  final _ChartData document;
  final String unit;

  const MetricDetail({Key? key, required this.document, required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime datetime = document.x!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(DateFormat('EEEE, d MMMM').format(datetime), style: kFechaDato),
          Text(
            NumberFormat('#,###.##').format(document.y).toString() + " " + unit,
            textAlign: TextAlign.left,
            style: kDato,
          ),
        ],
      ),
    );
  }
}
