import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imagePackage;
import 'package:social_media/models/firebase_post_helper.dart';
import 'package:social_media/models/singned_account.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/widgets/craft_status.dart';
import 'package:social_media/widgets/header.dart';
import 'package:social_media/widgets/progress.dart';
import 'package:social_media/widgets/user_searched_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> with AutomaticKeepAliveClientMixin<UploadScreen> {
  @override
  void initState() {
    super.initState();
  }

  File? imageFile;
  bool isUploading = false;
  String postID = new Uuid().v4();
  FirebasePostHelper firebasePostHelper = new FirebasePostHelper();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  setImageFile(File? imageFile) {
    setState(() {
      this.imageFile = imageFile;
    });
  }

  setLocation(String location) {
    setState(() {
      this.locationController.text = location;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: (){},
        ),
        title: Text("Caption Post", style: TextStyle(fontSize: 15)),
        actions: [
          TextButton(
              onPressed: isUploading == false ? handleUploading: null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(1.0)),
              ),
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.lightBlue, fontWeight: FontWeight.normal),
              ))
        ],
      ),
      body: ListView(
        children: [
          if (isUploading) LinearProgress(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundImage: NetworkImage(SignedAccount.instance.photoUrl!),
            ),
            title: Text(
              SignedAccount.instance.displayName!,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: DropdownButton<String>(
              items:
                  <String>['Friend', 'Public', 'Private'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            width: 250.0,
            child: TextField(
              controller: captionController,
              minLines: 5,
              maxLines: 50,
              decoration: InputDecoration(
                  hintText: "What are you thinking", border: InputBorder.none),
            ),
          ),
          Divider(),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  child: imageFile != null
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(imageFile!),
                            ),
                          ),
                        )
                      : Container(
                          child: SvgPicture.asset(
                            'assets/images/upload.svg',
                            height: 260,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pin_drop, color: Colors.orange, size: 25),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    hintText: "Check in", border: InputBorder.none),
              ),
            ),
          ),
          CraftStatus(this),
        ],
      ),
    );
  }

  /* _________________________________________ BUTTON FUNCTION _________________________________________ */

  handleUploading() async {
    print('handleUploading');
    setState(() {
      isUploading = true;
    });
    compressImage();
    String imageURL = await uploadImage(imageFile!);
    await firebasePostHelper.createPost(postID,
        imageURL: imageURL,
        location: locationController.text,
        caption: captionController.text);

    setState(() {
      captionController.clear();
      locationController.clear();
      imageFile =null;
      isUploading = false;
    });

  }

  Future<String> uploadImage(File imageFile) async {
    Reference storageReferences = FirebaseStorage.instance.ref();
    UploadTask uploadTask = storageReferences.child('images').child("post_$postID").putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    print('handleUploading');
    return imageURL;
  }

  compressImage() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempDirPath = tempDir.path;

    imagePackage.Image decodedImage =
        imagePackage.decodeImage(imageFile!.readAsBytesSync())!;
    final compresssedImage = File("${tempDirPath}/img_${postID}")
      ..writeAsBytesSync(imagePackage.encodeJpg(decodedImage, quality: 100));

    setState(() {
      imageFile = compresssedImage;
      print('compressImage');
    });
  }

  @override
  bool get wantKeepAlive => true;
}
