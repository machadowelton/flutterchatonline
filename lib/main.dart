import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  Firestore.instance
      .collection("mensagens")
      .document()
      .collection("arqmidia")
      .document()
      .setData({"from": "Welton", "texto": "Olá"});

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
