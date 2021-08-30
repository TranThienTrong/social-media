const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.onCreateFollower = functions.firestore
  .document("followers/{userFollowedId}/userFollowers/{followerId}")
  .onCreate(async (snapshot, contenxt) => {
    const userFollowedId = contenxt.params.userFollowedId;
    const followerId = contenxt.params.followerId;

    console.log("userId ${userId} followerId ${followerId}");

    // 1. Get followed user posts
    const followedUserPost = await db
      .collection("posts")
      .doc(userFollowedId)
      .collection("userPosts")
      .get();

    // 2. Get following user posts
    const timelinePost = db
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts");

    // 3. Add followered Post to follower TimeLine
    followedUserPost.forEach((document) => {
      if (document.exists) {
        const postID = document.id;
        const dataFromPost = document.data();
        timelinePost.doc(postID).set(dataFromPost);
      }
    });
  });

exports.onUnFollower = functions.firestore
  .document("followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (snapshot, contenxt) => {
    const userId = contenxt.params.userId;
    const followerId = contenxt.params.followerId;

    console.log("deleted");
    // 1. Get followed user posts
    const timelinePosts = db
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts")
      .where("ownerID", "==", userId);

    // 2. Delete followered Post from TimeLine

    const querySnapshot = await timelinePosts.get();

    querySnapshot.forEach((doc) => {
      if (doc.exists) {
        console.log("document exist");
        console.log(doc.id);
        console.log(doc.data());
        doc.ref.delete();
      }
    });
  });

exports.onCreatePost = functions.firestore
  .document("posts/{userId}/userPosts/{postId}")
  .onCreate(async (snapshot, contenxt) => {
    const postCreated = snapshot.data();
    const userId = contenxt.params.userId;
    const postId = contenxt.params.postId;

    const querySnapshot = await db
      .collection("followers")
      .doc(userId)
      .collection("userFollowers")
      .get();

    querySnapshot.forEach((document) => {
      const followerId = document.id;
      db.collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .set(postCreated);
    });
  });

exports.onUpdatePost = functions.firestore
  .document("posts/{userId}/userPosts/{postId}")
  .onUpdate(async (change, contenxt) => {
    const postUpdated = change.after.data();
    const userId = contenxt.params.userId;
    const postId = contenxt.params.postId;

    const querySnapshot = await db
      .collection("followers")
      .doc(userId)
      .collection("userFollowers")
      .get();

    querySnapshot.forEach((document) => {
      const followerId = document.id;
      db.collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .get()
        .then((document) => {
          if (document.exists) {
            document.ref.update(postUpdated);
          }
        });
    });
  });

exports.onDeletePost = functions.firestore
  .document("posts/{userId}/userPosts/{postId}")
  .onDelete(async (snapshot, contenxt) => {
    const userId = contenxt.params.userId;
    const postId = contenxt.params.postId;

    const querySnapshot = await db
      .collection("followers")
      .doc(userId)
      .collection("userFollowers")
      .get();

    querySnapshot.forEach((document) => {
      const followerId = document.id;
      db.collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(postId)
        .get()
        .then((document) => {
          if (document.exists) {
            document.ref.delete();
          }
        });
    });
  });

exports.onCreateNotification = functions
  .region("asia-southeast1")
  .firestore.document("notifications/{userId}/postNotifications/{postId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;

    const querySnapshot = await db.doc(`users/${userId}`).get();

    const androidNotificationToken =
      querySnapshot.data().androidNotificationToken;

    if (androidNotificationToken != null) {
      sendNotification(androidNotificationToken, snapshot.data());
    } else {
      console.log("no notification");
    }

    function sendNotification(androidNotifyToken, notificationDocument) {
      let body;
      switch (notificationDocument.type) {
        case "comment":
          body = `${notificationDocument.usernameNotify} comment on your post`;
          break;
        case "like":
          body = `${notificationDocument.usernameNotify} like your post`;
          break;
        case "follow":
          body = `${notificationDocument.usernameNotify} follow you`;
          break;
        default:
          break;
      }

      const message = {
        data: {
          user: JSON.stringify(querySnapshot),
        },

        // notification: { body: body },
        // token: androidNotifyToken,
        // data: { recipient: userId },
      };

      admin
        .messaging()
        .sendToDevice(androidNotificationToken, message)
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    }
  });
