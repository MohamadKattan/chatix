import 'package:chatix/Widgets/progressWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //this key for start useing google_signIn
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //this key for AuthFirebase
  final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
  // this key for start using SharedPreferences for local data
  SharedPreferences preferences;
  //this bool if user is logged and found his data already in firebase for go to home page and no need save data again
  bool islogged=false;
  // this bool if app running and getting data for turn on circularProgress if not not running
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.teal[900], Colors.teal[300]])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/log1.png'),
              radius: 60,
            ),
            Text(
              'Chatix',
              style: TextStyle(
                  fontSize: 85,
                  fontFamily: 'ArchitectsDaughter'),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: controalSiginIn,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 65.0,
                      width: 270.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('images/3.png'),fit: BoxFit.cover),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(1.0),
                    child: circularProgres(),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// this metod for sigIn in google and Auth with firebase
  Future<Null> controalSiginIn()async{
  }
}
