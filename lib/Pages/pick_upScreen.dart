// this page will start with receiver call tell he accpet

import 'package:chatix/Models/call.dart';
import 'package:chatix/Pages/call_screen.dart';
import 'package:chatix/resoirces/callMethods.dart';
import 'package:flutter/material.dart';

class PickUpScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  PickUpScreen({@required this.call});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming....',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            Image.network(
              call.callerPic,
              height: 150.0,
              width: 150.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              call.callerName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 75.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    color: Colors.red,
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await callMethods.endCall(call: call);
                    }),
                SizedBox(
                  height: 25.0,
                ),
                IconButton(
                    color: Colors.green,
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CallScreen(call: call);
                      }));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
