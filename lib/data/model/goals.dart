import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? id;
  final int? value;
  final Timestamp? startTime;
  final Timestamp? endTime;
  final int? registerStatus;

  const Goal({this.id, this.value, this.startTime, this.endTime, this.registerStatus});

  factory Goal.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Goal(
      id: data?['id'],
      value: data?['value'],
      startTime: data?['startTime'],
      endTime: data?['endTime'],
      registerStatus: data?['registerStatus'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (value != null) "value": value,
      if (startTime != null) "startTime": startTime,
      if (endTime != null) "endTime": endTime,
      if (registerStatus != null) "registerStatus": registerStatus,
    };
  }
}
