import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {

  Firestore.instance.collection("mensagens").snapshots().listen((snapshot) {
    snapshot.documents.forEach((d) => {
      debugPrint(d.data.toString())
    });
  });

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
