import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/screens/notification_screen.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/screens/search_screen.dart';
import 'package:social_media/screens/timeline_screen.dart';
import 'package:social_media/screens/upload_screen.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late PageController pageController;
  int pageIndex = 0;

  var _homepageScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pageController = new PageController(
        initialPage: pageIndex, keepPage: true, viewportFraction: 1);
    configurePushNotification();
    super.initState();
  }

  void changePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homepageScaffoldKey,
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: <Widget>[
          TimelineScreen(),
          NotificationScreen(),
          UploadScreen(),
          SearchScreen(),
          ProfileScreen(SignedAccount.instance.id!),
        ],
        onPageChanged: (index) {
          setState(() => this.pageIndex = index);
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: this.pageIndex,
        onTap: changePage,
        activeColor: Theme.of(context).primaryColorDark,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35.0)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  configurePushNotification() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }

    String? token = await FirebaseMessaging.instance.getToken();
    print('Token $token');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(SignedAccount.instance.id)
        .update({'androidNotificationToken': token!});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      print(data);
      String owner = data['user'];




      // String receiverId = data['data']['recipient'];
      // String body = data['notification']['body'];
      if(owner == SignedAccount.instance.id){
        print("SHOW NOTIFICATION");
        SnackBar snackBar = SnackBar(content: Text('hello con trai'));
        _homepageScaffoldKey.currentState!.showSnackBar(snackBar);
      }

    });

  }
}
