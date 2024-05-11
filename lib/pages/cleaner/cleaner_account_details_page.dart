// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, body_might_complete_normally_catch_error
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_drop_down_field.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/components/my_large_text_field.dart';
import 'package:squeaky_app/components/my_number_field.dart';
import 'package:squeaky_app/components/my_text_field.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/util/utils.dart';

class CleanerAccountDetailsPage extends StatefulWidget {
  const CleanerAccountDetailsPage({super.key, required this.user});
  final AppUser user;

  @override
  _CleanerAccountDetailsPage createState() => _CleanerAccountDetailsPage();
}

class _CleanerAccountDetailsPage extends State<CleanerAccountDetailsPage> {
  var addressController = TextEditingController();
  var address2Controller = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipCodeController = TextEditingController();
  var emailController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var pphController = TextEditingController();
  var bioController = TextEditingController();
  var skillsController = TextEditingController();

  void selectProfileImage() async {
    try {
      String image = await pickImage(ImageSource.gallery);
      var imageFile = File(image);

      FirebaseStorage storage = FirebaseStorage.instance;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .get();
      Reference ref =
          storage.ref().child("images/${widget.user.uuid.replaceAll('-', '')}");
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

  void selectHeroImage() async {
    try {
      String heroImage = await pickHeroImage(ImageSource.gallery);
      var imageFileHero = File(heroImage);

      FirebaseStorage storage = FirebaseStorage.instance;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .get();
      Reference ref = storage
          .ref()
          .child("/images/${widget.user.uuid.replaceAll('-', '')}hero");
      UploadTask uploadTask = ref.putFile(imageFileHero);
      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();

        widget.user.heroPhoto = url.toString();
        await userRef.then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(element.id)
                .update({
              'heroPhoto': url.toString(),
            });
          }
        });
        setState(() {});
      }).catchError((onError) async {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //================================================================================================
    // Function to change the user's email
    //================================================================================================

    emailChange() async {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          shadowColor: Colors.black12,
          elevation: 5,
          surfaceTintColor: Colors.transparent,
          title: Text('Update email address', textAlign: TextAlign.center),
          actions: [
            Text(
                'Unfortunatly, you cannot change your email address at this time.. we are working on a fix.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red)),
            // MyTextField(
            //   controller: emailController,
            //   hintText: 'Enter your new email',
            //   obscureText: false,
            //   label: 'email',
            // ),
            // MyButton(
            //   text: "Save",
            //   color: Colors.blue[300]!,
            //   onPressed: () {
            //     FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(emailController.text); // Update the email in Firebase

            //     final userRef = FirebaseFirestore.instance
            //         .collection('users')
            //         .where('email', isEqualTo: widget.user.email)
            //         .get();
            //     userRef.then((value) {
            //       for (var element in value.docs) {
            //         FirebaseFirestore.instance
            //             .collection('users')
            //             .doc(element.id)
            //             .update({
            //           'email': widget.user.email,
            //         });
            //       }
            //     });
            //     setState(() {});
            //   },
            // ),
          ],
        ),
      );
    }

    //================================================================================================
    // Function to change the user's name
    //================================================================================================

    nameChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Enter your updated information..',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              const Divider(),
              MyTextField(
                controller: firstNameController,
                hintText: widget.user.firstName,
                obscureText: false,
                label: 'First name',
              ),
              MyTextField(
                controller: lastNameController,
                hintText: widget.user.lastName,
                obscureText: false,
                label: 'Last name',
              ),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  // save new name

                  if (firstNameController.text.isNotEmpty) {
                    firstNameController.text =
                        firstNameController.text[0].toUpperCase() +
                            firstNameController.text.substring(1);
                  }

                  if (lastNameController.text.isNotEmpty) {
                    lastNameController.text =
                        lastNameController.text[0].toUpperCase() +
                            lastNameController.text.substring(1);
                  }

                  if (firstNameController.text.isNotEmpty &&
                      lastNameController.text.isNotEmpty) {
                    widget.user.firstName = firstNameController.text;
                    widget.user.lastName = lastNameController.text;
                  } else if (firstNameController.text.isNotEmpty &&
                      lastNameController.text.isEmpty) {
                    widget.user.firstName = firstNameController.text;
                  } else if (firstNameController.text.isEmpty &&
                      lastNameController.text.isNotEmpty) {
                    widget.user.lastName = lastNameController.text;
                  }

                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.user.email)
                      .get();
                  userRef.then((value) {
                    for (var element in value.docs) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .update({
                        'firstName': widget.user.firstName,
                        'lastName': widget.user.lastName,
                      });
                    }
                  });
                  setState(() {
                    firstNameController.clear();
                    lastNameController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    //================================================================================================
    // Function to change the user's address
    //================================================================================================

    addressChange() async {
      showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        context: context,
        builder: (context) => Scaffold(
          backgroundColor: Colors.grey[200],
          body: Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text('Enter your updated information..',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  const Divider(),
                  MyTextField(
                    controller: addressController,
                    hintText: 'Address line 1',
                    obscureText: false,
                    label: 'Address',
                  ),
                  MyTextField(
                    controller: address2Controller,
                    hintText: 'Address line 2 (optional)',
                    obscureText: false,
                    label: "Address Line 2",
                  ),
                  MyTextField(
                    controller: cityController,
                    hintText: 'City',
                    obscureText: false,
                    label: "City",
                  ),
                  MyDropDownField(
                    controller: stateController,
                    hintText: 'State',
                    obscureText: false,
                    label: "State",
                    options: const <String>[
                      'AL',
                      'AK',
                      'AZ',
                      'AR',
                      'CA',
                      'CO',
                      'CT',
                      'DE',
                      'FL',
                      'GA',
                      'HI',
                      'ID',
                      'IL',
                      'IN',
                      'IA',
                      'KS',
                      'KY',
                      'LA',
                      'ME',
                      'MD',
                      'MA',
                      'MI',
                      'MN',
                      'MS',
                      'MO',
                      'MT',
                      'NE',
                      'NV',
                      'NH',
                      'NJ',
                      'NM',
                      'NY',
                      'NC',
                      'ND',
                      'OH',
                      'OK',
                      'OR',
                      'PA',
                      'RI',
                      'SC',
                      'SD',
                      'TN',
                      'TX',
                      'UT',
                      'VT',
                      'VA',
                      'WA',
                      'WV',
                      'WI',
                      'WY'
                    ],
                  ),
                  MyNumberField(
                    controller: zipCodeController,
                    hintText: 'Zip Code',
                    obscureText: false,
                    label: "Zip Code",
                  ),
                  MyButton(
                    text: "Save",
                    color: Colors.blue[300]!,
                    onPressed: () {
                      // save address
                      if (addressController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          stateController.text.isEmpty ||
                          zipCodeController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  surfaceTintColor: Colors.transparent,
                                  shadowColor: Colors.black12,
                                  backgroundColor: Colors.grey[200],
                                  title: const Text('Error'),
                                  content:
                                      const Text('Please fill out all fields.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                )); // If any of the fields are empty,
                        return;
                      }

                      if (address2Controller.text.isNotEmpty) {
                        widget.user.address =
                            '${addressController.text} ${address2Controller.text} ${cityController.text}, ${stateController.text} ${zipCodeController.text}';
                      } else {
                        widget.user.address =
                            '${addressController.text} ${cityController.text}, ${stateController.text} ${zipCodeController.text}';
                      }
                      final userRef = FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.user.email)
                          .get();
                      userRef.then((value) {
                        for (var element in value.docs) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(element.id)
                              .update({
                            'address': widget.user.address,
                          });
                        }
                      });
                      setState(() {
                        addressController.clear();
                        address2Controller.clear();
                        cityController.clear();
                        stateController.clear();
                        zipCodeController.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    //================================================================================================
    // Function to change the user's pricing
    //================================================================================================

    pphChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Enter your updated information..',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 15),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: pphController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    suffix: Text('\$/hr',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.left),
                    label: Text('Price per hour'),
                    border: OutlineInputBorder(),
                    hintText: 'Price per hour in \$',
                  ),
                ),
              ),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  if (pphController.text.isNotEmpty) {
                    widget.user.pricing = double.parse(pphController.text);
                  }
                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.user.email)
                      .get();
                  userRef.then((value) {
                    for (var element in value.docs) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .update({
                        'pricing': widget.user.pricing,
                      });
                    }
                  });
                  setState(() {
                    pphController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    //================================================================================================
    // Function to change the user's bio
    //================================================================================================

    bioChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Enter your updated bio..',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              const Divider(),
              MyLargeTextField(
                controller: bioController,
                hintText: widget.user.bio,
                obscureText: false,
              ),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  if (bioController.text.isNotEmpty) {
                    widget.user.bio = bioController.text;
                  }
                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.user.email)
                      .get();
                  userRef.then((value) {
                    for (var element in value.docs) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .update({
                        'bio': widget.user.bio,
                      });
                    }
                  });
                  setState(() {
                    bioController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    //================================================================================================
    // Function to change the user's bio
    //================================================================================================

    skillsChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Enter your updated skills..',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              const Divider(),
              MyLargeTextField(
                controller: skillsController,
                hintText: widget.user.skills,
                obscureText: false,
              ),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  if (skillsController.text.isNotEmpty) {
                    widget.user.skills = skillsController.text;
                  }
                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.user.email)
                      .get();
                  userRef.then((value) {
                    for (var element in value.docs) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .update({
                        'skills': widget.user.skills,
                      });
                    }
                  });
                  setState(() {
                    skillsController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    //================================================================================================
    // Scaffold
    //================================================================================================

    return RefreshIndicator(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Additional Details'),
            backgroundColor: Colors.grey[100],
            shadowColor: Colors.black,
            surfaceTintColor: Colors.transparent,
            elevation: 5,
          ),
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                topBarForCleaner(),
                const SizedBox(height: 10),
                mainInfoWidget(
                    emailChange: emailChange,
                    addressChange: addressChange,
                    nameChange: nameChange,
                    pphChange: pphChange,
                    bioChange: bioChange,
                    skillsChange: skillsChange),
              ],
            ),
          ),
          bottomNavigationBar:
              MyGnavBar(currentPageIndex: 2, user: widget.user),
        ),
        onRefresh: () async {
          setState(() {});
        });
  }

  Widget mainInfoWidget(
      {required Function emailChange,
      required Function addressChange,
      required Function nameChange,
      required Function pphChange,
      required Function bioChange,
      required Function skillsChange}) {
    return Column(
      children: [
        Text('Tap to edit any details...',
            style: TextStyle(color: Colors.grey[600])),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
            onTap: () {
              emailChange();
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
              addressChange();
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
              nameChange();
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.person_2),
                title: Text(
                    "Full name: ${widget.user.firstName} ${widget.user.lastName}"),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
            onTap: () {
              pphChange();
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.person_2),
                title: Text(
                    "Estimated price per hour: ${widget.user.pricing} /hr"),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
            onTap: () {
              bioChange();
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.person_2),
                title: Text(
                  "Bio: ${widget.user.bio}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
            onTap: () {
              skillsChange();
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.person_2),
                title: Text("Skills: ${widget.user.skills}",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget topBarForCleaner() {
    return SizedBox(
      height: 325,
      width: double.infinity,
      child: Stack(
        children: [
          GestureDetector(
            onTap: selectHeroImage,
            child: Hero(
              tag: 'cleanerHeroImage',
              child: widget.user.heroPhoto == "none"
                  ? Image.asset(
                      'lib/assets/defaultHero.jpg',
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    )
                  : Image.network(
                      widget.user.heroPhoto,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            child: widget.user.profilePhoto == "none"
                ? const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: 50,
                      color: Colors.black,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      selectProfileImage();
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.user.profilePhoto),
                    )),
          ),
          Positioned(
            bottom: 0,
            left: 110,
            child: Icon(
              Icons.star,
              color: Colors.yellow[700],
              size: 20,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 134,
            child: Text(
              widget.user.rating.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 163,
            child: Text(
              '.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 175,
            child: Text(
              '${widget.user.ratings} reviews',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 130,
            child: Text(
              '${widget.user.firstName} ${widget.user.lastName[0]}.',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 245,
            bottom: 22,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '\$${widget.user.pricing}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' per hour',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.camera_fill,
                size: 35,
                color: Colors.black,
              ),
              onPressed: selectHeroImage,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 77,
            child: InkWell(
              onTap: selectProfileImage,
              child: const Icon(
                CupertinoIcons.camera_fill,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
