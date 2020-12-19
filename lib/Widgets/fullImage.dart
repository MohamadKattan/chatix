import 'dart:html';

import 'package:flutter/material.dart';

class FullPhoto extends StatelessWidget {
  // argument connect with chat page = craeteItem=FlatButton
  final String url;
  FullPhoto({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        title: Text('Full image'),
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  FullPhotoScreen({Key key, @required this.url}) : super(key: key);
  @override
  FullPhotoScreenState createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;
  FullPhotoScreenState({Key key, @required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
