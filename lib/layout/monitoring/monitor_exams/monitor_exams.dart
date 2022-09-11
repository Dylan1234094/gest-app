// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/exam/exam_detail.dart';
import 'package:gest_app/layout/gest/exam/register_exam.dart';
import 'package:gest_app/layout/monitoring/monitor_exams/monitor_detail_exam.dart';

class MonitorExamPage extends StatefulWidget {
  final String gestId;

  const MonitorExamPage({Key? key, required this.gestId}) : super(key: key);
  @override
  _MonitorExamPageState createState() => _MonitorExamPageState();
}

class _MonitorExamPageState extends State<MonitorExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('examenes').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return MonitorExamDetailPage(
                                examId: document.id, examName: document["name"], gestId: widget.gestId); //! id
                          }),
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  document['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 24),
                                ),
                                leading: Image.asset('assets/IconsExams/${document['icon']}', width: 50, height: 50),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(builder: (BuildContext context) {
                                        return ExamDetailPage(
                                          examId: document.id,
                                          examName: document["name"],
                                        ); //! id
                                      }),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_right,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                //!Divider
                                height: 10,
                                child: Center(
                                    child: Container(
                                  height: 1,
                                  color: Colors.black,
                                )),
                              ),
                            ],
                          )),
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
