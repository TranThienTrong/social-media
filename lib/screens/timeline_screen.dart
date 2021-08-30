import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/models/firebase_timeline_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/post_item.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/widgets/recommend_follow.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen ({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  FirebaseUserHelper firebaseHelper = new FirebaseUserHelper();
  FirebaseTimelineHelper firebaseTimeline = new FirebaseTimelineHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header("Timeline"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('timeline')
            .doc(SignedAccount.instance.id)
            .collection('timelinePosts')
            .snapshots(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<PostItem> postList = querySnapshot.docs.map((document) {
              return PostItem.fromDocumentSnapshot(document);
            }).toList();

            if(postList.length == 0){
              return RecommendFollow(User.fromSignedinAccount(SignedAccount.instance));
            } else{
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: postList,
                ),
              );
            }
          } else {
            return CircularProgress();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoogleSignIn _googleSignIn = GoogleSignIn();
          _googleSignIn.signOut();
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }
}
