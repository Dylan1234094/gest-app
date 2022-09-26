import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;

import 'package:gest_app/data/model/exam_result.dart';

final db = FirebaseFirestore.instance;

class ExamService {
  Future<Exam> getExamResult(String uid, String gestID) async {
    Exam exam;
    var value = 0.0;
    var dateResult = Timestamp.now();

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("resultados_examenes").doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          value = data["value"];
          dateResult = data["dateResult"];
        },
        onError: (e) => print("Error al intentar obtener doc $uid en resultados examenes"),
      );
    } catch (e) {
      print(e);
      throw e;
    }
    return exam = Exam(id: uid, dateResult: dateResult, value: value);
  }

  Future<void> registerExamResult(
      String gestID, String examType, String value, String date, BuildContext context) async {
    var day = date.substring(0, 2);
    var month = date.substring(3, 5);
    var year = date.substring(6, 10);
    DateTime da = DateTime.parse("$year-$month-$day 00:00:00.000");
    Timestamp ts = Timestamp.fromDate(da);

    Exam exam = Exam(examType: examType, value: double.tryParse(value), dateResult: ts, registerStatus: 1);

    var nombreGest = "";
    var apellidoGest = "";
    var codigoObsGest = "";
    var obsFcmToken = "";

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("resultados_examenes").withConverter(
            fromFirestore: Exam.fromFirestore,
            toFirestore: (Exam exam, options) => exam.toFirestore(),
          );
      await docRef.add(exam);

      final gestRef = db.collection("gestantes").doc(gestID);
      await gestRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nombreGest = data["nombre"];
          apellidoGest = data["apellido"];
          codigoObsGest = data["codigoObstetra"];
        },
        onError: (e) => print("Error al intentar obtener doc $gestID en gestante"),
      );

      final obsRef =
          await db.collection("obstetras").where("codigoObstetra", isEqualTo: codigoObsGest).get().then((event) {
        if (event.docs.isNotEmpty) {
          obsFcmToken = event.docs.first.data()["fcmToken"];
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
    var url = 'https://upc-cloud-test.azurewebsites.net/api/sendExamNotification';
    Map data = {
      'examType': examType,
      'nameGest': nombreGest,
      'surnameGest': apellidoGest,
      'idGest': gestID,
      'fcmReceiverToken': obsFcmToken
    };
    var body = json.encode(data);
    try {
      var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateExamResult(
      String gestID, String resultExamID, String value, String date, BuildContext context) async {
    var day = date.substring(0, 2);
    var month = date.substring(3, 5);
    var year = date.substring(6, 10);
    DateTime da = DateTime.parse("$year-$month-$day 00:00:00.000");
    Timestamp ts = Timestamp.fromDate(da);

    Exam exam = Exam(value: double.tryParse(value), dateResult: ts, registerStatus: 2);

    try {
      final docRef =
          db.collection("gestantes").doc(gestID).collection("resultados_examenes").doc(resultExamID).withConverter(
                fromFirestore: Exam.fromFirestore,
                toFirestore: (Exam exam, options) => exam.toFirestore(),
              );
      await docRef.set(exam, SetOptions(merge: true));
    } catch (e) {
      print("error: $e");
      throw e;
    }
  }

  Future<void> deleteExamResult(String gestID, String resultExamID, BuildContext context) async {
    Exam exam = const Exam(registerStatus: 3);

    try {
      final docRef =
          db.collection("gestantes").doc(gestID).collection("resultados_examenes").doc(resultExamID).withConverter(
                fromFirestore: Exam.fromFirestore,
                toFirestore: (Exam exam, options) => exam.toFirestore(),
              );
      await docRef.set(exam, SetOptions(merge: true));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Exam>> getListaResultadosExames(String gestID, String examType) async {
    List<Exam> listaResultadoExamenes = [];
    Exam exam;

    try {
      await db
          .collection("gestantes")
          .doc(gestID)
          .collection("resultados_examenes")
          .where("examType", isEqualTo: examType)
          .where("registerStatus", whereIn: [1, 2])
          .orderBy("dateResult", descending: true)
          .get()
          .then((event) {
            for (var doc in event.docs) {
              exam = Exam(
                  value: double.tryParse(doc.data()["value"].toString()),
                  dateResult: doc.data()["dateResult"],
                  id: doc.id);
              listaResultadoExamenes.add(exam);
            }
          });
    } catch (e) {
      print(e);
    }

    return listaResultadoExamenes;
  }
}
