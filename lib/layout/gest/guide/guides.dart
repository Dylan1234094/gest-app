// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/guide/guide_detail.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                  //! Search
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, bottom: 7, top: 15),
                  child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar...'),
                      onChanged: (val) {
                        setState(() {
                          _search = val;
                        });
                      })),
              StreamBuilder(
                  //! Lista
                  stream: FirebaseFirestore.instance
                      .collection('guias')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return _GuideList(snapshot: snapshot, search: _search);
                  })
            ]),
          )),
    );
  }
}

class _GuideList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final String search;
  const _GuideList({Key? key, required this.snapshot, required this.search})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.only(),
          children: snapshot.data!.docs.map((document) {
            if (search.isEmpty) {
              return _GuideItem(document: document);
            }
            if (document['title']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase())) {
              return _GuideItem(document: document);
            }

            return Container();
          }).toList()),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> document;
  const _GuideItem({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return GuideDetailPage(guideId: document.id);
          }));
        },
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Image.network(
                    document['thumbnail'],
                    fit: BoxFit.fill,
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(document['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        //SizedBox(height: 5),
                        Text(document['shortDescription'],
                            maxLines: 3, style: const TextStyle(fontSize: 10.0))
                      ]),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
