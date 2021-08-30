import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/screens/timeline_screen.dart';

class UserSearchedItem extends StatefulWidget {
  late User user;

  UserSearchedItem(this.user);

  @override
  _UserSearchedItemState createState() => _UserSearchedItemState();
}

class _UserSearchedItemState extends State<UserSearchedItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(widget.user.id!)));
        },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        color: Colors.blue,
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(widget.user.photoUrl!),
                ),
                title: Text(
                  widget.user.displayName!,
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.user.username!,
                  style: TextStyle(color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
