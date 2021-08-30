import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_comment_helper.dart';
import 'package:social_media/models/firebase_notify_helper.dart';
import 'package:social_media/models/singned_account.dart';

class FirebasePostHelper {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');


  CollectionReference userPostRef = FirebaseFirestore.instance
      .collection('posts')
      .doc(SignedAccount.instance.id)
      .collection('userPosts');

  Reference storageRef = FirebaseStorage.instance.ref();

  /* ____________________________________ RETRIEVE ____________________________________ */
  Future<void> createPost(String postId,
      {String? imageURL, String? location, String? caption}) async {
    await userPostRef.doc(postId).set({
      'postID': postId,
      'ownerID': SignedAccount.instance.id,
      'username': SignedAccount.instance.username,
      'mediaURL': imageURL,
      'caption': caption,
      'location': location,
      'postTime': DateTime.now(),
      'likes': {},
    });
  }

  getAllPostsOfUser(String userId) async {
    QuerySnapshot<Object> documentSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(userId)
        .collection('userPosts')
        .orderBy('postTime')
        .get();

    return documentSnapshot;
  }

  getUserOfPost(String postId) async {
    QuerySnapshot<Object> documentSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .get();

    documentSnapshot.docs.forEach((document) {
      print(document.data());
    });

    return documentSnapshot;
  }



  Future<DocumentSnapshot> getPostById(String postID, String ownerID) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(ownerID)
        .collection('userPosts')
        .doc(postID).get();

    return documentSnapshot;
  }

  Future<String> getImageOfPost(String postID, String ownerID) async {
      DocumentSnapshot documentSnapshot = await getPostById(postID, ownerID);
      return documentSnapshot['mediaURL'];
  }

/* ____________________________________ UPDATE ____________________________________ */

  updateLike(String postID, String ownerID, bool isLike) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(ownerID)
        .collection('userPosts')
        .doc(postID)
        .update({'likes.${SignedAccount.instance.id}': isLike});
  }

/* ____________________________________ DELETE ____________________________________ */

deletePost(String postID, String ownerID)async{
  await postRef.doc(ownerID).collection('userPosts').doc(postID).get().then((document){
    if(document.exists){
      document.reference.delete();
    }
  });

  storageRef.child('images').child("post_$postID").delete();
}

}
