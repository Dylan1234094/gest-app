import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:intl/intl.dart' as intl;

import 'package:gest_app/data/model/exam_result.dart';

final db = FirebaseFirestore.instance;

class ExamService {
  Future<Exam> getExamResult(String uid, String gestID) async {
    Exam exam;
    var value = "";
    var dateResult = "";

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

  void registerExamResult(String gestID, String examType, String value, String date, BuildContext context) async {
    Exam exam = Exam(examType: examType, value: value, dateResult: date, registerStatus: 1);

    try {
      final docRef = db.collection("gestantes").doc(gestID).collection("resultados_examenes").withConverter(
            fromFirestore: Exam.fromFirestore,
            toFirestore: (Exam exam, options) => exam.toFirestore(),
          );
      await docRef.add(exam).then((value) => Navigator.pop(context));
    } catch (e) {
      print(e);
    }
  }

  void updateExamResult(String gestID, String resultExamID, String value, String date, BuildContext context) async {
    Exam exam = Exam(value: value, dateResult: date, registerStatus: 2);

    try {
      final docRef =
          db.collection("gestantes").doc(gestID).collection("resultados_examenes").doc(resultExamID).withConverter(
                fromFirestore: Exam.fromFirestore,
                toFirestore: (Exam exam, options) => exam.toFirestore(),
              );
      await docRef.set(exam, SetOptions(merge: true)).then((value) => Navigator.pop(context));
    } catch (e) {
      print(e);
    }
  }

  void deleteExamResult(String gestID, String resultExamID, BuildContext context) async {
    Exam exam = Exam(registerStatus: 3);

    try {
      final docRef =
          db.collection("gestantes").doc(gestID).collection("resultados_examenes").doc(resultExamID).withConverter(
                fromFirestore: Exam.fromFirestore,
                toFirestore: (Exam exam, options) => exam.toFirestore(),
              );
      await docRef.set(exam, SetOptions(merge: true)).then((value) => Navigator.pop(context));
    } catch (e) {
      print(e);
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
          .where("registerStatus", isNotEqualTo: 3)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          exam = Exam(value: doc.data()["value"], dateResult: doc.data()["dateResult"], id: doc.id);
          listaResultadoExamenes.add(exam);
        }
      });
    } catch (e) {
      print(e);
    }

    return listaResultadoExamenes;
  }
}
