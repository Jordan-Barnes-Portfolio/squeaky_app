// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/util/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final AppUser user;

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Uint8List? _image;

  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
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
                  _image == null
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
                          backgroundImage: MemoryImage(_image!),
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
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(tile.icon),
                    title: Text(tile.title),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: widget.user),
    );
  }
}

class CustomListTile {
  final IconData icon;
  final String title;

  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.insights,
    title: "Appointments",
  ),
  CustomListTile(
    icon: Icons.person,
    title: "Account details",
  ),
  CustomListTile(
    title: "Payment information",
    icon: CupertinoIcons.money_dollar_circle,
  ),
  CustomListTile(
    title: "Legal",
    icon: CupertinoIcons.book_solid,
  ),
  CustomListTile(
    title: "Logout",
    icon: CupertinoIcons.arrow_right_arrow_left,
  ),
];
