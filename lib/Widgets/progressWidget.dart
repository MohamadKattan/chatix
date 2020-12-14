import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
circularProgres(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation(Colors.teal[600])),
  );
}
linerProgres(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(valueColor:AlwaysStoppedAnimation(Colors.greenAccent)),
  );
}