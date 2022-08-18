// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/exam/exam.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("EXÁMENES"),
          actions: [],
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: ((context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Hemoglobina",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 24),
                        ),
                        leading: Icon(
                          Icons.bloodtype_outlined,
                          size: 48,
                          color: Colors.red,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                return RegisterExamPage( //! Se ingresa la UID
                                  //idDrink: widget.cocktail.idDrink
                                  );
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
                  ));
            })));
  }
}
