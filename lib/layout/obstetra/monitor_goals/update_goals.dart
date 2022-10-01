// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/goals.dart';
import 'package:gest_app/service/goals_service.dart';
import 'package:gest_app/utilities/textfield_date.dart';

import 'package:intl/intl.dart' as intl;

import '../../../utilities/designs.dart';

class UpdateGoalPage extends StatefulWidget {
  final String gestId;
  final String goalId;
  const UpdateGoalPage({
    Key? key,
    required this.gestId,
    required this.goalId,
  }) : super(key: key);

  @override
  State<UpdateGoalPage> createState() => _UpdateGoalPageState();
}

class _UpdateGoalPageState extends State<UpdateGoalPage> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final valueController = TextEditingController();

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
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 10, color: colorSecundario),
              ),
            ),
            TextButton(
              onPressed: () {
                updateGoal(
                        widget.gestId,
                        widget.goalId,
                        valueController.text,
                        startDateController.text,
                        endDateController.text,
                        context)
                    .then((value) {
                  Navigator.of(context).pop();
                  _updateGoalSuccess(context);
                }).onError((error, stackTrace) {
                  Navigator.of(context).pop();
                  _updateGoalFailed(context);
                });
              },
              child: const Text('ACEPTAR', style: TextStyle(fontSize: 10)),
            )
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
          content: const Text('¿Desea eliminar el registro?',
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
                deleteGoal(widget.gestId, widget.goalId, context).then((value) {
                  Navigator.of(context).pop();
                  _deleteGoalSuccess(context);
                }).onError((error, stackTrace) {
                  Navigator.of(context).pop();
                  _deleteGoalFailed(context);
                });
              },
              child: const Text('ACEPTAR', style: TextStyle(fontSize: 10)),
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
        body: FutureBuilder<Goal>(
          future: getGoal(widget.goalId, widget.gestId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case (ConnectionState.done):
                if (snapshot.hasData) {
                  valueController.text = snapshot.data!.value!.toString();
                  startDateController.text = intl.DateFormat('dd/MM/yyyy')
                      .format(snapshot.data!.startTime!.toDate());
                  endDateController.text = intl.DateFormat('dd/MM/yyyy')
                      .format(snapshot.data!.endTime!.toDate());
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
                            child: Text('Actualizar Meta',
                                textAlign: TextAlign.center, style: kTitulo1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'Edite la meta a continuación',
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
                                border: OutlineInputBorder(),
                                labelText: "Tiempo (min.)",
                                hintStyle: kSubTitulo1,
                                labelStyle: kSubTitulo1,
                              ),
                              validator: (result) {
                                return validateResult(result!);
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
                                      borderRadius: BorderRadius.circular(10.0),
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
          },
        ),
      ),
    );
  }
}

String? validateResult(String result) {
  if (result.isEmpty) {
    return 'Resultado no puede estar vacio';
  }
  if (result[0] == '0') {
    return 'Resultado no puede ser cero';
  }
  return null;
}

Future<void> updateGoal(String gestID, String goalID, String value,
    String startDate, String endDate, BuildContext context) {
  GoalService _goalService = GoalService();
  return _goalService.updateGoal(
      gestID, goalID, value, startDate, endDate, context);
}

Future<void> deleteGoal(String gestID, String goalID, BuildContext context) {
  GoalService _goalService = GoalService();
  return _goalService.deleteGoal(gestID, goalID, context);
}

Future<Goal> getGoal(String goalID, String gestID) {
  GoalService _goalService = GoalService();
  return _goalService.getGoal(goalID, gestID);
}

Future<void> _updateGoalSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Meta Actualizada',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          'La meta fue actualizada correctamente',
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

Future<void> _updateGoalFailed(BuildContext context) {
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
          'La meta no fue actualizada. Por favor, inténtelo más tarde',
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

Future<void> _deleteGoalSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Meta Eliminada',
          style: TextStyle(fontSize: 13),
        ),
        content: const Text(
          "La meta fue eliminada correctamente",
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

Future<void> _deleteGoalFailed(BuildContext context) {
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
          'La meta no fue eliminada. Por favor, inténtelo más tarde',
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
