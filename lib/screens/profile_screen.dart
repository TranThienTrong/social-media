import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_follower_helper.dart';
import 'package:social_media/models/firebase_following_helper.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/count_column_item.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/network_custom_image.dart';
import 'package:social_media/widgets/post_item.dart';
import 'package:social_media/widgets/post_tile.dart';
import 'package:social_media/widgets/profile_button.dart';
import 'package:social_media/widgets/progress.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen(this.userId);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  FirebaseUserHelper firebaseUserHelper = new FirebaseUserHelper();
  FirebasePostHelper firebasePostHelper = new FirebasePostHelper();
  FirebaseFollowerHelper firebaseFollowers = new FirebaseFollowerHelper();
  FirebaseFollowingHelper firebaseFollowing = new FirebaseFollowingHelper();

  List<PostItem>? postItemList;
  String postView = "grid";
  bool isLoading = false;
  bool isFollowing = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  setFollow(bool isFollow) {
    setState(() {
      this.isFollowing = isFollow;
    });
  }

  @override
  void initState() {
    if (postItemList == null) {
      getAllUserPost();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  User? user;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: Header("Profile"),
      body: ListView(
        children: [
          FutureBuilder(
              future: Future.wait([
                firebaseUserHelper.getUserById(widget.userId),
                firebaseFollowing.getAllFollowing(widget.userId),
                firebaseFollowers.getAllFollowers(widget.userId),
              ]),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  user = User.fromDocumentSnapshot(snapshot.data[0]!);
                  QuerySnapshot followingSnapshot = snapshot.data[1];
                  QuerySnapshot followersSnapshot = snapshot.data[2];

                  followingCount = followingSnapshot.docs.length;

                  followersCount = followersSnapshot.docs.length;

                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(user!.photoUrl!),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CountColumnItem(postCount, 'post'),
                                      CountColumnItem(
                                          followersCount, 'followers'),
                                      CountColumnItem(
                                          followingCount, 'following'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            user!.username!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            user!.bio!,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: ProfileButton(user!.id!, setFollow),
                        ),
                      ],
                    ),
                  );
                } else {
                  return CircularProgress();
                }
              }),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      postView = "grid";
                    });
                  },
                  color: postView == "grid" ? Colors.blue : Colors.black,
                  icon: Icon(Icons.grid_on)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      postView = "list";
                    });
                  },
                  color: postView == "list" ? Colors.blue : Colors.black,
                  icon: Icon(Icons.list)),
            ],
          ),
          Divider(),
          if (postItemList != null)
            if (postView == "grid")
              PostTileView(postItemList!)
            else
              Column(
                children: postItemList!
                    .map((postItem) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: NetworkCustomImage(postItem.post.mediaURL!),
                        ))
                    .toList(),
              )
        ],
      ),
    );
  }

  /* _________________________________ HELPER FUNCTION _________________________________ */
  Future<void> getAllUserPost() async {
    postItemList = [];
    QuerySnapshot querySnapshot =
        await firebasePostHelper.getAllPostsOfUser(widget.userId);
    querySnapshot.docs.forEach((document) {
      postCount++;
      postItemList!.add(PostItem.fromDocumentSnapshot(document));
    });
    setState(() {});
  }

  Future<void> getAllFollowing() async {
    CollectionReference followingCollectionRef =
        FirebaseFirestore.instance.collection('following');

    QuerySnapshot querySnapshot = await followingCollectionRef
        .doc(widget.userId)
        .collection('userFollowing')
        .get();

    querySnapshot.docs.forEach((document) {});
    setState(() {});
  }
}
