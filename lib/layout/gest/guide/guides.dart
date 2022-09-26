// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/guide/guide_detail.dart';

import '../../../utilities/designs.dart';

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
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Buscar...',
                        labelStyle: kInfo,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _search = val;
                        });
                      },
                    ),
                  ),
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
                    },
                  )
                ],
              ),
            ),
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
    return ListView(
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
        }).toList());
  }
}

class _GuideItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> document;
  const _GuideItem({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return GuideDetailPage(guideId: document.id);
            },
          ),
        );
      },
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Hero(
                      tag: 'imgGuia',
                      child: Image.network(document['thumbnail']),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(document['title'], style: kTituloGuia),
                          //SizedBox(height: 5),
                          Text(document['shortDescription'],
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              style: kInfoGuia),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(color: colorSecundario),
        ],
      ),
    );
  }
}
