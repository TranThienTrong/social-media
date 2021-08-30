import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/singned_account.dart';

class FirebaseNotificationHelper {
  CollectionReference notifyCollectionReference =
      FirebaseFirestore.instance.collection('notifications');

/* ____________________________________ INSERT ____________________________________ */

  insertPostNotification(
      {required String postID,
      required String ownerID,
      required String notifyType}) {
    notifyCollectionReference
        .doc(ownerID)
        .collection("postNotifications")
        .doc(postID)
        .set({
      'usernameNotify': SignedAccount.instance.username,
      'userNotifyID': SignedAccount.instance.id,
      'postID': postID,
      'postOwnerID': ownerID,
      'type': notifyType,
      'notifyTime': DateTime.now(),
    });
  }

  void insertFollowNotification(
      {required String followerID, required String followingID}) {
    notifyCollectionReference
        .doc(followingID)
        .collection("postNotifications")
        .doc(followerID)
        .set({
      'usernameNotify': SignedAccount.instance.username,
      'userNotifyID': followerID,
      'postID': '',
      'postOwnerID': followingID,
      'type': 'follow',
      'notifyTime': DateTime.now(),
    });
  }

/* ____________________________________ RETRIEVE ____________________________________ */

  getAllNotificationForCurrentUser() async {
    QuerySnapshot querySnapshot = await notifyCollectionReference
        .doc(SignedAccount.instance.id)
        .collection('postNotifications')
        .orderBy('notifyTime', descending: true)
        .get();

    querySnapshot.docs.forEach((document) {
      print(document.data());
    });

    return querySnapshot.docs;
  }

/* ____________________________________ UPDATE ____________________________________ */

/* ____________________________________ DELETE ____________________________________ */
  deleteNotification({
    required String postID,
    required String ownerID,
  }) async {
    await notifyCollectionReference
        .doc(ownerID)
        .collection("postNotifications")
        .doc(postID)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }
}
