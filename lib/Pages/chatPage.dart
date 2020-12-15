import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              createListMessages(),
              //this method for textField and buttons Image+ emogel
              createInput(),
            ],
          )
        ],
      ),
    );
  }

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
                onPressed: () => print('1'),
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
                onPressed: () => print('1'),
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
                onPressed: () => print('1'),
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

  createListMessages() {
    return Flexible(
        child: Center(
            child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
    )));
  }
}
