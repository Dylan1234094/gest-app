import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/home/goals.dart';

class MetricDetailPage extends StatefulWidget {
  const MetricDetailPage({Key? key}) : super(key: key);

  @override
  State<MetricDetailPage> createState() => _MetricDetailPageState();
}

class _MetricDetailPageState extends State<MetricDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Metric Name")),
        body: FutureBuilder<Object>(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text("H")),
                      ElevatedButton(onPressed: () {}, child: const Text("D")),
                      ElevatedButton(onPressed: () {}, child: const Text("S")),
                      ElevatedButton(onPressed: () {}, child: const Text("M")),
                      ElevatedButton(onPressed: () {}, child: const Text("3M"))
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                      image: NetworkImage(
                          'https://help.highbond.com/helpdocs/highbond/es/Content/images/visualizer/chart_examples/line_chart_simple.png'),
                      width: 500,
                    ),
                  ),
                  Container(
                      //! Boton "Ver Metas" si metrica es Actividad
                      child: (true)
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                    return const GoalsPage();
                                  }),
                                );
                              },
                              child: const Text("VER METAS"),
                            )
                          : null),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "DETALLE DE REGISTROS",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: const [
                              Text("07/05/2018 12:35 pm",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16))
                            ],
                          ),
                          Row(
                            children: const [
                              Text("58 kg",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              );
            }));
  }
}
