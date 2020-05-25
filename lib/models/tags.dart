import 'package:cloud_firestore/cloud_firestore.dart';

class Tags {
  String name;

  Tags({this.name});

  factory Tags.fromJson(Map<String, dynamic> data) {
    return Tags(
      name: data["name"],
    );
  }

  factory Tags.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data;
    return Tags(name: data["name"]);
  }
}
