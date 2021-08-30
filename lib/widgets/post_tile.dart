import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/post_screen.dart';
import 'package:social_media/widgets/network_custom_image.dart';
import 'package:social_media/widgets/post_item.dart';

class PostTileView extends StatelessWidget {
  List<PostItem> postItemList;



  PostTileView(this.postItemList);

  @override
  Widget build(BuildContext context) {
    List<GridTile> gridTitle = [];
    postItemList.forEach((postItem) {
      gridTitle.add(
        GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(body: postItem)));
            },
            child: NetworkCustomImage(postItem.post.mediaURL!),
          ),
        ),
      );
    });

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      children: gridTitle,
    );
  }
}
