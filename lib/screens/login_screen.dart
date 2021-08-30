import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/create_account_screen.dart';
import 'package:social_media/widgets/post_item.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseUserHelper _firebaseHelper = new FirebaseUserHelper();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  User? signedUser;
  SignedAccount signedAccount = SignedAccount.instance;
  DateTime? _timesJoined;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _timesJoined = DateTime.now();
        checkAccountInFirestore();
      }
    }, onError: (error) => error.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Colors.yellowAccent,
              ]),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Flutter Social Media"),
              SignInButton(
                Buttons.Google,
                elevation: 0.0,
                text: "Sign in with Google",
                onPressed: () {
                  login();
                },
              )
            ]),
      ),
    );
  }

  void login() async {
    await _googleSignIn.signIn();
  }

  Future<void> checkAccountInFirestore() async {
    // Check if this user exist in Firestore
    _currentUser = _googleSignIn.currentUser;
    DocumentSnapshot? documentSnapshot =
        await _firebaseHelper.getUserById(_currentUser!.id);

    if (documentSnapshot.data() == null) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountScreen()));
      FirebaseFirestore.instance.collection('users').doc(_currentUser!.id).set({
        'id': _currentUser!.id,
        'username': username,
        'email': _currentUser!.email,
        'photoUrl': _currentUser!.photoUrl,
        'displayName': _currentUser!.displayName,
        'bio': '',
        'timeJoined': _timesJoined,
      });

      signedUser = User(id:_currentUser!.id, username: username,email: _currentUser!.email,photoUrl: _currentUser!.photoUrl,displayName: _currentUser!.displayName,bio: '',timeJoined: _timesJoined );
      signedAccount.id = signedUser!.id;
      signedAccount.username = signedUser!.username;
      signedAccount.email = signedUser!.email;
      signedAccount.photoUrl = signedUser!.photoUrl;
      signedAccount.displayName = signedUser!.displayName;
      signedAccount.bio = signedUser!.bio;
      signedAccount.timeJoined = signedUser!.timeJoined;
    }
    else {
      signedUser = User.fromDocumentSnapshot(documentSnapshot);
      signedAccount.id = signedUser!.id;
      signedAccount.username = signedUser!.username;
      signedAccount.email = signedUser!.email;
      signedAccount.photoUrl = signedUser!.photoUrl;
      signedAccount.displayName = signedUser!.displayName;
      signedAccount.bio = signedUser!.bio;
      signedAccount.timeJoined = signedUser!.timeJoined;
      print(signedUser);
    }


    HomeScreen.isLoggedIn.value = true;
  }
}
