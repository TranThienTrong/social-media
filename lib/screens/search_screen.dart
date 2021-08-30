import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media/models/firebase_user_helper.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:social_media/widgets/search_bar.dart';
import 'package:social_media/widgets/user_searched_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late double width;
  late double height;
  late EdgeInsets padding;

  FirebaseUserHelper firebaseHelper = new FirebaseUserHelper();
  List<UserSearchedItem> listSearchResult = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: SearchBar(),

        body: ValueListenableBuilder<QuerySnapshot?>(
          valueListenable: SearchBar.searchResult,
          builder: (context, valueListenable, child) {
            return ( SearchBar.searchResult.value == null)
                ? buildNoContent()
                : (SearchBar.searchResult.value!.docs.length<1 || SearchBar.searchResult.value!.docs.isEmpty)?buildNoContent(): Container(
                    height: 100,
                    child: ListView(
                      children: SearchBar.searchResult.value!.docs.map((documentSnapshot) {
                        User user = User.fromDocumentSnapshot(documentSnapshot);
                        return GestureDetector(child: UserSearchedItem(user));
                      }).toList(),
                    ),
                  );
          },
          child: null,
        ));
  }

  buildNoContent() {
    listSearchResult = [];
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    double width3 = width - padding.top - kToolbarHeight;

    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: SvgPicture.asset(
          'assets/images/search.svg',
          height: orientation == Orientation.portrait ? height3 : width3,
        ),
      ),
    );
  }

  List<UserSearchedItem> list() {
    listSearchResult = SearchBar.searchResult.value!.docs.map((documentSnapshot) {
      User user = User.fromDocumentSnapshot(documentSnapshot);
      return UserSearchedItem(user);
    }).toList();

    return listSearchResult;
  }


}
