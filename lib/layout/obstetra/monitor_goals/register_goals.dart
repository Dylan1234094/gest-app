// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/goals_service.dart';
import 'package:gest_app/utilities/textfield_date.dart';

import '../../../utilities/designs.dart';

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
          title: const Text('Confirmación', style: TextStyle(fontSize: 13)),
          content: const Text('¿Desea enviar los datos?',
              style: kInfoPopUp, textAlign: TextAlign.justify),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 10, color: colorSecundario),
              ),
            ),
            TextButton(
              onPressed: () {
                registerGoal(
                        widget.gestId,
                        valueController.text,
                        startDateController.text,
                        endDateController.text,
                        context)
                    .then((value) {
                  Navigator.of(context).pop();
                  _registerGoalSuccess(context);
                }).onError((error, stackTrace) {
                  Navigator.of(context).pop();
                  _registerGoalFailed(context);
                });
              },
              child: const Text(
                'ACEPTAR',
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        );
      },
    );
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
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text("Registrar Meta",
                            textAlign: TextAlign.center, style: kTitulo1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Registre la cantidad de minutos diarios de actividades físicas que la gestante debe cumplir durante un intervalo de tiempo.",
                          textAlign: TextAlign.justify,
                          style: kDescripcion,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 13.0),
                          controller: valueController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            labelText: "Tiempo (min.)",
                            hintStyle: kSubTitulo1,
                            labelStyle: kSubTitulo1,
                          ),
                          validator: (result) {
                            return ValidateResult(result!);
                          },
                        ),
                      ),
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
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colorPrincipal),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(160.0, 46.0)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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

Future<void> registerGoal(String gestID, String value, String startDate,
    String endDate, BuildContext context) {
  GoalService _goalService = GoalService();
  return _goalService.registerGoal(gestID, value, startDate, endDate, context);
}

Future<void> _registerGoalSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Meta Registrada',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          'La meta fue registrada correctamente',
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

Future<void> _registerGoalFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text('Algo salió mal...', style: TextStyle(fontSize: 13)),
        content: const Text(
          'La meta no fue registrada. Por favor, inténtelo más tarde',
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
