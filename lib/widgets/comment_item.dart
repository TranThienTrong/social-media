import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/network_custom_image.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;


class CommentItem extends StatelessWidget {
  String userID;
  User? user;
  DateTime commentTime;
  String comment;
  FirebaseUserHelper firebaseUserHelper = new FirebaseUserHelper();

  CommentItem(
      {required this.userID, required this.commentTime, required this.comment});

  factory CommentItem.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return CommentItem(
      userID: documentSnapshot['userID'],
      comment: documentSnapshot['comment'],
      commentTime: documentSnapshot['commentTime'].toDate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseUserHelper.getUserById(userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            User user = User.fromDocumentSnapshot(snapshot.data);
            return Column(children: [
              ListTile(
                title: Text(comment),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(user.photoUrl!),
                ),
                subtitle: Text(timeago.format(commentTime)),
              )
            ]);
          } else {
            return CircularProgress();
          }
        });
  }
}
