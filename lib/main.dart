import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {

  QuerySnapshot snapshot =  await Firestore.instance.collection("usuarios").getDocuments();
  snapshot.documents.forEach((document) => {
    debugPrint(" ${document.documentID} :${document.data.toString()}")
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
