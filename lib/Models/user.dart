//this class for receive data from firebase after set
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nickname;
  final String photoUrl;
  final String createdAt;
  User({this.id, this.nickname, this.photoUrl, this.createdAt});

  factory User.fromDocument(DocumentSnapshot doc ){
    return User(
      id: doc.documentID,
      nickname: doc['nickname'],
      photoUrl: doc['photoUrl'],
      createdAt: doc['createdAt'],
    );
  }
}
