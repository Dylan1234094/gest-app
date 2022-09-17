import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/layout/gest/exam/register_exam.dart';
import 'package:gest_app/layout/gest/exam/update_exam.dart';
import 'package:gest_app/service/exam_result_service.dart';

import 'package:intl/intl.dart' as intl;

class MonitorExamDetailPage extends StatefulWidget {
  final String examId;
  final String examName;
  final String gestId;

  const MonitorExamDetailPage({Key? key, required this.examId, required this.examName, required this.gestId})
      : super(key: key);

  @override
  State<MonitorExamDetailPage> createState() => _MonitorExamDetailPageState();
}

class _MonitorExamDetailPageState extends State<MonitorExamDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Exámenes de ${widget.examName}")),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: FutureBuilder<Object>(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "DETALLE DE EXÁMENES",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  FutureBuilder<List<Exam>>(
                    future: getListaResultadosExames(widget.gestId, widget.examName),
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
      ),
    );
  }
}

Future<List<Exam>> getListaResultadosExames(String uid, String examType) async {
  ExamService _examService = ExamService();
  return await _examService.getListaResultadosExames(uid, examType);
}
