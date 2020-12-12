import 'package:chatix/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  // this item came from argment = this method = void isSignIned();
  final String currentUserId;
  HomePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: logOutUser,
      icon: Icon(Icons.close),
      label: Text('SignOut'),
    );
  }
// this method for sign out
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logOutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }
}


class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  }
}

