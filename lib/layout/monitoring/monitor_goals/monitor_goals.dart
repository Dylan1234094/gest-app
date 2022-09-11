// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/goals.dart';
import 'package:gest_app/layout/monitoring/monitor_goals/register_goals.dart';
import 'package:gest_app/layout/monitoring/monitor_goals/update_goals.dart';
import 'package:gest_app/service/goals_service.dart';

import 'package:intl/intl.dart' as intl;

class MonitorGoalPage extends StatefulWidget {
  final String gestId;
  const MonitorGoalPage({Key? key, required this.gestId}) : super(key: key);

  @override
  _MonitorGoalPageState createState() => _MonitorGoalPageState();
}

class _MonitorGoalPageState extends State<MonitorGoalPage> {
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
        backgroundColor: Color(0xFF245470),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<Object>(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                FutureBuilder<List<Goal>>(
                  future: getListaMetas(widget.gestId),
                  builder: (context, snapshotGoals) {
                    switch (snapshotGoals.connectionState) {
                      case ConnectionState.waiting:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: CircularProgressIndicator()),
                        );
                      case ConnectionState.done:
                        if (snapshotGoals.hasData) {
                          if (snapshotGoals.data!.isNotEmpty) {
                            return ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshotGoals.data!.length,
                              itemBuilder: ((context, index) {
                                Goal meta = snapshotGoals.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(builder: (BuildContext context) {
                                          return UpdateGoalPage(gestId: widget.gestId, goalId: meta.id!); //! id
                                        }),
                                      );
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                    "Desde ${intl.DateFormat('dd/MM/yyyy').format(meta.startTime!.toDate())} hasta ${intl.DateFormat('dd/MM/yyyy').format(meta.endTime!.toDate())}",
                                                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 15))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("${meta.value!} min. diarios", style: TextStyle(fontSize: 24))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text("No se encontraron metas registradas")),
                            );
                          }
                        } else {
                          return const Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Text("Algo salió mal")),
                          );
                        }
                      default:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text("Esperando")),
                        );
                    }
                  },
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

Future<List<Goal>> getListaMetas(String uid) async {
  GoalService _goalService = GoalService();
  return await _goalService.getListaMetas(uid);
}
