// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, body_might_complete_normally_catch_error, avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/cleaner/cleaner_account_details_page.dart';
import 'package:squeaky_app/pages/customer/customer_account_details_page.dart';
import 'package:squeaky_app/services/authentication_gate.dart';
import 'package:squeaky_app/services/authentication_service.dart';
import 'package:squeaky_app/util/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final AppUser user;

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  void selectImage() async {
    try {
      String image = await pickImage(ImageSource.gallery);
      var imageFile = File(image);

      FirebaseStorage storage = FirebaseStorage.instance;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .get();
      Reference ref = storage.ref().child("images/${widget.user.hashCode}");
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();
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
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: const Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: Icon(Icons.insights),
                  title: Text("Past appointments"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.user.isCleaner
                        ? CleanerAccountDetailsPage(user: widget.user)
                        : CustomerAccountDetailsPage(user: widget.user)
                  ),
                );
              },
              child: const Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account Details"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PaymentDetailsPage(user: widget.user)
                //   ),
                // );
              },
              child: const Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.money_dollar_circle,
                  ),
                  title: Text("Payment Information"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LegalPage(user: widget.user)
                //   ),
                // );
              },
              child: const Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: Icon(CupertinoIcons.book_solid),
                  title: Text("Legal"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                AuthenticationService().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const AuthenticationGate()),
                    (route) => false);
              },
              child: const Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: Icon(CupertinoIcons.arrow_right_arrow_left),
                  title: Text("Logout"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: widget.user),
    );
  }
}
