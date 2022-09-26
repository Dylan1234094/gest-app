// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:gest_app/shared/textfield_date.dart';

import 'package:intl/intl.dart' as intl;

class UpdateExamPage extends StatefulWidget {
  final String examId;
  const UpdateExamPage({Key? key, required this.examId}) : super(key: key);

  @override
  State<UpdateExamPage> createState() => _UpdateExamPageState();
}

class _UpdateExamPageState extends State<UpdateExamPage> {
  final dateController = TextEditingController();
  final valueController = TextEditingController();
  var uid = FirebaseAuth.instance.currentUser!.uid;

  void ConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Desea actualizar los datos?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  //! Update examen
                  updateExamResult(uid, widget.examId, valueController.text, dateController.text, context)
                      .then((value) {
                    Navigator.of(context).pop();
                    _updateExamSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _updateExamFailed(context);
                  });
                },
                child: const Text('Si'))
          ],
        );
      },
    );
  }

  void ConfirmDialogDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Desea elimar el registro?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  //! Delete examen
                  deleteExamResult(uid, widget.examId, context).then((value) {
                    Navigator.of(context).pop();
                    _deleteExamSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _deleteExamFailed(context);
                  });
                },
                child: const Text('Si'))
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext ctx) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.delete),
                                title: const Text("Borrar"),
                                onTap: () {
                                  ConfirmDialogDelete(context);
                                }),
                            ListTile(
                                leading: Icon(Icons.close),
                                title: const Text("Cancelar"),
                                onTap: () => Navigator.of(context).pop()),
                          ],
                        );
                      });
                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Actualizar Examen")),
        body: FutureBuilder<Exam>(
            future: getExamResult(widget.examId, uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case (ConnectionState.done):
                  if (snapshot.hasData) {
                    valueController.text = snapshot.data!.value!.toString();
                    dateController.text = intl.DateFormat('dd/MM/yyyy').format(snapshot.data!.dateResult!.toDate());
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 20),
                              child: Text("Actualizar examen",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            Text("Edite el resultado a continuación", textAlign: TextAlign.justify),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Resultado (g/dL)',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextFormDate(
                                label: "Fecha de entrega de resultados",
                                dateController: dateController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: ElevatedButton(
                                onPressed: () {
                                  ConfirmDialog(context);
                                },
                                child: Text("GUARDAR"),
                                style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(100, 40))),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
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
            }),
      ),
    );
  }
}

Future<void> updateExamResult(String gestID, String examID, String value, String date, BuildContext context) {
  ExamService _examService = ExamService();
  return _examService.updateExamResult(gestID, examID, value, date, context);
}

Future<void> deleteExamResult(String gestID, String examID, BuildContext context) {
  ExamService _examService = ExamService();
  return _examService.deleteExamResult(gestID, examID, context);
}

Future<Exam> getExamResult(String examID, String gestID) {
  ExamService _examService = ExamService();
  return _examService.getExamResult(examID, gestID);
}

Future<void> _updateExamSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Examen Actualizado',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su examen fue actualizado correctamente',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ],
      );
    },
  );
}

Future<void> _updateExamFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su examen no fue actualizado. Por favor, inténtelo más tarde',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

Future<void> _deleteExamSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Examen Eliminado',
          style: TextStyle(fontSize: 13),
        ),
        content: Text("Su examen fue eliminado correctamente"),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ],
      );
    },
  );
}

Future<void> _deleteExamFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su examen no fue eliminado. Por favor, inténtelo más tarde',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
