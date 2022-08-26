// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Metas")),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('metas')
                .orderBy('startTime', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  Timestamp startTime = document['startTime'] as Timestamp;
                  DateTime startTimeDate = startTime.toDate();
                  Timestamp endTime = document['endTime'] as Timestamp;
                  DateTime endTimeDate = endTime.toDate();
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Desde ${startTimeDate.day}/${startTimeDate.month}/${startTimeDate.year} hasta ${endTimeDate.day}/${endTimeDate.month}/${endTimeDate.year}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 16)),
                        Text(document['value'] + ' min. diarios',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24))
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
