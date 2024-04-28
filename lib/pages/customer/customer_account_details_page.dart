// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, body_might_complete_normally_catch_error, avoid_print
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeaky_app/components/my_appbar.dart';
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
    
    //================================================================================================
    // Function to change the user's email
    //================================================================================================

    emailChange() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shadowColor: Colors.black12,
          elevation: 5,
          surfaceTintColor: Colors.transparent,
          title:
              const Text('Update email address', textAlign: TextAlign.center),
          actions: [
            MyTextField(
              controller: TextEditingController(text: widget.user.email),
              hintText: 'Enter your new email',
              obscureText: false,
              label: 'email',
            ),
            MyButton(
              text: "Save",
              color: Colors.blue[300]!,
              onPressed: () {
                // save new email
              },
            ),
          ],
        ),
      );
    }

    //================================================================================================
    // Function to change the user's name
    //================================================================================================

    nameChange() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shadowColor: Colors.black12,
          elevation: 5,
          surfaceTintColor: Colors.transparent,
          title: const Text('Update your name', textAlign: TextAlign.center),
          actions: [
            MyTextField(
              controller: TextEditingController(text: widget.user.firstName),
              hintText: 'Enter your first name',
              obscureText: false,
              label: 'First name',
            ),
            MyTextField(
              controller: TextEditingController(text: widget.user.lastName),
              hintText: 'Enter your last name',
              obscureText: false,
              label: 'Last name',
            ),
            MyButton(
              text: "Save",
              color: Colors.blue[300]!,
              onPressed: () {
                // save new name
              },
            ),
          ],
        ),
      );
    }

    //================================================================================================
    // Function to change the user's address
    //================================================================================================

    addressChange() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shadowColor: Colors.black12,
          elevation: 5,
          surfaceTintColor: Colors.transparent,
          title: const Text('Update address', textAlign: TextAlign.center),
          actions: [
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
            Expanded(
              child: MyTextField(
                controller: cityController,
                hintText: 'City',
                obscureText: false,
                label: "City",
              ),
            ),
            Expanded(
              child: MyDropDownField(
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
            ),
            Expanded(
              child: MyNumberField(
                controller: zipCodeController,
                hintText: 'Zip Code',
                obscureText: false,
                label: "Zip Code",
              ),
            ),
            MyButton(
              text: "Save",
              color: Colors.blue[300]!,
              onPressed: () {
                // save address
              },
            ),
          ],
        ),
      );

      addressController.clear();
      address2Controller.clear();
      cityController.clear();
      stateController.clear();
      zipCodeController.clear();
    }

    //================================================================================================
    // Function to set the amount of bathrooms in the user's home
    //================================================================================================

    bathroomChange() async {
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shadowColor: Colors.black12,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            title:
                const Text('Update # bathrooms', textAlign: TextAlign.center),
            actions: [
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                  // save new email
                },
              ),
            ],
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
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shadowColor: Colors.black12,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            title: const Text('Update # bedrooms', textAlign: TextAlign.center),
            actions: [
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                  // save new email
                },
              ),
            ],
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
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shadowColor: Colors.black12,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            title:
                const Text('Update # of floors', textAlign: TextAlign.center),
            actions: [
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                  // save new email
                },
              ),
            ],
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shadowColor: Colors.black12,
          elevation: 5,
          surfaceTintColor: Colors.transparent,
          title: const Text('Update sqft of home', textAlign: TextAlign.center),
          actions: [
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
                // save new email
              },
            ),
          ],
        ),
      );
      sqftOfHomeController.clear();
    }

    //================================================================================================
    // Function to set the type of the user's home
    //================================================================================================

    typeOfHomeChange() async {
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shadowColor: Colors.black12,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            title: const Text('Update house type', textAlign: TextAlign.center),
            actions: [
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
              ]),
              const SizedBox(height: 10),
              MyButton(
                text: "Save",
                color: Colors.blue[300]!,
                onPressed: () {
                  // save new email
                },
              ),
            ],
          ),
        ),
      );

      setState(() {
        houseTypeController.clear();
        selectedHouseTypeIndex = -1;
      });
    }


    //================================================================================================
    // Scaffold
    //================================================================================================

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
                bathroomChange();
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
                amountOfFloorsChange();
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
                sqftChange();
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
          const SizedBox(height: 35),
        ],
      ),
      bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: widget.user),
    );
  }
}