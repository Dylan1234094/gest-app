import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/layout/gest/exam/exam_detail.dart';
import 'package:gest_app/layout/monitoring/monitor_exams/monitor_exams.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;

class DetailMonitorGest extends StatefulWidget {
  final String gestId;
  const DetailMonitorGest({Key? key, required this.gestId}) : super(key: key);

  @override
  State<DetailMonitorGest> createState() => _DetailMonitorGestState();
}

class _DetailMonitorGestState extends State<DetailMonitorGest> {
  List<_ChartData> chartData = <_ChartData>[];
  late TabController tabController;

  @override
  void initState() {
    getColesterolDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getColesterolDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("gestantes")
        .doc(widget.gestId)
        .collection("resultados_examenes")
        .where("examType", isEqualTo: "Colesterol")
        .where("registerStatus", whereIn: [1, 2])
        .orderBy('dateResult', descending: false)
        .get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(e.data()['dateResult'].millisecondsSinceEpoch),
            y: e.data()['value']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Gestante>(
          future: getGestante(widget.gestId),
          builder: (context, snapshotGest) {
            switch (snapshotGest.connectionState) {
              case ConnectionState.waiting:
                return const Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12), child: CircularProgressIndicator()),
                );
              case ConnectionState.done:
                if (snapshotGest.hasData) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height / 11,
                          backgroundImage: snapshotGest.data!.photoUrl! != ""
                              ? NetworkImage(snapshotGest.data!.photoUrl!)
                              : Image.asset("assets/default_profile_icon.png").image,
                          backgroundColor: Color(0xFF245470),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Nombre Completo', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16)),
                            Text('${snapshotGest.data!.nombre!} ${snapshotGest.data!.apellido!}',
                                textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Divider(
                                height: 5,
                                thickness: 1.5,
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                            ),
                            Text('Fecha nacimiento', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16)),
                            Text('${snapshotGest.data!.fechaNacimiento!}',
                                textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Divider(
                                height: 5,
                                thickness: 1.5,
                                color: Color.fromARGB(255, 221, 221, 221),
                              ),
                            ),
                            Text('Edad gestacional', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16)),
                            Text(
                                '${DateTime.now().difference(intl.DateFormat("dd/MM/yyyy hh:mm:ss").parse(snapshotGest.data!.fechaRegla! + " 00:00:00")).inDays} días de embarazo',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('GRÁFICOS EVOLUTIVOS', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        width: 360,
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            elevation: 10,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: const <Widget>[
                                      Text(
                                        'Colesterol',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 200,
                                    width: 300,
                                    child: SfCartesianChart(
                                        primaryXAxis: DateTimeAxis(),
                                        primaryYAxis: NumericAxis(),
                                        series: <ChartSeries<_ChartData, DateTime>>[
                                          LineSeries<_ChartData, DateTime>(
                                              dataSource: chartData,
                                              xValueMapper: (_ChartData data, _) => data.x,
                                              yValueMapper: (_ChartData data, _) => data.y),
                                        ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  //GET ERROR BODY
                  return const Text("ERROR BODY");
                }
              default:
                return Text("data");
            }
          },
        ),
      ),
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
