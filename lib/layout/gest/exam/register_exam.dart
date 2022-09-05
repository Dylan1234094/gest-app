// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:gest_app/shared/textfield_date.dart';

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
            title: const Text('Confirmación'),
            content: const Text('¿Desea enviar los datos?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    //! Register exam
                    registerExam(uid, widget.examName, valueController.text, dateController.text, context);

                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  },
                  child: const Text('Si'))
            ],
          );
        });
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
            title: Text("Registrar ${widget.examName}")),
        body: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child:
                              Text("Registro de Examen", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Text(
                            "Luego de realizar este examen en un centro especializado, registre el resultado a continuación",
                            textAlign: TextAlign.justify),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Resultado (g/dL)",
                                ),
                                validator: (result) {
                                  return ValidateResult(result!);
                                })),
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
                              if (_keyForm.currentState!.validate()) {
                                print("Válido");
                                ConfirmDialog(context);
                              } else {
                                print("Invalido");
                              }
                            },
                            child: Text("GUARDAR"),
                            style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(100, 40))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
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

void registerExam(String gestID, String examType, String value, String date, BuildContext context) {
  ExamService _examService = ExamService();
  _examService.registerExamResult(gestID, examType, value, date, context);
}
