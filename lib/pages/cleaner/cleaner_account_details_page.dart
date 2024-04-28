// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, body_might_complete_normally_catch_error
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/util/utils.dart';

class CleanerAccountDetailsPage extends StatefulWidget {
  const CleanerAccountDetailsPage({super.key, required this.user});
  final AppUser user;

  @override
  _CleanerAccountDetailsPage createState() => _CleanerAccountDetailsPage();
}

class _CleanerAccountDetailsPage extends State<CleanerAccountDetailsPage> {
  void selectImage() async {
    try {
      String image = await pickImage(ImageSource.gallery);
      var imageFile = File(image);

      FirebaseStorage storage = FirebaseStorage.instance;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .get();
      Reference ref = storage.ref().child("images/${widget.user.email}");
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();
        if(widget.user.profilePhoto != "none"){
          await FirebaseStorage.instance.refFromURL(widget.user.profilePhoto).delete();
        }
        widget.user.profilePhoto = url.toString();
        await userRef.then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(element.id)
                .update({
              'profilePhoto': url.toString(),
            });
          }
        });
        setState(() {});
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(user: widget.user),
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  widget.user.profilePhoto == "none"
                      ? const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          child: Icon(
                            Icons.person_2_outlined,
                            size: 50,
                            color: Colors.black,
                          ),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(widget.user.profilePhoto),
                        ),
                  Positioned(
                    bottom: -15,
                    right: -5,
                    child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                        ),
                        onPressed: selectImage,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.user.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: widget.user),
    );
  }
}
