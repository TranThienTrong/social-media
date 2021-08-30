import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_post_helper.dart';

class FirebaseUserHelper {
  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  /* ____________________________________ RETRIEVE ____________________________________ */

  Future<void> getAllUser() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await userCollectionReference.get();
    // Get data from docs and convert map to List
    querySnapshot.docs.forEach((document) => print(document.data()));
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await userCollectionReference.doc(userId).get();
    return documentSnapshot;
  }

  Future<void> getAdmin() async {
    QuerySnapshot querySnapshot = await userCollectionReference
        .orderBy('postCount', descending: false)
        .where('isAdmin', isEqualTo: false)
        .get();
    querySnapshot.docs.forEach((document) => print(document.data()));
  }

  Future<bool> checkUser(String userId) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await userCollectionReference.doc(userId).get();
    if (documentSnapshot.exists) {
      return true;
    }
    return false;
  }

  Future<QuerySnapshot<Object?>> getUserByDisplayName(
      String displayName) async {
    QuerySnapshot<Object?> documentSnapshot = await userCollectionReference
        .where('displayName', isEqualTo: displayName)
        .get();

    return documentSnapshot;
  }

  Future<String> getImageOfUser(String userID) async {
    QuerySnapshot querySnapshot =  await userCollectionReference.where('id', isEqualTo: userID).get();

    return querySnapshot.docs.first['photoUrl'];
  }

  /* ____________________________________ INSERT ____________________________________ */

  Future<void> insertUser() {
    return userCollectionReference
        .add({'isAdmin': false, 'username': 'alex', 'postCount': 0})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> insertUserWithId(String userId, String username, bool isAdmin) {
    return userCollectionReference
        .doc(userId)
        .set({'isAdmin': isAdmin, 'username': username, 'postCount': 0})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  /* ____________________________________ UPDATE ____________________________________ */

  Future<void> updateUser(String userId, String newUsername) {
    return userCollectionReference
        .doc(userId)
        .update({'username': newUsername})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  /* ____________________________________ DELETE ____________________________________ */

  Future<void> deleteUser(String userId) {
    return userCollectionReference
        .doc(userId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
