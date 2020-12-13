import 'package:chatix/Pages/sittingAccountPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // this item came from argment = this method = void isSignIned();
  final String currentUserId;
  HomePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),
      // body: RaisedButton.icon(
      //   onPressed: logOutUser,
      //   icon: Icon(Icons.close),
      //   label: Text('SignOut'),
      // ),
    );
  }



  // this function for appBar Widget
  homePageHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings();
            }));
          },
        )
      ],
      backgroundColor: Colors.teal[600],
      title: Container(
        margin: EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: TextStyle(fontSize: 18.0, color: Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration(
              hintText: 'Search hear',
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              filled: true,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: emptyTextForField,
              )),
        ),
      ),
    );
  }
// this method for clear typing insideTextField
   emptyTextForField() {
    searchTextEditingController.clear();
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
