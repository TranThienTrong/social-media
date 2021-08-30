import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/singned_account.dart';

class FirebaseTimelineHelper {
  CollectionReference timelineRef =
      FirebaseFirestore.instance.collection('timeline');

  getAllPost() async {
    return await timelineRef
        .doc(SignedAccount.instance.id)
        .collection('timelinePosts')
        .orderBy('postTime', descending: true)
        .get();
  }
}
