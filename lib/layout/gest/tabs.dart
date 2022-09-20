// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/layout/gest/exam/exams.dart';
import 'package:gest_app/layout/gest/guide/guides.dart';
import 'package:gest_app/layout/gest/home/home.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:gest_app/service/obstetra_service.dart';
import 'package:gest_app/shared/chat.dart';
import 'package:gest_app/shared/drawer_gest.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  final List<Widget> _tabs = [HomePage(), GuidePage(), ExamPage()];
  final _tabsName = ["INICIO", "GUÍAS", "EXÁMENES"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerGest(),
      floatingActionButton: FutureBuilder<Obstetra>(
        future: getObstetraChat(uid),
        builder: ((context, snapshotObs) {
          return FutureBuilder<Gestante>(
            future: getGestante(uid),
            builder: ((context, snapshotGest) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Chat(
                      nombreSender: snapshotGest.data!.nombre!,
                      apellidoSender: snapshotGest.data!.apellido!,
                      anotherUserName: 'Obstetra ${snapshotObs.data!.nombre}',
                      anotherUserSurname: '${snapshotObs.data!.apellido}',
                      anotherUserUid: snapshotObs.data!.id!,
                      anotherUserFCMToken: snapshotObs.data!.fcmToken!,
                    );
                  }));
                },
                backgroundColor: Color(0xFF245470),
                child: Icon(Icons.sms_outlined),
              );
            }),
          );
        }),
      ),
      body: _tabs[_currentIndex],
      appBar: AppBar(title: Text(_tabsName[_currentIndex])),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          iconSize: 45.0,
          backgroundColor: Colors.blue,
          fixedColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "INICIO"),
            BottomNavigationBarItem(icon: Icon(Icons.feed_outlined), label: "GUÍAS"),
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_outlined), label: "EXÁMENES"),
          ]),
    );
  }
}

Future<Obstetra> getObstetraChat(String gestID) {
  GestanteService _gestanteService = GestanteService();
  return _gestanteService.getObstetraChat(gestID);
}
