// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Metas")),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('gestantes')
                .doc(uid)
                .collection("metas_act_fisica")
                .orderBy('startTime', descending: false)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.size == 0) {
                return const Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text("No se encontraron metas registradas")),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  Timestamp startTime = document['startTime'] as Timestamp;
                  DateTime startTimeDate = startTime.toDate();
                  Timestamp endTime = document['endTime'] as Timestamp;
                  DateTime endTimeDate = endTime.toDate();
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                        'Desde ${startTimeDate.day}/${startTimeDate.month}/${startTimeDate.year} hasta ${endTimeDate.day}/${endTimeDate.month}/${endTimeDate.year}',
                                        style: TextStyle(fontStyle: FontStyle.normal, fontSize: 15))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(document['value'].toString() + ' min. diarios', style: TextStyle(fontSize: 24))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
