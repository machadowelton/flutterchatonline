import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {

  DocumentSnapshot snapshot = await Firestore.instance.collection("usuarios").document("welton").get();
  debugPrint(snapshot.data.toString());

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
