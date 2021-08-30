import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/firebase_user_helper.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  FirebaseUserHelper firebaseHelper = new FirebaseUserHelper();
  TextEditingController searchController = TextEditingController();

  static ValueNotifier<QuerySnapshot?> searchResult = ValueNotifier<QuerySnapshot?>(null);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarState();
  }

  SearchBar() : preferredSize = Size.fromHeight(60.0);
  @override
  final Size preferredSize;
}

class _SearchBarState extends State<SearchBar> {
  void handleSearch(String value) async {
    SearchBar.searchResult.value = null;
    if(value==""){
      SearchBar.searchResult.value=null;
    }else {
      QuerySnapshot foundUser = await widget.firebaseHelper
          .getUserByDisplayName(value);
      if(foundUser.docs.length>0){
        SearchBar.searchResult.value = foundUser;
      }
      print(foundUser.docs);
    }


  }


  @override
  Widget build(context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search',
          filled: true,
          prefixIcon: Icon(Icons.search, size: 28.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {},
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }
}
