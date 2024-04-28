// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/objects/user.dart';

class CustomerRegistrationPage3 extends StatefulWidget {
  final AppUser user; // AppUser object

  CustomerRegistrationPage3({required this.user}); // Constructor

  @override
  _CustomerRegistrationPage3State createState() =>
      _CustomerRegistrationPage3State();
}

class _CustomerRegistrationPage3State extends State<CustomerRegistrationPage3> {
  int selectedFloorTypeIndex =
      -1; // Track the index of the selected house type button
  int selectedStoriesCountIndex =
      -1; // Track the index of the selected bathroom count button
  int selectedSqftCountIndex =
      -1; // Track the index of the selected bedroom count button

  //Controllers
  var floorTypeController = TextEditingController();
  var storiesCountController = TextEditingController();
  var sqftCountController = TextEditingController();

  //Function to handle the next button
  handleSubmit() async {
    if (sqftCountController.text.isEmpty ||
        floorTypeController.text.isEmpty ||
        storiesCountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Please fill in every box, we need it for your account!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // dismisses only the dialog and returns nothing
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    final user = widget.user; // Get the user object from the widget

    user.floorType =
        floorTypeController.text; // Assign the value to the user object
    user.storiesCount =
        storiesCountController.text; // Assign the value to the user object
    user.sqftOfHome = sqftCountController.text;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'There was an error registering your account, please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // dismisses only the dialog and returns nothing
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    user.firstName = user.firstName[0].toUpperCase() +
        user.firstName.substring(1); // Capitalize the first letter

    user.lastName = user.lastName[0].toUpperCase() + user.lastName.substring(1);

    final users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.email).set(user.toMap());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content:
            const Text('You\'ve successfully registered! Welcome to Squeaky!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            const Text(
              "Great! lets just finish up!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            //================================================================================================
            //==========================FLOOR TYPE BUTTONS====================================================
            //================================================================================================
            const Text('What type floors do you have?',
                style: TextStyle(fontSize: 16)),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFloorTypeIndex =
                          0; // Set the index of the selected button
                      floorTypeController.text =
                          'Carpet'; // Assign the value to the controller
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                    'Carpet',
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
                          'Hardwood'; // Assign the value to the controller
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                    'Hardwood',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFloorTypeIndex =
                          2; // Set the index of the selected button
                      floorTypeController.text =
                          'Hardwood and Carpet'; // Assign the value to the controller
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
              ],
            ),
            const SizedBox(height: 25),
            //================================================================================================
            //==========================STORIES COUNT BUTTONS=================================================
            //================================================================================================
            const Text('How many floors do you have?',
                style: TextStyle(fontSize: 16)),
            const Divider(),
            const SizedBox(height: 5),
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
            const SizedBox(height: 25),
            //================================================================================================
            //==========================SQFT COUNT TEXT BOX===================================================
            //================================================================================================
            const Text('How big is your home?', style: TextStyle(fontSize: 16)),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: sqftCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Square footage',
                      suffix: Text('sqft'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            MyButton(
                text: "Register",
                onPressed: handleSubmit,
                color: Colors.blue[300]!),
            const SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  child: const Text('Go Back'),
                  onTap: () => Navigator.pop(context))
            ])
          ],
        ))));
  }
}




//   @override
//   Widget build(BuildContext context) {
//     //Controllers
//     final sqftController = TextEditingController();

//     //Functions
//     void handleNextSubmit() {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text(
//               'You\'ve successfully registered, please log in to continue!'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );
//               },
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//         backgroundColor: Colors.grey[300],
//         body: SafeArea(
//             child: Center(
//                 child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [Colors.blue[300]!, Colors.grey[300]!],
//                         stops: const [0.01, 0.10],
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 25),
//                         const Text(
//                           "Alright, last one!",
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.bold),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Divider(
//                                   thickness: 0.5,
//                                   color: Colors.blue[300],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Text("How many floors do you have?",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               MySelectorButton(
//                                 index: "fl1",
//                                 text: "1",
//                                 onPressed: null,
//                                 color: Colors.blue[300]!,
//                               ),
//                               MySelectorButton(
//                                 index: "fl2",
//                                 text: "2",
//                                 onPressed: null,
//                                 color: Colors.blue[300]!,
//                               ),
//                               MySelectorButton(
//                                 index: "fl3+",
//                                 text: "3+",
//                                 onPressed: null,
//                                 color: Colors.blue[300]!,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         const Text("Carpet or Hardwood floors?",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               MySelectorButton(
//                                 index: "carpet",
//                                 text: "Carpet",
//                                 onPressed: null,
//                                 color: Colors.blue[300]!,
//                               ),
//                               MySelectorButton(
//                                 index: "hardwood",
//                                 text: "Hardwood",
//                                 onPressed: null,
//                                 color: Colors.blue[300]!,
//                               ),
//                               MySelectorButton(
//                                   index: "both",
//                                   text: "Both",
//                                   onPressed: null,
//                                   color: Colors.blue[300]!),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         const Text("How many sqft approximately?",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15, right: 15, top: 5, bottom: 15),
//                           child: TextField(
//                             keyboardType: TextInputType.number,
//                             controller: sqftController,
//                             obscureText: false,
//                             decoration: const InputDecoration(
//                               suffix: Text('sqft',
//                                   style: TextStyle(color: Colors.black),
//                                   textAlign: TextAlign.left),
//                               label: Text('Sqaure footage'),
//                               border: OutlineInputBorder(),
//                               hintText: null,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         MyButton(
//                             text: "Finish",
//                             onPressed: handleNextSubmit,
//                             color: Colors.blue[300]!),
//                         const SizedBox(height: 25),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                   child: const Text('Go Back'),
//                                   onTap: () => Navigator.pop(context))
//                             ])
//                       ],
//                     )))));
//   }
// }
