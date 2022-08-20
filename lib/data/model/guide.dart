import 'package:cloud_firestore/cloud_firestore.dart';

class Guide {
  final String? id;
  final String? title;
  final String? shortDescription;
  final String? largeDescription;
  final String? thumbnail;

  const Guide({
    this.id,
    this.title,
    this.shortDescription,
    this.largeDescription,
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
      shortDescription: data?['shortDescription'],
      largeDescription: data?['largeDescription'],
      thumbnail: data?['thumbnail'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (shortDescription != null) "shortDescription": shortDescription,
      if (largeDescription != null) "largeDescription": largeDescription,
      if (thumbnail != null) "thumbnail": thumbnail
    };
  }
}
