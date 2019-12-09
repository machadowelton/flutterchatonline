import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

void main() => runApp(MyApp());

final ThemeData kiOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

final googleSigin = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSigin.currentUser;
  user = user != null
      ? user
      : await googleSigin.signInSilently().then((value) {
          if (value != null)
            return value;
          else
            return googleSigin.signIn().then((value) {
              return value;
            });
        });
  /* if (user == null)
    user = await googleSigin.signInSilently().then((value) {
      debugPrint("signInSilently: Chegou aqui, o valor de value é: $value");
      return value;
    }).catchError((e) {
      debugPrint("signInSilently: Chegou aqui, o valor de erro é: $e");
    });
  if (user == null)
    user = await googleSigin.signIn().then((value) {
      debugPrint("signIn: Chegou aqui, o valor de value é: $value");
      return value;
    }).catchError((e) {
      debugPrint("signIn: Chegou aqui, o valor de erro é: $e");
    }); */
  /*  if (user == null) user = await googleSigin.signInSilently();
  if (user == null) user = await googleSigin.signIn(); */
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSigin.currentUser.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken));
  }
}

_handleSubmitted(text) async {
  await _ensureLoggedIn();
  _sendMessage(text: text);
}

void _sendMessage({String text, String imgUrl}) {
  Firestore.instance.collection("messages").add({
    "text": text,
    "imgUrl": imgUrl,
    "senderName": googleSigin.currentUser.displayName,
    "senderPhotoUrl": googleSigin.currentUser.photoUrl
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App ChatOnline",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kiOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
          centerTitle: true,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ChatMesssage(),
                  ChatMesssage(),
                  ChatMesssage(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextCompose(),
            )
          ],
        ),
      ),
    );
  }
}

class TextCompose extends StatefulWidget {
  @override
  _TextComposeState createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {
  final _textController = TextEditingController();
  bool _isComposed = false;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposed = text.length > 0;
                  });
                },
                onSubmitted: (value) {
                  _handleSubmitted(value);
                },
                controller: _textController,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposed
                            ? () {
                                _handleSubmitted(_textController.text);
                              }
                            : null)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposed
                            ? () {
                                _handleSubmitted(_textController.text);
                              }
                            : null))
          ],
        ),
      ),
    );
  }
}

class ChatMesssage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://ichef.bbci.co.uk/news/320/cpsprodpb/14F6C/production/_105486858_4669077b-0103-4a09-a640-f065afb9340a.jpg"),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welton",
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text("Teste"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
