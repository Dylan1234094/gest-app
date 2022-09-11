import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gest_app/data/model/goals.dart';
import 'dart:async';
import 'package:intl/intl.dart' as intl;

final db = FirebaseFirestore.instance;

class GoalService {
  Future<Goal> getGoal(String uid, String gestID) async {
    Goal meta;
    var value = 0;
    var startTime = Timestamp.now();
    var endTime = Timestamp.now();
    var registerStatus = 0;

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("metas_act_fisica").doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          value = data["value"];
          startTime = data["startTime"];
          endTime = data["endTime"];
          registerStatus = data["registerStatus"];
        },
        onError: (e) => print("Error al intentar obtener doc $uid en metas"),
      );
    } catch (e) {
      print(e);
      throw e;
    }
    return meta = Goal(id: uid, startTime: startTime, endTime: endTime, value: value);
  }

  void registerGoal(String gestID, String value, String startDate, String endDate, BuildContext context) async {
    var startDay = startDate.substring(0, 2);
    var startMonth = startDate.substring(3, 5);
    var startYear = startDate.substring(6, 10);
    DateTime startDa = DateTime.parse("$startYear-$startMonth-$startDay 00:00:00.000");
    Timestamp startTs = Timestamp.fromDate(startDa);

    var endDay = endDate.substring(0, 2);
    var endMonth = endDate.substring(3, 5);
    var endYear = endDate.substring(6, 10);
    DateTime endDa = DateTime.parse("$endYear-$endMonth-$endDay 00:00:00.000");
    Timestamp endTs = Timestamp.fromDate(endDa);

    Goal meta = Goal(value: int.parse(value), startTime: startTs, endTime: endTs, registerStatus: 1);

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("metas_act_fisica").withConverter(
            fromFirestore: Goal.fromFirestore,
            toFirestore: (Goal meta, options) => meta.toFirestore(),
          );
      await docRef.add(meta);
    } catch (e) {
      print(e);
    }
  }

  void updateGoal(
      String gestID, String goalId, String value, String startDate, String endDate, BuildContext context) async {
    var startDay = startDate.substring(0, 2);
    var startMonth = startDate.substring(3, 5);
    var startYear = startDate.substring(6, 10);
    DateTime startDa = DateTime.parse("$startYear-$startMonth-$startDay 00:00:00.000");
    Timestamp startTs = Timestamp.fromDate(startDa);

    var endDay = endDate.substring(0, 2);
    var endMonth = endDate.substring(3, 5);
    var endYear = endDate.substring(6, 10);
    DateTime endDa = DateTime.parse("$endYear-$endMonth-$endDay 00:00:00.000");
    Timestamp endTs = Timestamp.fromDate(endDa);

    Goal meta = Goal(value: int.parse(value), startTime: startTs, endTime: endTs, registerStatus: 2);

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("metas_act_fisica").doc(goalId).withConverter(
            fromFirestore: Goal.fromFirestore,
            toFirestore: (Goal meta, options) => meta.toFirestore(),
          );
      await docRef.set(meta, SetOptions(merge: true));
    } catch (e) {
      print("error: $e");
    }
  }

  void deleteGoal(String gestID, String goalID, BuildContext context) async {
    Goal meta = const Goal(registerStatus: 3);

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("metas_act_fisica").doc(goalID).withConverter(
            fromFirestore: Goal.fromFirestore,
            toFirestore: (Goal exam, options) => exam.toFirestore(),
          );
      await docRef.set(meta, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<List<Goal>> getListaMetas(String gestID) async {
    List<Goal> listaMetas = [];
    Goal meta;

    try {
      await db
          .collection("gestantes")
          .doc(gestID)
          .collection("metas_act_fisica")
          .where("registerStatus", whereIn: [1, 2])
          .get()
          .then((event) {
            for (var doc in event.docs) {
              meta = Goal(
                  id: doc.id,
                  value: doc.data()["value"],
                  startTime: doc.data()["startTime"],
                  endTime: doc.data()["endTime"]);
              listaMetas.add(meta);
            }
          });
    } catch (e) {
      print(e);
    }

    return listaMetas;
  }
}
