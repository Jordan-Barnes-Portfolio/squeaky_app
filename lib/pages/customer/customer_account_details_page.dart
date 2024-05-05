// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, body_might_complete_normally_catch_error, avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_drop_down_field.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/components/my_number_field.dart';
import 'package:squeaky_app/components/my_text_field.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/util/utils.dart';

class CustomerAccountDetailsPage extends StatefulWidget {
  const CustomerAccountDetailsPage({super.key, required this.user});
  final AppUser user;

  @override
  _CustomerAccountDetailsPage createState() => _CustomerAccountDetailsPage();
}

class _CustomerAccountDetailsPage extends State<CustomerAccountDetailsPage> {
  int selectedHouseTypeIndex =
      -1; // Track the index of the selected house type button
  int selectedBathroomCountIndex =
      -1; // Track the index of the selected bathroom count button
  int selectedBedroomCountIndex =
      -1; // Track the index of the selected bedroom count button
  int selectedStoriesCountIndex =
      -1; // Track the index of the selected stories count button
  int selectedFloorTypeIndex =
      -1; // Track the index of the selected floor type button

  var bathroomCountController = TextEditingController();
  var bedroomCountController = TextEditingController();
  var storiesCountController = TextEditingController();
  var sqftOfHomeController = TextEditingController();
  var houseTypeController = TextEditingController();
  var addressController = TextEditingController();
  var address2Controller = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipCodeController = TextEditingController();
  var emailController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var floorTypeController = TextEditingController();

