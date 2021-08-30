import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/singned_account.dart';

class FirebaseFollowerHelper {
  CollectionReference followerCollectionRef =
      FirebaseFirestore.instance.collection('followers');

/* ____________________________________ RETRIEVE ____________________________________ */

  addFollowerToThem({required String theirID,required String myID}) {
    followerCollectionRef
        .doc(theirID)
        .collection('userFollowers')
        .doc(myID)
        .set({});
  }

  Future<QuerySnapshot> getAllFollowers(String myID) async {
    QuerySnapshot querySnapshot = await followerCollectionRef.doc(myID).collection('userFollowers').get();
    return querySnapshot;
  }

/* ____________________________________ UPDATE ____________________________________ */

  deleteFollowerToThem({required String theirID,required String myID}) {
    followerCollectionRef
        .doc(theirID)
        .collection('userFollowers')
        .doc(myID)
        .delete();
  }

}
