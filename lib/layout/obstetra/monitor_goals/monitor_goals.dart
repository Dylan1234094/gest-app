// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gest_app/data/model/goals.dart';
import 'package:gest_app/layout/obstetra/monitor_goals/register_goals.dart';
import 'package:gest_app/layout/obstetra/monitor_goals/update_goals.dart';
import 'package:gest_app/service/goals_service.dart';
import 'package:intl/intl.dart';

import '../../../utilities/designs.dart';

class ListaMetas extends StatefulWidget {
  final String gestId;
  const ListaMetas({Key? key, required this.gestId}) : super(key: key);

  @override
  _ListaMetasState createState() => _ListaMetasState();
}

class _ListaMetasState extends State<ListaMetas> {
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return RegisterGoalPage(gestId: widget.gestId); //! id
            }),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: colorPrincipal,
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
              child: FutureBuilder<List<Goal>>(
                future: getListaMetas(widget.gestId),
                builder: (context, snapshotGoals) {
                  switch (snapshotGoals.connectionState) {
                    case ConnectionState.waiting:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshotGoals.hasData) {
                        if (snapshotGoals.data!.isNotEmpty) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshotGoals.data!.length,
                              itemBuilder: ((context, index) {
                                Goal meta = snapshotGoals.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return UpdateGoalPage(
                                              gestId: widget.gestId,
                                              goalId: meta.id!); //! id
                                        },
                                      ),
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
                                          "Desde ${DateFormat('dd/MM/yyyy').format(meta.startTime!.toDate())} hasta ${DateFormat('dd/MM/yyyy').format(meta.endTime!.toDate())}",
                                          style: kSubTitulo1.copyWith(
                                              color: colorSecundario),
                                        ),
                                        Text(
                                          "${meta.value!} min. diarios",
                                          style: kTitulo2,
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
                            child: Center(
                              child:
                                  Text("No se encontraron metas registradas"),
                            ),
                          );
                        }
                      } else {
                        return const Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: Text("Algo salió mal"),
                          ),
                        );
                      }
                    default:
                      return const Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text("Esperando"),
                        ),
                      );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<Goal>> getListaMetas(String uid) async {
  GoalService _goalService = GoalService();
  return await _goalService.getListaMetas(uid);
}
