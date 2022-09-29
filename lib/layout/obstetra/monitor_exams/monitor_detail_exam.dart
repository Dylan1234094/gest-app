import 'package:flutter/material.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../utilities/designs.dart';

class MonitorExamDetailPage extends StatefulWidget {
  final String examId;
  final String examName;
  final String gestId;

  const MonitorExamDetailPage(
      {required this.examId, required this.examName, required this.gestId});

  @override
  State<MonitorExamDetailPage> createState() => _MonitorExamDetailPageState();
}

class _MonitorExamDetailPageState extends State<MonitorExamDetailPage> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Resultados de exámenes de ${widget.examName}',
                          style: kTitulo1,
                        ),
                      ),
                      FutureBuilder<List<Exam>>(
                        future: getListaResultadosExames(
                            widget.gestId, widget.examName),
                        builder: (context, snapshotExams) {
                          switch (snapshotExams.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
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
                                      return GestureDetector(
                                        child: DatoExamen(exam: exam),
                                      );
                                    }),
                                  );
                                } else {
                                  return const Center(
                                    child: Text(
                                      "No se encontraron exámenes registrados",
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: Text("Algo salió mal..."),
                                );
                              }
                            default:
                              return const Center(
                                child: Text("Algo salió mal..."),
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

class DatoExamen extends StatelessWidget {
  const DatoExamen({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DateFormat.yMMMMEEEEd('es_MX').format(exam.dateResult!.toDate()),
            style: kSubTitulo1.copyWith(color: colorSecundario),
          ),
          Text(
            NumberFormat('#,###.##').format(exam.value!).toString() + " g/dL",
            style: kTitulo2,
          ),
        ],
      ),
    );
  }
}

Future<List<Exam>> getListaResultadosExames(String uid, String examType) async {
  ExamService _examService = ExamService();
  return await _examService.getListaResultadosExames(uid, examType);
}
