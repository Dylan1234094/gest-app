// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/guide/guide_detail.dart';
import 'package:gest_app/service/guides_service.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late Future<List> guideList;

  @override
  void initState() {
    super.initState();
    //getGuideList();
  }

  //getGuideList() async {
  //  GuideService().getGuideList();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text("GUÍAS"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                return GuideDetailPage( //! Se ingresa la UID
                                  //idDrink: widget.cocktail.idDrink
                                  );
                              }),
                            );
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: NetworkImage(
                              'https://concepto.de/wp-content/uploads/2019/06/natacion-e1562943144215.jpg'),
                          width: 500,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text(
                                'Natación',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                  'Ideal para la mujer embarazada. Este deporte de bajo impacto tonifica toda la musculatura y, en especial, los grupos de musculares de la espalda y el piso perineal',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })));
  }
}
