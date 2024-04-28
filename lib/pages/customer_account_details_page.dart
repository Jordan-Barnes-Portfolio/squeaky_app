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
import 'package:squeaky_app/util/utils.dart';

class CustomerAccountDetailsPage extends StatefulWidget {
  const CustomerAccountDetailsPage({super.key, required this.user});
  final AppUser user;

  @override
  _CustomerAccountDetailsPage createState() => _CustomerAccountDetailsPage();
}

class _CustomerAccountDetailsPage extends State<CustomerAccountDetailsPage> {
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
          const SizedBox(height: 20),
          Text('Tap to edit any details...', style: TextStyle(color: Colors.grey[600])),
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
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text("Email: ${widget.user.email}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(CupertinoIcons.location_fill),
                  title: Text("Address: ${widget.user.address}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: Text("Full name: ${widget.user.firstName} ${widget.user.lastName}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.bedroom_parent),
                  title: Text("# Bedrooms: ${widget.user.amountOfBedrooms}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.bathroom),
                  title: Text("# Bathrooms: ${widget.user.amountOfBathrooms}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.house_siding),
                  title: Text("Amount of floors: ${widget.user.storiesCount}"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.landscape),
                  title: Text("Size of home: ${widget.user.sqftOfHome} sqft"),
                  trailing: const Icon(Icons.chevron_right),
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
                //     builder: (context) => widget.user.isCleaner
                //         ? CustomerAppointmentsPage(user: widget.user)
                //         : CleanerAppointmentsPage(user: widget.user)
                //   ),
                // );
              },
              child: Card(
                elevation: 5,
                shadowColor: Colors.black12,
                surfaceTintColor: Colors.transparent,
                child: ListTile(
                  leading: const Icon(CupertinoIcons.house_fill),
                  title: Text("House type: ${widget.user.houseType}"),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
      bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: widget.user),
    );
  }
}
