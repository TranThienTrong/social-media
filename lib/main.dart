import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/profile_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
          accentColor: Colors.deepPurpleAccent),
      title: "Social Media",
      home: HomeScreen(),
      routes: {
        '/profile': (context) => ProfileScreen(SignedAccount.instance.id!),
      },
    );
  }
}
