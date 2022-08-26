// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/exam/register_exam.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('examenes').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return RegisterExamPage(examId: document.id); //! id
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 24),
                                ),
                                leading: Image.asset(
                                    'assets/IconsExams/${document['icon']}',
                                    width: 50,
                                    height: 50),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                        return RegisterExamPage(
                                            examId: document.id); //! id
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
