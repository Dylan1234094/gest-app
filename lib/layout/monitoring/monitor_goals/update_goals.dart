// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/goals.dart';
import 'package:gest_app/service/goals_service.dart';
import 'package:gest_app/shared/textfield_date.dart';

import 'package:intl/intl.dart' as intl;

class UpdateGoalPage extends StatefulWidget {
  final String gestId;
  final String goalId;
  const UpdateGoalPage({Key? key, required this.gestId, required this.goalId}) : super(key: key);

  @override
  State<UpdateGoalPage> createState() => _UpdateGoalPageState();
}

class _UpdateGoalPageState extends State<UpdateGoalPage> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final valueController = TextEditingController();

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
                  updateGoal(widget.gestId, widget.goalId, valueController.text, startDateController.text,
                          endDateController.text, context)
                      .then((value) {
                    Navigator.of(context).pop();
                    _updateGoalSuccess(context);
                  }).onError((error, stackTrace) {
                    Navigator.of(context).pop();
                    _updateGoalFailed(context);
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
          content: const Text('¿Desea eliminar el registro?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
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
                child: const Text('Si'))
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
            title: Text("Actualizar Meta")),
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
                    startDateController.text = intl.DateFormat('dd/MM/yyyy').format(snapshot.data!.startTime!.toDate());
                    endDateController.text = intl.DateFormat('dd/MM/yyyy').format(snapshot.data!.endTime!.toDate());
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 20),
                              child:
                                  Text("Actualizar Meta", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            Text("Edite la meta a continuación", textAlign: TextAlign.justify),
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

String? ValidateResult(String result) {
  if (result.isEmpty) {
    return 'Resultado no puede estar vacio';
  }
  if (result[0] == '0') {
    return 'Resultado no puede ser cero';
  }
  return null;
}

Future<void> updateGoal(
    String gestID, String goalID, String value, String startDate, String endDate, BuildContext context) {
  GoalService _goalService = GoalService();
  return _goalService.updateGoal(gestID, goalID, value, startDate, endDate, context);
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
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Meta Actualizada',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'La meta fue actualizada correctamente',
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

Future<void> _updateGoalFailed(BuildContext context) {
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
            text: 'La meta no fue actualizada. Por favor, inténtelo más tarde',
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

Future<void> _deleteGoalSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Meta Eliminada',
          style: TextStyle(fontSize: 13),
        ),
        content: Text("La meta fue eliminada correctamente"),
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
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'La meta no fue eliminada. Por favor, inténtelo más tarde',
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
