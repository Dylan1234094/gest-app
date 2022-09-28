// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/layout/gest/exam/exams.dart';
import 'package:gest_app/layout/gest/guide/guides.dart';
import 'package:gest_app/layout/gest/home/home.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:gest_app/shared/chat.dart';
import 'package:gest_app/shared/drawer_gest.dart';

import '../../utilities/designs.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  static String id = '/tabs';

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  final List<Widget> _tabs = [HomePage(), GuidePage(), ExamPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
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
                backgroundColor: colorPrincipal,
                child: Icon(Icons.sms_outlined),
              );
            }),
          );
        }),
      ),
      body: _tabs[_selectedIndex],
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40.0),
            label: "INICIO",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined, size: 40.0),
            label: "GUÍAS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined, size: 40.0),
            label: "EXÁMENES",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 45.0,
        backgroundColor: colorPrincipal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    );
  }
}

Future<Obstetra> getObstetraChat(String gestID) {
  GestanteService _gestanteService = GestanteService();
  return _gestanteService.getObstetraChat(gestID);
}
