import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatix/Widgets/progressWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// this class for custom appBar for show photo + name user who will start chating
class Chat extends StatelessWidget {
  // argment came from homepage /sendTOcHATpAGE
  final String receiverId;
  final String receiverAveter;
  final String receiverName;
  Chat(
      {Key key,
      @required this.receiverId,
      @required this.receiverAveter,
      @required this.receiverName});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(receiverAveter),
              ),
            ),
            backgroundColor: Colors.teal[600],
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              receiverName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: ChatScreen(
              receiverId: receiverId, receiverAveter: receiverAveter),
        ),
        Material(
          color: Colors.black,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            color: Colors.teal[600],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => print('2'),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(receiverAveter),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          receiverName,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: IconButton(
                      icon: Icon(
                    Icons.list,
                    color: Colors.white,
                  )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  // argment from class up
  final String receiverId;
  final String receiverAveter;
  ChatScreen(
      {Key key, @required this.receiverId, @required this.receiverAveter})
      : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState(
      receiverId: receiverId,
      receiverAveter: receiverAveter); // argment from class up
}

class ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAveter;
  ChatScreenState(
      {Key key, @required this.receiverId, @required this.receiverAveter});
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isDisplayStiker;
  bool isloading;
  File imageFile;
  String imageUrl;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFoucusChange);
    isDisplayStiker = false;
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              createListMessages(),
              (isDisplayStiker ? createStecker() : Text('')),
              createInput(),
            ],
          ),
          createisloading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

// this method include textified+ buttons
  createInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.grey, width: 0.5),
      )),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                onPressed: getStecker,
                icon: Icon(
                  Icons.face,
                  color: Colors.teal[600],
                ),
              ),
            ),
          ),
          Flexible(
              child: Container(
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              decoration: InputDecoration.collapsed(
                  hintText: 'Write here...',
                  hintStyle: TextStyle(color: Colors.grey)),
              controller: textEditingController,
              focusNode: focusNode,
            ),
          )),
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: () => onSendMessage(textEditingController.text, 0),
                icon: Icon(
                  Icons.send,
                  color: Colors.teal[600],
                ),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: getImage,
                icon: Icon(
                  Icons.image,
                  color: Colors.teal[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// this method for showing chanting
  createListMessages() {
    return Flexible(
        child: Center(
            child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
    )));
  }

// this method for if we click on text field for twist from sticker showing to keypord
  onFoucusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isDisplayStiker = false;
      });
    }
  }

// this method for container include sticker
  createStecker() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage('bear1', 2),
                  child: Image.asset(
                    'images/bear1.jpg',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear2', 2),
                  child: Image.asset(
                    'images/bear2.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear3', 2),
                  child: Image.asset(
                    'images/bear3.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage('bear1', 2),
                  child: Image.asset(
                    'images/bear1.jpg',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear2', 2),
                  child: Image.asset(
                    'images/bear2.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear3', 2),
                  child: Image.asset(
                    'images/bear3.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage('bear1', 2),
                  child: Image.asset(
                    'images/bear1.jpg',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear2', 2),
                  child: Image.asset(
                    'images/bear2.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
              FlatButton(
                  onPressed: () => onSendMessage('bear3', 2),
                  child: Image.asset(
                    'images/bear3.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        ],
      ),
    );
  }

//this method whem we will click on Sticker button it will show or close list Stickers
  getStecker() {
    focusNode.unfocus();
    setState(() {
      isDisplayStiker = !isDisplayStiker;
    });
  }

  // after sending stecker it will close list sticker
  Future<bool> onBackPress() {
    if (isDisplayStiker) {
      setState(() {
        isDisplayStiker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

// this method for circuler progsses
  createisloading() {
    return Positioned(
      child: isloading ? circularProgres() : Text(''),
    );
  }

  //this method for pick an image from gallery
  Future getImage() async {
    File newImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImageFile != null) {
      setState(() {
        this.imageFile = newImageFile;
        isloading = true;
      });
    }
    uploadImageFile();
  }

// this method for upload image sender to Storage+firebase
  Future uploadImageFile() async {
    try {
      String fileName = DateTime.now().toString();
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('chatImage').child(fileName);
      StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      storageTaskSnapshot.ref.getDownloadURL().then((value) => (downloadUrl) {
            imageUrl = downloadUrl;
            setState(() {
              isloading = false;
              onSendMessage(imageUrl, 1);
            });
          });
    } catch (ex) {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: 'Errore:' + ex.toString());
    }
  }

// this method for save on firebase all (chat data :text+.....else)
  void onSendMessage(String contentMsg , int type) {}
}
