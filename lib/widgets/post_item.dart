import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_comment_helper.dart';
import 'package:social_media/models/firebase_notify_helper.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/comment_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/widgets/network_custom_image.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:animator/animator.dart';

class PostItem extends StatefulWidget {
  Post post;

  PostItem(this.post);

  factory PostItem.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return PostItem(Post.fromDocumentSnapshot(documentSnapshot));
  }

  int getLikeCount() {
    int count = 0;
    if (post.likes == null) {
      return 0;
    }
    post.likes!.values.forEach((element) {
      if (element == true) {
        count++;
      }
    });

    return count;
  }

  @override
  _PostItemState createState() => _PostItemState(
      postID: post.postID,
      ownerID: post.ownerID,
      username: post.username,
      mediaURL: post.mediaURL,
      location: post.location,
      caption: post.caption,
      likes: post.likes,
      likeCount: getLikeCount(),
      postTime: post.postTime);
}

class _PostItemState extends State<PostItem> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseUserHelper firebaseUser = new FirebaseUserHelper();
  FirebasePostHelper firebasePost = new FirebasePostHelper();
  FirebaseCommentHelper firebaseComment = new FirebaseCommentHelper();
  FirebaseNotificationHelper firebaseNotification =
      new FirebaseNotificationHelper();

  late String postID;
  late String ownerID;
  late String username;
  String? mediaURL;
  String? location;
  String? caption;
  late DateTime postTime;

  /* like feature */
  Map? likes;
  int likeCount;
  bool isLiked = false;
  bool isHearted = false;

  _PostItemState(
      {required this.postID,
      required this.ownerID,
      required this.username,
      this.mediaURL,
      this.location,
      this.caption,
      this.likes,
      this.likeCount = 0,
      required this.postTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: firebaseUser.getUserById(this.ownerID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              User user = User.fromDocumentSnapshot(snapshot.data);
              return ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(user.photoUrl!),
                ),
                title: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user.id!))),
                  child: Text(
                    user.displayName!,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  postTime.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                trailing: IconButton(
                    onPressed: () {
                      if (SignedAccount.instance.id == this.ownerID) {
                        showDeleteDialog(context);
                      }
                    },
                    icon: Icon(Icons.more_vert)),
              );
            } else {
              return CircularProgress();
            }
          },
        ),
        GestureDetector(
          onDoubleTap: createHeartAnimation,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(

                  child: NetworkCustomImage(mediaURL!),
                ),
                if (isHearted == true)
                  Animator(
                    duration: Duration(milliseconds: 500),
                    tween: Tween(begin: 0.8, end: 1.5),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (BuildContext context,
                        AnimatorState<dynamic> animatorState, Widget? child) {
                      return Transform.scale(
                          scale: animatorState.value,
                          child: Icon(Icons.favorite,
                              size: 80.0, color: Colors.red));
                    },
                  ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: handleLike,
                    child: Icon(
                        isLiked == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 25.0,
                        color: Colors.pink),
                  ),
                  GestureDetector(
                    onTap: () => showComment(
                        context: context,
                        postID: this.postID,
                        ownerID: this.ownerID),
                    child: Icon(Icons.chat, size: 25.0, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                      (likeCount > 0)
                          ? '${likeCount} likes '
                          : '${likeCount} like ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ))
                  ],
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                      "${caption}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ))
                  ],
                )),
          ],
        ),
      ],
    );
  }

  /* _________________________________ HELPER FUNCTION _________________________________ */

  void handleLike() async {
    bool isUserLikedBefore = likes![SignedAccount.instance.id] == true;
    print(isUserLikedBefore);

    if (isUserLikedBefore) {
      print('unLiked');

      setState(() {
        likeCount--;
        this.isLiked = false;
        likes![SignedAccount.instance.id] = false;
      });
      await firebasePost.updateLike(this.postID, this.ownerID, false);
      await firebaseNotification.deleteNotification(
          postID: this.postID, ownerID: this.ownerID);
    } else if (!isUserLikedBefore) {
      print('liked');
      setState(() {
        likeCount++;
        this.isLiked = true;
        likes![SignedAccount.instance.id] = true;
      });

      await firebasePost.updateLike(this.postID, this.ownerID, true);
      await firebaseNotification.insertPostNotification(
          postID: this.postID, ownerID: this.ownerID, notifyType: 'like');
    }
  }

  createHeartAnimation() {
    Animator(
      duration: Duration(milliseconds: 300),
      tween: Tween(begin: 0.8, end: 1.4),
      curve: Curves.elasticOut,
      cycles: 0,
      builder: (BuildContext context, AnimatorState<dynamic> animatorState,
          Widget? child) {
        return Transform.scale(
            scale: animatorState.value,
            child: Icon(Icons.favorite, size: 80.0, color: Colors.red));
      },
    );

    setState(() {
      isHearted = true;
      handleLike();
    });

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isHearted = false;
      });
    });
  }

  showComment(
      {required BuildContext context,
      required String postID,
      required String ownerID}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentScreen(postID, ownerID);
    }));
  }

  showDeleteDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: [
              SimpleDialogOption(
                  onPressed: () async {
                    await deletePost();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  deletePost() async {
    await firebasePost.deletePost(this.postID, this.ownerID);
    await firebaseNotification.deleteNotification(postID: this.postID, ownerID: this.ownerID);
    await firebaseComment.deleteAllComment(this.postID);
  }
}
