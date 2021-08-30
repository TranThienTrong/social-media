import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:social_media/widgets/user_searched_item.dart';

class RecommendFollow extends StatefulWidget {
  User user;

  RecommendFollow(this.user);

  @override
  _RecommendFollowState createState() => _RecommendFollowState();
}

class _RecommendFollowState extends State<RecommendFollow> {
  FirebaseUserHelper firebaseUser = new FirebaseUserHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .limit(10)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
              List<UserSearchedItem> userList = [];
              QuerySnapshot querySnapshot = snapshot.data!;
              querySnapshot.docs.forEach((document) {
                  if(document['id']!=widget.user.id){
                    userList.add(UserSearchedItem(User.fromDocumentSnapshot(document)));
                  }
              });

              return ListView(
                children: userList,
              );
          }
          else{
            return CircularProgress();
          }
        });
  }
}


