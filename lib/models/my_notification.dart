import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification {
  String usernameNotify;
  String userNotifyID;
  String? postID;
  String? postOwnerID;
  String type;
  DateTime notifyTime;

  MyNotification(
      {required this.usernameNotify,
      required this.userNotifyID,
      this.postID,
      this.postOwnerID,
      required this.type,
      required this.notifyTime});

  factory MyNotification.fromQueryDocument(DocumentSnapshot documentSnapshot) {
      return MyNotification(
          usernameNotify: documentSnapshot['usernameNotify'],
          userNotifyID: documentSnapshot['userNotifyID'],
          postID: documentSnapshot['postID'],
          postOwnerID: documentSnapshot['postOwnerID'],
          type: documentSnapshot['type'],
          notifyTime: documentSnapshot['notifyTime'].toDate());
    }


  @override
  String toString() {

    return " ${usernameNotify} ${ userNotifyID } ${ postID } ${postOwnerID}";
  }
}
