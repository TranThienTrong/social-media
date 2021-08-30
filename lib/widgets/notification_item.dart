import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/my_notification.dart';
import 'package:social_media/screens/post_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  MyNotification notification;

  FirebasePostHelper firebasePostHelper = new FirebasePostHelper();
  FirebaseUserHelper firebaseUserHelper = new FirebaseUserHelper();

  Future<String>? userAvatar;
  Future<String>? imageURL;

  NotificationItem(this.notification){
    imageURL = firebasePostHelper.getImageOfPost(notification.postID!, notification.postOwnerID!);
    userAvatar = firebaseUserHelper.getImageOfUser(notification.userNotifyID);
  }


  String? activity;


  String getActivity() {
    if (notification.type == 'like')
      return "liked your post";
    else if (notification.type == "comment")
      return "comment on your post";
    else if (notification.type == "follow")
      return "follow you";
    else
      return "";
  }

  Widget previewPostImage(String imageURL) {
    if (notification.type == 'like' || notification.type == 'comment') {
      return GestureDetector(
        onTap: (){},
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(imageURL)),
              ),
            ),
          ),
        ),
      );
    } else {
      return Text('Follow');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([ imageURL!, userAvatar! ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Container(
                color: Colors.white,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(postID: notification.postID!, ownerID: notification.postOwnerID!))),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data![1]),
                    ),
                    title: GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(notification.userNotifyID))),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            style: TextStyle(fontSize: 14.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: notification.usernameNotify,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " ${getActivity()} " ,
                              ),
                            ]),
                      ),
                    ),

                    subtitle: Text(timeago.format(notification.notifyTime)),
                    trailing: previewPostImage(snapshot.data![0]),
                  ),
                ),
              ),
            );
          }
          else {
            return LinearProgress();
          }
        }
    );
  }
}