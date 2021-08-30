import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_comment_helper.dart';
import 'package:social_media/models/firebase_notify_helper.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/widgets/comment_item.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/progress.dart';

class CommentScreen extends StatefulWidget {
  String postID;
  String ownerID;

  CommentScreen(this.postID, this.ownerID);

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    super.initState();
  }
  TextEditingController commentController = new TextEditingController();
  FirebaseCommentHelper firebaseCommentHelper = new FirebaseCommentHelper();
  FirebaseNotificationHelper firebaseNotificationHelper =
      new FirebaseNotificationHelper();
  FirebaseUserHelper firebaseUserHelper = new FirebaseUserHelper();
  FirebasePostHelper firebasePostHelper = new FirebasePostHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header("Comments"),
        body: Column(
          children: [
            Expanded(child: CommentWidget(widget.postID)),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: "Write comment...",
                ),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await firebaseCommentHelper.addComment(
                        widget.postID, commentController.text);
                    await firebaseNotificationHelper.insertPostNotification(
                        postID: widget.postID,
                        ownerID: widget.ownerID,
                        notifyType: 'comment');

                    commentController.clear();
                  }),
            ),
          ],
        ));
  }
}

class CommentWidget extends StatelessWidget {
  String postID;

  CommentWidget(this.postID);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .doc(postID)
          .collection('postComments')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot querySnapshot = snapshot.data;
          List<CommentItem> commentList = [];
          querySnapshot.docs.map((comment) {
            commentList.add(CommentItem.fromDocumentSnapshot(comment));
          }).toList();

          return ListView(
            children: commentList,
          );
        } else {
          return LinearProgress();
        }
      },
    );
  }
}
