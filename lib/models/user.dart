import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/singned_account.dart';

class User {
  String? _id;
  String? _username;
  String? _email;
  String? _photoUrl;
  String? _displayName;
  String? _bio;
  DateTime? _timeJoined;

  User(
      {required String? id,
      required String? username,
      required String? email,
      required String? photoUrl,
      required String? displayName,
      required String? bio,
      required DateTime? timeJoined}) {
    this._id = id;
    this._username = username;
    this._email = email;
    this._photoUrl = photoUrl;
    this._displayName = displayName;
    this._bio = bio;
    this._timeJoined = timeJoined;
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return User(
        id: documentSnapshot['id'],
        username: documentSnapshot['username'],
        email: documentSnapshot['email'],
        photoUrl: documentSnapshot['photoUrl'],
        displayName: documentSnapshot['displayName'],
        bio: documentSnapshot['bio'],
        timeJoined: documentSnapshot['timeJoined'].toDate());
  }

  factory User.fromSignedinAccount(SignedAccount signedAccount) {
    return User(
        id: signedAccount.id,
        username: signedAccount.username,
        email: signedAccount.email,
        photoUrl: signedAccount.photoUrl,
        displayName: signedAccount.displayName,
        bio: signedAccount.bio,
        timeJoined: signedAccount.timeJoined);
  }



  DateTime? get timeJoined => _timeJoined;

  set timeJoined(DateTime? value) {
    _timeJoined = value;
  }

  String? get bio => _bio;

  set bio(String? value) {
    _bio = value;
  }

  String? get displayName => _displayName;

  set displayName(String? value) {
    _displayName = value;
  }

  String? get photoUrl => _photoUrl;

  set photoUrl(String? value) {
    _photoUrl = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  @override
  String toString() {
    return 'User( id: ${_id}, username: ${_username} email: ${_email} \n '
        'photoUrl: ${photoUrl} displayName: ${displayName} bio: ${bio} \n'
        'timeJoined: ${timeJoined} )';
  }
}
