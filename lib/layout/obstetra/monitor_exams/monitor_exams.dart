// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/obstetra/monitor_exams/monitor_detail_exam.dart';

import '../../../utilities/designs.dart';

class ListaExamenes extends StatefulWidget {
  final String gestId;

  const ListaExamenes({required this.gestId});
  @override
  _ListaExamenesState createState() => _ListaExamenesState();
}

class _ListaExamenesState extends State<ListaExamenes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('examenes').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map(
                (document) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return MonitorExamDetailPage(
                              examId: document.id,
                              examName: document["name"],
                              gestId: widget.gestId,
                            ); //! id
                          },
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(document['name'], style: kSubTitulo2),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/IconsExams/${document['icon']}',
                                ),
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        kLineaDivisora,
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
