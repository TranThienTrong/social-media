import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_follower_helper.dart';
import 'package:social_media/models/firebase_following_helper.dart';
import 'package:social_media/models/firebase_notify_helper.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/screens/profile_screen.dart';

class ProfileButton extends StatefulWidget {
  String userProfileID;
  Function setFollow;

  ProfileButton(this.userProfileID, this.setFollow);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  FirebaseFollowerHelper firebaseFollower = new FirebaseFollowerHelper();
  FirebaseFollowingHelper firebaseFollowing = new FirebaseFollowingHelper();
  FirebaseNotificationHelper firebaseNotification =
      new FirebaseNotificationHelper();

  bool? isFollowing;

  @override
  Widget build(BuildContext context) {
    if (widget.userProfileID == SignedAccount.instance.id)
      return OutlinedButton(
        onPressed: () {},
        child: Text("Edit Profile"),
      );
    else
      return FutureBuilder(
          future: firebaseFollowing.getFollowingStatus(
              myID: SignedAccount.instance.id!, theirID: widget.userProfileID),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              isFollowing = snapshot.data;

              if(isFollowing==true) {
                return OutlinedButton(
                  onPressed: handleUnFollow,
                  child: Text("Unfollow"),
                );
              }
              else {
                return OutlinedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: handleFollow,
                  child: Text('Follow', style: TextStyle(color: Colors.white),),
                );
              }
            }
            else{
              return OutlinedButton(
                onPressed: handleFollow,
                child: Text('unknown'),
              );
            }
          });
  }

/* _________________________________ HELPER FUNCTION _________________________________ */

  handleFollow() {
    setState(() {
      isFollowing = true;
      widget.setFollow(true);
      firebaseFollower.addFollowerToThem(
          theirID: widget.userProfileID, myID: SignedAccount.instance.id!);
      firebaseFollowing.addFollowingToUs(
          myID: SignedAccount.instance.id!, theirID: widget.userProfileID);
      //firebaseNotification.insertFollowNotification(followerID: widget.userProfileID, followingID: SignedAccount.instance.id!);
    });
  }

  handleUnFollow() {
    setState(() {
      isFollowing = false;
      widget.setFollow(false);
      firebaseFollower.deleteFollowerToThem(
          theirID: widget.userProfileID, myID: SignedAccount.instance.id!);
      firebaseFollowing.deleteFollowingToUs(
          myID: SignedAccount.instance.id!, theirID: widget.userProfileID);
      //firebaseNotification.insertFollowNotification(followerID: widget.userProfileID, followingID: SignedAccount.instance.id!);
    });
  }
}
