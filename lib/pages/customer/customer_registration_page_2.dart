// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/customer/customer_registration_page_3.dart';

class CustomerRegistrationPage2 extends StatefulWidget {
  final AppUser user; // AppUser object

  //Function to handle the next button
  Future<void> handleNextSubmit(houseTypeController, bedroomCountController,
      bathroomCountController) async {
    user.houseType =
        houseTypeController.text; // Assign the value to the user object
    user.amountOfBedrooms =
        bedroomCountController.text; // Assign the value to the user object
    user.amountOfBathrooms = bathroomCountController.text;
  }

  CustomerRegistrationPage2({required this.user}); // Constructor

  @override
  _CustomerRegistrationPage2State createState() =>
      _CustomerRegistrationPage2State();
}

class _CustomerRegistrationPage2State extends State<CustomerRegistrationPage2> {
  int selectedHouseTypeIndex =
      -1; // Track the index of the selected house type button
  int selectedBathroomCountIndex =
      -1; // Track the index of the selected bathroom count button
  int selectedBedroomCountIndex =
      -1; // Track the index of the selected bedroom count button

  //Controllers
  var houseTypeController = TextEditingController();
  var bedroomCountController = TextEditingController();
  var bathroomCountController = TextEditingController();

  //Function to handle the next button
  handleSubmit() {
    widget.handleNextSubmit(
        houseTypeController, bedroomCountController, bathroomCountController);

    if (houseTypeController.text.isEmpty ||
        bedroomCountController.text.isEmpty ||
        bathroomCountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Please make sure you\'ve selected an answer for each, we need it for your account!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // dismisses only the dialog and returns nothing
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerRegistrationPage3(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          "Almost done!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //================================================================================================
                        //==========================HOUSE TYPE BUTTONS====================================================
                        //================================================================================================
                        const Text('What type of home do you have?',
                            style: TextStyle(fontSize: 16)),
                        const Divider(),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedHouseTypeIndex == 0) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedHouseTypeIndex == 1) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedHouseTypeIndex == 2) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text('How many bedrooms do you have?',
                            style: TextStyle(fontSize: 16)),
                        const Divider(),
                        const SizedBox(height: 5),
                        //================================================================================================
                        //==========================BEDROOM COUNT BUTTONS=================================================
                        //================================================================================================
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBedroomCountIndex == 0) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBedroomCountIndex == 1) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                      '3'; // Assign the value to the controller
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBedroomCountIndex == 2) {
                                      return Colors
                                          .grey; // Change the color to grey
                                    }
                                    return Colors.blue[300]!; // Default color
                                  },
                                ),
                              ),
                              child: Text(
                                '3',
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedBedroomCountIndex =
                                      3; // Set the index of the selected button
                                  bedroomCountController.text =
                                      '4+'; // Assign the value to the controller
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBedroomCountIndex == 3) {
                                      return Colors
                                          .grey; // Change the color to grey
                                    }
                                    return Colors.blue[300]!; // Default color
                                  },
                                ),
                              ),
                              child: Text(
                                '4+',
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text('How many bathrooms do you have?',
                            style: TextStyle(fontSize: 16)),
                        const Divider(),
                        const SizedBox(height: 5),
                        //================================================================================================
                        //==========================BATHROOM COUNT BUTTONS================================================
                        //================================================================================================
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBathroomCountIndex == 0) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBathroomCountIndex == 1) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                                    if (states
                                            .contains(MaterialState.pressed) ||
                                        selectedBathroomCountIndex == 2) {
                                      return Colors
                                          .grey; // Change the color to grey
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
                        const SizedBox(height: 25),
                        MyButton(
                            text: "Next",
                            onPressed: handleSubmit,
                            color: Colors.blue[300]!),
                        const SizedBox(height: 25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  child: const Text('Go Back'),
                                  onTap: () => Navigator.pop(context))
                            ])
                      ],
                    ))));
  }
}
