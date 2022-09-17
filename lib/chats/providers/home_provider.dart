import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';

class HomeProvider {
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit) {
    return firebaseFirestore
        .collection(pathCollection)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getGestantList(String codigoObstetra) {
    return firebaseFirestore
        .collection('gestantes')
        .where("codigoObstetra", isEqualTo: codigoObstetra)
        .snapshots();
  }
}
