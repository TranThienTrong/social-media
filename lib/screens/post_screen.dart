import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/post_item.dart';
import 'package:social_media/widgets/progress.dart';

class PostScreen extends StatefulWidget {
  String postID;
  String ownerID;

  PostScreen({required this.postID, required this.ownerID});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
  }
  

  FirebasePostHelper postFirebase = FirebasePostHelper();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: Header("Post"),
      body: FutureBuilder(
        future: postFirebase.getPostById(widget.postID, widget.ownerID),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Post post = new Post.fromDocumentSnapshot(snapshot.data!);
            return ListView(
              children: [
                Container(
                  child: PostItem(post),
                )
              ],
            );
          }
          else{
            return CircularProgress();
          }
        },
      ),
    ));
  }
}
