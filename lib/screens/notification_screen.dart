import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_notify_helper.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/my_notification.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/screens/post_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/notification_item.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }
  FirebaseNotificationHelper firebaseNotificationHelper =
  new FirebaseNotificationHelper();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: Header("Notification"),
      body: Container(
        child: FutureBuilder(
          future: firebaseNotificationHelper.getAllNotificationForCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Widget> notificationList = [];
              List<DocumentSnapshot> documentList = snapshot.data;
              documentList.forEach((element) {
                MyNotification myNotification = MyNotification.fromQueryDocument(element);
                notificationList.add(NotificationItem(myNotification));
              });

              return ListView(
                children: notificationList,
              );
            } else {
              return LinearProgress();
            }
          },
        ),
      ),
    );
  }
}

