// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:gest_app/shared/textfield_date.dart';

import '../../../utilities/designs.dart';

class RegisterExamPage extends StatefulWidget {
  final String examId;
  final String examName;
  const RegisterExamPage({Key? key, required this.examId, required this.examName}) : super(key: key);

  @override
  State<RegisterExamPage> createState() => _RegisterExamPageState();
}

class _RegisterExamPageState extends State<RegisterExamPage> {
  final _keyForm = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final valueController = TextEditingController();

  void ConfirmDialog(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
          actionsPadding: EdgeInsets.only(bottom: 10),
          title: const Text('Confirmación', style: TextStyle(fontSize: 13)),
          content: const Text('¿Desea enviar los datos?', style: kPopUpInfo, textAlign: TextAlign.justify),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCELAR', style: TextStyle(fontSize: 10, color: colorSecundario))),
            TextButton(
                onPressed: () {
                  registerExam(uid, widget.examName, valueController.text, dateController.text, context).then((value) {
                    Navigator.of(context).pop();
                    _registerExamSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _registerExamFailed(context);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text("Registrar Examen", textAlign: TextAlign.center, style: kTitulo1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Luego de realizar este examen en un centro especializado, registre el resultado a continuación",
                          textAlign: TextAlign.justify,
                          style: kInfo,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 13.0),
                          controller: valueController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: "Resultado (g/dL)",
                            hintStyle: kInfo,
                            labelStyle: kInfo,
                          ),
                          validator: (result) {
                            return ValidateResult(result!);
                          },
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
                              backgroundColor: MaterialStateProperty.all<Color>(colorPrincipal),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              fixedSize: MaterialStateProperty.all(const Size(160.0, 46.0)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                ConfirmDialog(context);
                              }
                            },
                            child: Text("GUARDAR"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String? ValidateResult(String result) {
  if (result.isEmpty) {
    return 'Resultado no puede estar vacio';
  }
  if (result[0] == '0') {
    return 'Resultado no puede ser cero';
  }
  return null;
}

Future<void> registerExam(String gestID, String examType, String value, String date, BuildContext context) {
  ExamService _examService = ExamService();
  return _examService.registerExamResult(gestID, examType, value, date, context);
}

Future<void> _registerExamSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Examen Registrado',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su examen fue registrado correctamente',
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

Future<void> _registerExamFailed(BuildContext context) {
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
            text: 'Su examen no fue registrado. Por favor, inténtelo más tarde',
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
