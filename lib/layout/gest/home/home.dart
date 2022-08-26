// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/home/metric_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return const MetricDetailPage(); //! GuideId
                      }),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const <Widget>[
                              Text(
                                'Peso',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text('Gráfico evolutivo',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18))
                            ],
                          ),
                        ),
                        Image(
                          image: NetworkImage(
                              'https://help.highbond.com/helpdocs/highbond/es/Content/images/visualizer/chart_examples/line_chart_simple.png'),
                          width: 500,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })));
  }
}
