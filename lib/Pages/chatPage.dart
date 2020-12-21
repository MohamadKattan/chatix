import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatix/Widgets/fullImage.dart';
import 'package:chatix/Widgets/progressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          null;
                        },
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
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isDisplayStiker;
  bool isloading;
  File imageFile;
  String imageUrl;
  String chatId;
  String id;
  SharedPreferences preferences;
  var listMessages;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFoucusChange);
    isDisplayStiker = false;
    isloading = false;
    chatId = '';
    readLocal();
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

// this method for get data from firebase by snapshot and show chatting in page
  createListMessages() {
    return Flexible(
        child: chatId == ''
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ))
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    .document(chatId)
                    .collection(chatId)
                    .orderBy('timestamp', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapShot) {
                  // ignore: missing_return
                  if (!snapShot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    listMessages = snapShot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          craeteItem(index, snapShot.data.documents[index]),
                      itemCount: snapShot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ));
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
                    'images/bear2.png',
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
                    'images/bear2.png',
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
                    'images/bear2.png',
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
      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
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
  void onSendMessage(String contentMsg, int type) async {
    if (contentMsg != '') {
      textEditingController.clear();
      var docRf = Firestore.instance
          .collection('messages')
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRf, {
          'idFROM': id,
          'idTo': receiverId,
          'timestamp': DateTime.now().toString(),
          'content': contentMsg,
          'type': type
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Empty message can \'t be send ');
    }
  }

// this method for start chatting connect id + with  another id user
  readLocal() async {
    // for get id user from login
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    // for chatting together
    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }
    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chatting with': receiverId});
    setState(() {});
  }

// the method is a list connect with STREMEBULIDER  for show item that get from fire as list
  Widget craeteItem(int index, DocumentSnapshot document) {
    // here it will showing in right side it will be my message and left side reciver message
    //1_my message right side
    if (document['idFROM'] == id) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          document['type'] == 0
              // Text= typ0
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.teal[600],
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  margin: EdgeInsets.only(
                      bottom: isListMsgRight(index) ? 20.0 : 10, right: 10.0),
                )
              : document['type'] == 1
                  //image = type1
                  ? Container(
                      // this flat for puch image to fullimage page
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FullPhoto(
                              url: document['content'],
                            );
                          }));
                        },
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                // //this matrial for show circullerProgsses
                                Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal[600]),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                            errorWidget: (context, url, error) =>
                                // for error image
                                Material(
                              child: Image.asset(
                                'images/errore.png',
                                height: 200.0,
                                width: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            // Image came from firebase
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isListMsgRight(index) ? 20.0 : 10,
                          right: 10.0),
                    )
                  // steckers=type2
                  : Container(
                      child: Image.asset(
                        'images/${document['content']}.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isListMsgRight(index) ? 20.0 : 10,
                          right: 10.0),
                    ),
        ],
      );
    }
    //2_ricevre message left side
    else {
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 1_ for show profileImage who ricevre my messages
                isListMsgLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              // //this matrial for show circullerProgsses
                              Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.teal[600]),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: receiverAveter,
                          height: 35.0,
                          width: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 35.0,
                      ),
                // 2_ display data from firebase messages+image+sticker

                document['type'] == 0
                    // Text= typ0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        //image = type1
                        ? Container(
                            // this flat for puch image to fullimage page
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullPhoto(
                                    url: document['content'],
                                  );
                                }));
                              },
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      // //this matrial for show circullerProgsses
                                      Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.teal[600]),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      // for error image
                                      Material(
                                    child: Image.asset(
                                      'images/errore.png',
                                      height: 200.0,
                                      width: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  // Image came from firebase
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ) // steckers=type2
                        : Container(
                            child: Image.asset(
                              'images/${document['content']}.png',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
              ],
            ),
            //3_ here will display message time
            isListMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMMM ,yyyy -hh:mm:aa ')
                          .format(DateTime.parse(document['timestamp'])),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                  )
                : Container(),
          ],
        ),
      );
    }
  }

  //  for show  my data messages in right side
  bool isListMsgRight(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]['idFROM'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isListMsgLeft(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]['idFROM'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
