import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/screens/upload_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CraftStatus extends StatefulWidget {
  UploadScreenState uploadScreen;

  CraftStatus(this.uploadScreen);

  @override
  _CraftStatusState createState() => _CraftStatusState();
}

class _CraftStatusState extends State<CraftStatus> {
  File? imageFile;
  ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          padding: EdgeInsets.only(top: 5.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.image),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ))),
            onPressed: selectImage,
            label: Text("Take/Pick image"),
          ),
        ),
        Container(
          width: 200,
          padding: EdgeInsets.only(top: 5.0),
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
              onPressed: getLocation,
              icon: Icon(Icons.my_location),
              label: Text("Use current location")),
        ),
      ],
    );
  }

  Future<dynamic> selectImage() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: [
              SimpleDialogOption(
                child: Text("Open Camera"),
                onPressed: handleCameraPicture,
              ),
              SimpleDialogOption(
                child: Text("Open Gallery"),
                onPressed: handleGalleryPicture,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void handleCameraPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 650, maxWidth: 800);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
        widget.uploadScreen.setImageFile(imageFile);
      });
    }
  }

  void handleGalleryPicture() async {
    Navigator.pop(context);
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
        widget.uploadScreen.setImageFile(imageFile);
      });
    }
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    String address = "${placemark.locality}, ${placemark.country}";

    widget.uploadScreen.setLocation(address);
  }
}
