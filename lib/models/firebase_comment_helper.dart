import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/singned_account.dart';

class FirebaseCommentHelper {
  CollectionReference commentRef =
      FirebaseFirestore.instance.collection('comments');

  Reference storageReferences = FirebaseStorage.instance.ref();

  FirebasePostHelper firebasePostHelper= new FirebasePostHelper();

/* ____________________________________ RETRIEVE ____________________________________ */

  addComment(String postID, String comment) {

    commentRef.doc(postID).collection('postComments').add({
      'postID': postID,
      'username': SignedAccount.instance.username,
      'userID': SignedAccount.instance.id,
      'comment': comment,
      'commentTime': DateTime.now(),
    });
  }

/* ____________________________________ UPDATE ____________________________________ */

/* ____________________________________ DELETE ____________________________________ */

  deleteAllComment(String postID)async{
      QuerySnapshot querySnapshot = await commentRef.doc(postID).collection('postComments').get();
      querySnapshot.docs.forEach((document) {
        if(document.exists){
          document.reference.delete();
        }
      });
  }

}
