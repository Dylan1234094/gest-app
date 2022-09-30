import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String? id;
  final double? value;
  final Timestamp? dateResult;
  final String? examType;
  final int? registerStatus;

  const Exam({this.id, this.value, this.dateResult, this.examType, this.registerStatus});

  factory Exam.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Exam(
      id: data?['id'],
      value: data?['value'],
      dateResult: data?['dateResult'],
      examType: data?['examType'],
      registerStatus: data?['registerStatus'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (value != null) "value": value,
      if (dateResult != null) "dateResult": dateResult,
      if (examType != null) "examType": examType,
      if (registerStatus != null) "registerStatus": registerStatus,
    };
  }
}
