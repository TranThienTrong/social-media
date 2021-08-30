import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/singned_account.dart';

class FirebaseFollowingHelper {
  CollectionReference followingCollectionRef =
      FirebaseFirestore.instance.collection('following');

/* ____________________________________ RETRIEVE ____________________________________ */

  addFollowingToUs({required String myID, required String theirID}) {
    followingCollectionRef
        .doc(myID)
        .collection('userFollowing')
        .doc(theirID)
        .set({});
  }

  Future<bool> getFollowingStatus(
      {required String myID, required String theirID}) async {
    bool isFollowing = await followingCollectionRef
        .doc(myID)
        .collection('userFollowing')
        .doc(theirID)
        .get()
        .then((document) {
      if (document.exists) {
        return true;
      }
      return false;
    });

    return isFollowing;
  }

  Future<QuerySnapshot> getAllFollowing(String myID) async {
    QuerySnapshot querySnapshot = await followingCollectionRef
        .doc(myID)
        .collection('userFollowing')
        .get();
    print(querySnapshot.docs.length);
    return querySnapshot;
  }

/* ____________________________________ UPDATE ____________________________________ */

  deleteFollowingToUs({required String myID, required String theirID}) {
    followingCollectionRef
        .doc(myID)
        .collection('userFollowing')
        .doc(theirID)
        .delete();
  }
}
