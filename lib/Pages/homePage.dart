import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatix/Models/user.dart';
import 'package:chatix/Pages/sittingAccountPage.dart';
import 'package:chatix/Widgets/progressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // this item came from argment = this method = void isSignIned();
  final String currentUserId;
  HomePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  HomePageState createState() => HomePageState(currentUserId: currentUserId);
}

class HomePageState extends State<HomePage> {
  // this argment from =  HomePageState createState() => HomePageState(currentUserId: currentUserId); for don't show our Account
  final String currentUserId;
  HomePageState({Key key, @required this.currentUserId});

  TextEditingController searchTextEditingController = TextEditingController();
  // this quary for search user as list
  Future<QuerySnapshot> futureSearchResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),
      body: futureSearchResult == null
          ? noSearchResultScrren()
          : userFoundScreen(),
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
              return SittingsScreen();
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
              hintText: 'Search',
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
          onFieldSubmitted: controleSearch,
        ),
      ),
    );
  }

// this method for clear typing insideTextField
  emptyTextForField() {
    searchTextEditingController.clear();
  }

// this method for search users
  controleSearch(String userName) {
    Future<QuerySnapshot> allFoundUsers = Firestore.instance
        .collection('users')
        .where('nickname', isGreaterThanOrEqualTo: userName)
        .getDocuments();
    setState(() {
      futureSearchResult = allFoundUsers;
    });
  }

// if user dont search any user
  noSearchResultScrren() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
          child: ListView(
        shrinkWrap: true,
        children: [
          Icon(
            Icons.group,
            color: Colors.teal[600],
            size: 200.0,
          ),
          Center(
            child: Text(
              'Search User',
              style: TextStyle(
                  color: Colors.teal[600],
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )),
    );
  }

// if user search and found result search = users
  userFoundScreen() {
    return FutureBuilder<QuerySnapshot>(
      future: futureSearchResult,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgres();
        } else {
          List<UserResult> searchUserResult = [];
          dataSnapshot.data.documents.forEach((document) {
            User eachUser = User.fromDocument(document);
            UserResult userResult = UserResult(eachUser);
            // this for dont show our Account in result search
            if (currentUserId != document['id']) {
              searchUserResult.add(userResult);
            }
          });
          return ListView(children: searchUserResult);
        }
      },
    );
  }
}

// this class it is (UI face) for show info search
class UserResult extends StatelessWidget {
  // this argment came from = UserResult userResult = UserResult(eachUser);
  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal[600],
                  backgroundImage: CachedNetworkImageProvider(
                    eachUser.photoUrl,
                  ),
                ),
                title: Text(
                  eachUser.nickname,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'joined:'+
                      DateFormat('dd MMMM, yyyy - hh:mm:aa').format(
                          DateTime.parse(
                              (eachUser.createdAt))),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
