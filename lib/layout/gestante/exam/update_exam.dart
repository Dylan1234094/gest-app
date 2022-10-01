// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/exam_result.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:gest_app/utilities/textfield_date.dart';

import 'package:intl/intl.dart' as intl;

import '../../../utilities/designs.dart';

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

  void confirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
          actionsPadding: EdgeInsets.only(bottom: 10),
          title: const Text('Confirmación', style: TextStyle(fontSize: 13)),
          content: const Text('¿Desea actualizar los datos?',
              style: kInfoPopUp, textAlign: TextAlign.justify),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCELAR',
                    style: TextStyle(fontSize: 10, color: colorSecundario))),
            TextButton(
                onPressed: () {
                  //! Update examen
                  updateExamResult(uid, widget.examId, valueController.text,
                          dateController.text, context)
                      .then((value) {
                    Navigator.of(context).pop();
                    _updateExamSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _updateExamFailed(context);
                  });
                },
                child: const Text('ACEPTAR', style: TextStyle(fontSize: 10)))
          ],
        );
      },
    );
  }

  void confirmDialogDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
          actionsPadding: EdgeInsets.only(bottom: 10),
          title: const Text('Confirmación', style: TextStyle(fontSize: 13)),
          content: const Text('¿Desea elimar el registro?',
              style: kInfoPopUp, textAlign: TextAlign.justify),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCELAR',
                    style: TextStyle(fontSize: 10, color: colorSecundario))),
            TextButton(
                onPressed: () {
                  deleteExamResult(uid, widget.examId, context).then((value) {
                    Navigator.of(context).pop();
                    _deleteExamSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _deleteExamFailed(context);
                  });
                },
                child: const Text('ACEPTAR', style: TextStyle(fontSize: 10)))
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
                              confirmDialogDelete(context);
                            }),
                        ListTile(
                            leading: Icon(Icons.close),
                            title: const Text("Cancelar"),
                            onTap: () => Navigator.of(context).pop()),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder<Exam>(
            future: getExamResult(widget.examId, uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case (ConnectionState.done):
                  if (snapshot.hasData) {
                    valueController.text = snapshot.data!.value!.toString();
                    dateController.text = intl.DateFormat('dd/MM/yyyy')
                        .format(snapshot.data!.dateResult!.toDate());
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text('Actualizar Examen',
                                  textAlign: TextAlign.center, style: kTitulo1),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'Edite el resultado a continuación',
                                textAlign: TextAlign.justify,
                                style: kDescripcion,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: TextStyle(fontSize: 13.0),
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Resultado (g/dL)',
                                  hintStyle: kSubTitulo1,
                                  labelStyle: kSubTitulo1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextFormDate(
                                label: "Fecha de resultado",
                                dateController: dateController,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            colorPrincipal),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(160.0, 46.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    confirmDialog(context);
                                  },
                                  child: Text("GUARDAR"),
                                ),
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

Future<void> updateExamResult(String gestID, String examID, String value,
    String date, BuildContext context) {
  ExamService _examService = ExamService();
  return _examService.updateExamResult(gestID, examID, value, date, context);
}

Future<void> deleteExamResult(
    String gestID, String examID, BuildContext context) {
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
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Examen actualizado',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          'Su examen fue actualizado correctamente',
          style: kInfoPopUp,
          textAlign: TextAlign.justify,
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
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          'Su examen no fue actualizado. Por favor, inténtelo más tarde',
          style: kInfoPopUp,
          textAlign: TextAlign.justify,
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
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Examen Eliminado',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          "Su examen fue eliminado correctamente",
          style: kInfoPopUp,
          textAlign: TextAlign.justify,
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

Future<void> _deleteExamFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          'Su examen no fue eliminado. Por favor, inténtelo más tarde',
          style: kInfoPopUp,
          textAlign: TextAlign.justify,
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
