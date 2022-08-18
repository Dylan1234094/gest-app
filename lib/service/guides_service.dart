import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gest_app/data/model/guide.dart';

final db = FirebaseFirestore.instance.collection("guias");

class GuideService {
  Future<Guide> getGuideByUID(String uid) async {
    Guide guide;
    var title = "";
    var description = "";
    var thumbnail = "";

    try {
      final docRef = db.doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          title = data["title"];
          description = data["description"];
          thumbnail = data["thumbnail"];
        },
        onError: (e) => print("Error al intentar obtener doc $uid"),
      );
    } catch (e) {
      print(e);
    }
    return guide = Guide(
        id: uid, title: title, description: description, thumbnail: thumbnail);
  }

  Future<QuerySnapshot<Object?>> getGuideList() async {
    // Get docs from collection reference
    QuerySnapshot guides = await db.get();

    if (guides.docs.length != 0) {
      for (var doc in guides.docs) {
        print(doc.data());
      }
    }

    return guides;
  }
}
