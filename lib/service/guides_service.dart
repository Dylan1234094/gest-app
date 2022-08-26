import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gest_app/data/model/guide.dart';

import 'dart:async';

final db = FirebaseFirestore.instance;

class GuideService {
  Future<Guide> getGuideByID(String id) async {
    Guide guide;

    var title = "";
    var shortDescription = "";
    var largeDescription = "";
    var thumbnail = "";

    try {
      final docRef = db.collection("guias").doc(id);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          title = data["title"];
          shortDescription = data["shortDescription"];
          largeDescription = data["largeDescription"];
          thumbnail = data["thumbnail"];
        },
        onError: (e) => print("Error al intentar obtener doc $id en guia"),
      );
    } catch (e) {
      print(e);
      print("error en catch");
    }
    return guide = Guide(
        id: id,
        title: title,
        shortDescription: shortDescription,
        largeDescription: largeDescription,
        thumbnail: thumbnail);
  }

  Future<List<Guide>> getGuideList() async {
    List<Guide> listaGuias = [];
    Guide guia;

    try {
      await db.collection("guias").get().then((event) {
        for (var doc in event.docs) {
          guia = Guide(
              id: doc.data()["id"],
              title: doc.data()["title"],
              thumbnail: doc.data()["thumbnail"],
              shortDescription: doc.data()["shortDescription"]);
          listaGuias.add(guia);
        }
      });
    } catch (e) {
      print(e);
    }

    return listaGuias;
  }
}
