// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/exam/exams.dart';
import 'package:gest_app/layout/gest/guide/guides.dart';
import 'package:gest_app/layout/gest/home/home.dart';
import 'package:gest_app/shared/chat.dart';
import 'package:gest_app/shared/drawer_gest.dart';

import '../../utilities/designs.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  static String id = 'tabs';

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [HomePage(), GuidePage(), ExamPage()];
  //final _tabsName = ["INICIO", "GUÍAS", "EXÁMENES"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerGest(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return Chat(
              anotherUserName: 'Obstetra',
              anotherUserUid: 'lqI9YzdRukhichXsHfx79hXxixu1',
            );
          }));
        },
        backgroundColor: Color(0xFF245470),
        child: Icon(Icons.sms_outlined),
      ),
      body: _tabs[_selectedIndex],
      appBar: AppBar(
          //title: Text(_tabsName[_selectedIndex]),
          ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "INICIO",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: "GUÍAS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined),
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
