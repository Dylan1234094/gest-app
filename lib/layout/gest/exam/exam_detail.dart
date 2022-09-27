import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/layout/gest/exam/register_exam.dart';
import 'package:gest_app/layout/gest/exam/update_exam.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:intl/intl.dart';

import '../../../utilities/designs.dart';

class ExamDetailPage extends StatefulWidget {
  final String examId;
  final String examName;
  const ExamDetailPage({Key? key, required this.examId, required this.examName})
      : super(key: key);

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return RegisterExamPage(
                    examId: widget.examId, examName: widget.examName); //! id
              },
            ),
          );
        },
        backgroundColor: colorPrincipal,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Object>(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Resultados de exámenes de ${widget.examName}',
                      style: kTitulo,
                    ),
                  ),
                  FutureBuilder<List<Exam>>(
                    future: getListaResultadosExames(uid, widget.examName),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    Exam exam = snapshot.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) {
                                            return UpdateExamPage(
                                                examId: exam.id!); //! id
                                          }),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                                DateFormat.yMMMMEEEEd('es_MX')
                                                    .format(exam.dateResult!
                                                        .toDate()),
                                                style: kFechaDato),
                                            Text(
                                              NumberFormat('#,###.##')
                                                      .format(exam.value!)
                                                      .toString() +
                                                  " g/dL",
                                              textAlign: TextAlign.left,
                                              style: kDato,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            } else {
                              return const Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "No se encontraron exámenes registrados"),
                              );
                            }
                          } else {
                            return const Center(
                                child: Text("Algo salió mal..."));
                          }
                        default:
                          return const Center(child: Text("Algo salió mal..."));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExamDetail extends StatelessWidget {
  const ExamDetail({
    Key? key,
    required this.exam,
  }) : super(key: key);

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(DateFormat('EEEE, d MMMM').format(exam.dateResult!.toDate()),
              style: kFechaDato),
          Text(
            NumberFormat('#,###.##').format(exam.value!).toString() + " g/dL",
            textAlign: TextAlign.left,
            style: kDato,
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
