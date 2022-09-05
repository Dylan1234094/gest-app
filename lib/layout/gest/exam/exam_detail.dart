import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/layout/gest/exam/register_exam.dart';
import 'package:gest_app/layout/gest/exam/update_exam.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:intl/intl.dart' as intl;

class ExamDetailPage extends StatefulWidget {
  final String examId;
  final String examName;
  const ExamDetailPage({Key? key, required this.examId, required this.examName}) : super(key: key);

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
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
        .collection("gestantes")
        .doc(uid)
        .collection("resultados_examenes")
        .where("examType", isEqualTo: widget.examName)
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return RegisterExamPage(examId: widget.examId, examName: widget.examName); //! id
            }),
          );
        },
        backgroundColor: Color(0xFF245470),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Detalle de examen")),
      body: FutureBuilder<Object>(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "DETALLE DE EXÁMENES",
                    textAlign: TextAlign.left,
                  ),
                ),
                FutureBuilder<List<Exam>>(
                  future: getListaResultadosExames(uid, widget.examName),
                  builder: (context, snapshotExams) {
                    switch (snapshotExams.connectionState) {
                      case ConnectionState.waiting:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: CircularProgressIndicator()),
                        );
                      case ConnectionState.done:
                        if (snapshotExams.hasData) {
                          if (snapshotExams.data!.isNotEmpty) {
                            return ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshotExams.data!.length,
                              itemBuilder: ((context, index) {
                                Exam exam = snapshotExams.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(builder: (BuildContext context) {
                                          return UpdateExamPage(examId: exam.id!); //! id
                                        }),
                                      );
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(intl.DateFormat('dd/MM/yyyy').format(exam.dateResult!.toDate()),
                                                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16))
                                              ],
                                            ),
                                            Row(
                                              children: [Text("${exam.value!} g/dL", style: TextStyle(fontSize: 24))],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text("No se encontraron exámenes registrados")),
                            );
                          }
                        } else {
                          return const Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Text("Algo salió mal")),
                          );
                        }
                      default:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text("Esperando")),
                        );
                    }
                  },
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

Future<List<Exam>> getListaResultadosExames(String uid, String examType) async {
  ExamService _examService = ExamService();
  return await _examService.getListaResultadosExames(uid, examType);
}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
