import 'package:cloud_firestore/cloud_firestore.dart';

class Guide {
  final String? id;
  final String? title;
  final String? description;
  final String? thumbnail;

  const Guide({
    this.id,
    this.title,
    this.description,
    this.thumbnail
  });

  factory Guide.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Guide(
      id: data?['id'],
      title: data?['title'],
      description: data?['description'],
      thumbnail: data?['thumbnail'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (thumbnail != null) "thumbnail": thumbnail
    };
  }
}
