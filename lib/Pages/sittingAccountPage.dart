import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatix/Widgets/progressWidget.dart';
import 'package:chatix/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Settings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.teal[600],
//         centerTitle: true,
//         title: Text(
//           'Settings',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SittingsScreen(),
//     );
//   }
// }

class SittingsScreen extends StatefulWidget {
  @override
  _SittingsScreenState createState() => _SittingsScreenState();
}

class _SittingsScreenState extends State<SittingsScreen> {
  //key for starting useing sharedprefrenc
  SharedPreferences preferences;
// value key for includ data from shared
  String id = '';
  String nickname = '';
  String photoUrl = '';
  String aboutMe = '';

  // for controller textfield
  TextEditingController nickNametextEditingController;
  TextEditingController aboutMetextEditingController;

  // for image photoUrl
  File imageFileAvatar;
  //bool
  bool isloading = false;

  // these key for textField help to update
  final FocusNode nickNameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //for read data from shared locally(Auto)
    readDataFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        (imageFileAvatar == null)
                            // NOT NULL=Material
                            ? (photoUrl != '')
                                //IN THIS DISPLAY OLD IMAGE
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.teal[600]),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: photoUrl,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(125.0)),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                //if no found Image from User
                                : Icon(Icons.account_circle,
                                    size: 90.0, color: Colors.grey)
                            // if user want to change his Image
                            : Material(
                                child: Image.file(
                                  imageFileAvatar,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(125.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          onPressed: () => getImage(),
                          icon: Icon(Icons.camera_alt),
                          color: Colors.white54.withOpacity(0.3),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey,
                          iconSize: 90.0,
                          padding: EdgeInsets.all(0.0),
                        ),

                        // this button for change image
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isloading ? circularProgres() : Text(''),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          'Profile Name :',
                          style: TextStyle(
                              color: Colors.teal[600],
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.teal[600]),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'your name',
                              hintStyle: TextStyle(color: Colors.black)),
                          controller: nickNametextEditingController,
                          onChanged: (value) {
                            nickname = value;
                          },
                          focusNode: nickNameFocusNode,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 5.0),
                        child: Text(
                          'aboutMe:',
                          style: TextStyle(
                              color: Colors.teal[600],
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.teal[600]),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'about you ',
                              hintStyle: TextStyle(color: Colors.grey)),
                          controller: aboutMetextEditingController,
                          onChanged: (value) {
                            aboutMe = value;
                          },
                          focusNode: aboutMeFocusNode,
                        ),
                      ),
                    ),
                  ],
                ),
                // Buttons
                Container(
                  child: FlatButton(
                    onPressed: updateData,
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.teal[600],
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: FlatButton(
                    onPressed: logOutUser,
                    child: Text(
                      'LogOut',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.red[600],
                    highlightColor: Colors.grey,
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//for read data from shared locally
  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    nickname = preferences.getString('nickname');
    photoUrl = preferences.getString('photoUrl');
    aboutMe = preferences.getString('aboutMe');

    nickNametextEditingController = TextEditingController(text: nickname);
    aboutMetextEditingController = TextEditingController(text: aboutMe);

    setState(() {});
  }

// this method for pick an image for change image profile
  Future getImage() async {
    File newImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImageFile != null) {
      setState(() {
        this.imageFileAvatar = newImageFile;
        isloading = true;
      });
    }
    uploadImageToFirebaseAndStorage();
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
    this.setState(() {
      isloading = false;
    });
  }

// this method for updata Image user and upload to fireStoreAnd Storage came from = (getImage)
  Future uploadImageToFirebaseAndStorage() async {
    // 1_id for each user when want to update
    try {
      String mFileName = id;
      // 2_ Start upload tp Storage
      final StorageReference storageReference =
          FirebaseStorage.instance.ref().child(mFileName);
      StorageUploadTask storageUploadTask =
          storageReference.putFile(imageFileAvatar);
      var imageUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      photoUrl = imageUrl.toString();
      Firestore.instance.collection('users').document(id).updateData({
        'photoUrl': photoUrl,
        'nickname': nickname,
        'aboutMe': aboutMe,
        // //         // 4_ after that will update to locale to shaerdprefrenc
      }).then((value) async {
        await preferences.setString('photoUrl', photoUrl);
        setState(() {
          isloading = false;
        });
      });
    } catch (e) {
      setState(() {
            isloading = false;
          });
      Fluttertoast.showToast(msg: 'Error update try again');
    }

    // StorageTaskSnapshot storageTaskSnapshot;
    // storageUploadTask.onComplete.then((value)
    // // {
    // //   if (value == null) {
    // //     storageTaskSnapshot = value;
    // //     storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUr) {
    // //       photoUrl = newImageDownloadUr;
    // //       // 3_ here after update to storage we will update to fireStore
    // //       Firestore.instance.collection('users').document(id).updateData({
    // //         'photoUrl': photoUrl,
    // //         'nickname': nickname,
    // //         'aboutMe': aboutMe,
    // //         // 4_ after that will update to locale to shaerdprefrenc
    // //       }).then((value) async {
    // //         await preferences.setString('photoUrl', photoUrl);
    // //         setState(() {
    // //           isloading = false;
    // //         });
    // //         Fluttertoast.showToast(msg: 'Update don');
    // //       });
    // //     }, onError: (err) {
    // //       setState(() {
    // //         isloading = false;
    // //       });
    // //       Fluttertoast.showToast(msg: 'Error update try again');
    // //     });
    // //   }
    // // }, onError: (erroremsg) {
    // //   setState(() {
    // //     isloading = false;
    // //   });
    // //   Fluttertoast.showToast(
    // //     msg: erroremsg.toString(),
    // //   );
    // // });
  }

// this method for updateDat nickname+aboutme to fireStore
  void updateData() {
    nickNameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    setState(() {
      isloading = true;
    });

    Firestore.instance.collection('users').document(id).updateData({
      'photoUrl': photoUrl,
      'nickname': nickname,
      'aboutMe': aboutMe,
      // 4_ after that will update to locale to shaerdprefrenc
    }).then((value) async {
      await preferences.setString('photoUrl', photoUrl);
      await preferences.setString('nickname', nickname);
      await preferences.setString('aboutMe', aboutMe);
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: 'Update don');
    });
  }
}
