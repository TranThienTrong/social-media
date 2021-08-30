import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  late String postID;
  late String ownerID;
  late String username;
  String? mediaURL;
  String? location;
  String? caption;
  Map? likes;
  late DateTime postTime;

  Post(
      {required this.postID,
        required this.ownerID,
        required this.username,
        this.mediaURL,
        this.location,
        this.caption,
        this.likes,
        required this.postTime});

  factory Post.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return Post(
      postID: documentSnapshot['postID'],
      ownerID: documentSnapshot['ownerID'],
      username: documentSnapshot['username'],
      mediaURL: documentSnapshot['mediaURL'],
      location: documentSnapshot['location'],
      caption: documentSnapshot['caption'],
      likes: documentSnapshot['likes'],
      postTime: documentSnapshot['postTime'].toDate(),
    );
  }
}