  void selectImage() async {
    try {
      String image = await pickImage(ImageSource.gallery);
      var imageFile = File(image);

      FirebaseStorage storage = FirebaseStorage.instance;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .get();
      Reference ref = storage.ref().child("images/${widget.user.uuid.replaceAll('-', '')}");
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
    // Function to set the amount of bathrooms in the user's home
    //================================================================================================

    bathroomChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text('Select updated bathroom count..',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBathroomCountIndex =
                              0; // Set the index of the selected button
                          bathroomCountController.text =
                              '1'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBathroomCountIndex == 0) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBathroomCountIndex =
                              1; // Set the index of the selected button
                          bathroomCountController.text =
                              '2'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBathroomCountIndex == 1) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBathroomCountIndex =
                              2; // Set the index of the selected button
                          bathroomCountController.text =
                              '3+'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBathroomCountIndex == 2) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '3+',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyButton(
                  text: "Save",
                  color: Colors.blue[300]!,
                  onPressed: () {
                    //save new bathroom count
                    if (bathroomCountController.text.isNotEmpty) {
                      widget.user.amountOfBathrooms =
                          bathroomCountController.text;
                      setState(() {});
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
                          'amountOfBathrooms': widget.user.amountOfBathrooms,
                        });
                      }
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
      setState(() {
        bathroomCountController.clear();
        selectedBathroomCountIndex = -1;
      });
    }

    //================================================================================================
    // Function to set the amount of bedrooms in the user's home
    //================================================================================================

    bedroomChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text('Select updated bedroom count..',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBedroomCountIndex =
                              0; // Set the index of the selected button
                          bedroomCountController.text =
                              '1'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBedroomCountIndex == 0) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBedroomCountIndex =
                              1; // Set the index of the selected button
                          bedroomCountController.text =
                              '2'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBedroomCountIndex == 1) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBedroomCountIndex =
                              2; // Set the index of the selected button
                          bedroomCountController.text =
                              '3+'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedBedroomCountIndex == 2) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '3+',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyButton(
                  text: "Save",
                  color: Colors.blue[300]!,
                  onPressed: () {
                    if (bedroomCountController.text.isNotEmpty) {
                      widget.user.amountOfBedrooms =
                          bedroomCountController.text;
                    }
                    //save new bedroom count
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
                          'amountOfBedrooms': widget.user.amountOfBedrooms,
                        });
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
      setState(() {
        bedroomCountController.clear();
        selectedBedroomCountIndex = -1;
      });
    }

    //================================================================================================
    // Function to set the amount of floors in the user's home
    //================================================================================================

    amountOfFloorsChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text('Select updated stories count..',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedStoriesCountIndex =
                              0; // Set the index of the selected button
                          storiesCountController.text =
                              '1'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedStoriesCountIndex == 0) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.grey[200]!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedStoriesCountIndex =
                              1; // Set the index of the selected button
                          storiesCountController.text =
                              '2'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedStoriesCountIndex == 1) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedStoriesCountIndex =
                              2; // Set the index of the selected button
                          storiesCountController.text =
                              '3'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedStoriesCountIndex == 2) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        '3+',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyButton(
                  text: "Save",
                  color: Colors.blue[300]!,
                  onPressed: () {
                    if (storiesCountController.text.isNotEmpty) {
                      widget.user.storiesCount = storiesCountController.text;
                    }
                    //save new stories count
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
                          'storiesCount': widget.user.storiesCount,
                        });
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );

      setState(() {
        storiesCountController.clear();
        selectedStoriesCountIndex = -1;
      });
    }

    //================================================================================================
    // Function to set the size of the user's home
    //================================================================================================

    sqftChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Enter your updated square footage..',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              const Divider(),
              TextField(
                controller: sqftOfHomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Square footage',
                  suffix: Text('sqft'),
                ),
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  if (sqftOfHomeController.text.isNotEmpty) {
                    widget.user.sqftOfHome = sqftOfHomeController.text;
                  }
                  //save new sqft size
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
                        'sqftOfHome': widget.user.sqftOfHome,
                      });
                    }
                  });
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
      sqftOfHomeController.clear();
    }

    //================================================================================================
    // Function to set the type of the user's home
    //================================================================================================

    typeOfHomeChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text('Select updated house type..',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedHouseTypeIndex =
                              0; // Set the index of the selected button
                          houseTypeController.text =
                              'Apartment'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedHouseTypeIndex == 0) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        'Apartment',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedHouseTypeIndex =
                              1; // Set the index of the selected button
                          houseTypeController.text =
                              'Townhome'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedHouseTypeIndex == 1) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        'Townhome',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedHouseTypeIndex =
                            2; // Set the index of the selected button
                        houseTypeController.text =
                            'House'; // Assign the value to the controller
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              selectedHouseTypeIndex == 2) {
                            return Colors.grey; // Change the color to grey
                          }
                          return Colors.blue[300]!; // Default color
                        },
                      ),
                    ),
                    child: Text(
                      'House',
                      style: TextStyle(color: Colors.grey[200]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    text: "Save",
                    color: Colors.blue[300]!,
                    onPressed: () {
                      if (houseTypeController.text.isNotEmpty) {
                        widget.user.houseType = houseTypeController.text;
                      }
                      //save new house type
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
                            'houseType': widget.user.houseType,
                          });
                        }
                      });
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ]),
          ),
        ),
      );

      setState(() {
        houseTypeController.clear();
        selectedHouseTypeIndex = -1;
      });
    }

    //================================================================================================
    // Function to set the type of the user's floor
    //================================================================================================

    typeOfFloorChange() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text('Select updated floor type..',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFloorTypeIndex =
                              0; // Set the index of the selected button
                          floorTypeController.text =
                              'Hardwood'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedFloorTypeIndex == 0) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        'Hardwood',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFloorTypeIndex =
                              1; // Set the index of the selected button
                          floorTypeController.text =
                              'Carpet'; // Assign the value to the controller
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                selectedFloorTypeIndex == 1) {
                              return Colors.grey; // Change the color to grey
                            }
                            return Colors.blue[300]!; // Default color
                          },
                        ),
                      ),
                      child: Text(
                        'Carpet',
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFloorTypeIndex =
                            2; // Set the index of the selected button
                        floorTypeController.text =
                            'Both'; // Assign the value to the controller
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              selectedFloorTypeIndex == 2) {
                            return Colors.grey; // Change the color to grey
                          }
                          return Colors.blue[300]!; // Default color
                        },
                      ),
                    ),
                    child: Text(
                      'Both',
                      style: TextStyle(color: Colors.grey[200]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    text: "Save",
                    color: Colors.blue[300]!,
                    onPressed: () {
                      if (floorTypeController.text.isNotEmpty) {
                        widget.user.floorType = floorTypeController.text;
                      }
                      //save new house type
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
                            'floorType': widget.user.floorType,
                          });
                        }
                      });
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ]),
          ),
        ),
      );

      setState(() {
        floorTypeController.clear();
        selectedFloorTypeIndex = -1;
      });
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
                    bedroomChange();
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    surfaceTintColor: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.bedroom_parent),
                      title:
                          Text("# Bedrooms: ${widget.user.amountOfBedrooms}"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () {
                    bathroomChange();
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    surfaceTintColor: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.bathroom),
                      title:
                          Text("# Bathrooms: ${widget.user.amountOfBathrooms}"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () {
                    amountOfFloorsChange();
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    surfaceTintColor: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.house_siding),
                      title:
                          Text("Amount of floors: ${widget.user.storiesCount}"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () {
                    sqftChange();
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    surfaceTintColor: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(Icons.landscape),
                      title:
                          Text("Size of home: ${widget.user.sqftOfHome} sqft"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () {
                    typeOfHomeChange();
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
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  onTap: () {
                    typeOfFloorChange();
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    surfaceTintColor: Colors.transparent,
                    child: ListTile(
                      leading: const Icon(CupertinoIcons.wrench_fill),
                      title: Text("Floor type: ${widget.user.floorType}"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
          bottomNavigationBar:
              MyGnavBar(currentPageIndex: 2, user: widget.user),
        ),
        onRefresh: () async {
          setState(() {});
        });
  }
}
