// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/exam_result_service.dart';
import 'package:gest_app/service/goals_service.dart';
import 'package:gest_app/shared/textfield_date.dart';

class RegisterGoalPage extends StatefulWidget {
  final String gestId;
  const RegisterGoalPage({Key? key, required this.gestId}) : super(key: key);

  @override
  State<RegisterGoalPage> createState() => _RegisterGoalPageState();
}

class _RegisterGoalPageState extends State<RegisterGoalPage> {
  final _keyForm = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final valueController = TextEditingController();

  void ConfirmDialog(BuildContext context) {
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
                    registerGoal(
                        widget.gestId, valueController.text, startDateController.text, endDateController.text, context);

                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  },
                  child: const Text('Si'))
            ],
          );
        });
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
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
            title: Text("Registrar Meta de Act. Física")),
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
                          child: Text("Registro de Meta", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Text(
                            "Registre la cantidad de minutos diarios de actividades físicas que la gestante debe cumplir durante un intervalo de tiempo.",
                            textAlign: TextAlign.justify),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Tiempo (min.)",
                                ),
                                validator: (result) {
                                  return ValidateResult(result!);
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: "Fecha Inicial",
                            dateController: startDateController,
                            continous: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: "Fecha Final",
                            dateController: endDateController,
                            continous: true,
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

void registerGoal(String gestID, String value, String startDate, String endDate, BuildContext context) {
  GoalService _goalService = GoalService();
  _goalService.registerGoal(gestID, value, startDate, endDate, context);
}
