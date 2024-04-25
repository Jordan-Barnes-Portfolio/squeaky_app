// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_text_field.dart';
import 'package:squeaky_app/components/square_tile.dart';
import 'package:squeaky_app/pages/app_startup_page.dart';
import 'package:squeaky_app/pages/forgot_password_page.dart';
import 'package:squeaky_app/services/authentication_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// ignore: must_be_immutable
class _LoginPageState extends State<LoginPage>{
  //text editting controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // sign in method
    void signUserIn() async {

      final authService =
          Provider.of<AuthenticationService>(context, listen: false);

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your email and password'),
          ),
        );
        return;
      }

      try {
        await authService.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25),

                          //logo
                          const Icon(
                            //TODO: \/\/\/ replace with our logo eventually
                            Icons.cleaning_services_sharp,
                            size: 100,
                          ),

                          const SizedBox(height: 25),

                          //welcome text
                          const Text(
                            "Feelin Dirty?",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 25),

                          //username
                          MyTextField(
                            controller: emailController,
                            hintText: 'Enter your email',
                            obscureText: false,
                            label: 'Email',
                          ),

                          //password
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            obscureText: true,
                            label: 'Password',
                          ),

                          //forgot password
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),

                          const SizedBox(height: 25),

                          MyButton(
                            text: "Login",
                            onPressed: signUserIn,
                            color: Colors.blue[300]!,
                          ),

                          const SizedBox(height: 25),

                          //register now
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppStartupPage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Not a member? Tap here to '),
                                Text('register',
                                    style: TextStyle(color: Colors.blue[500]))
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.blue[300],
                                  ),
                                ),
                                const Text('Or continue with'),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.blue[300],
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //TODO: need to eventually add google and apple sign in stuff, for now its just images
                                SquareTile(
                                  imagePath: 'lib/assets/google.png',
                                  imgHeight: 55,
                                ),

                                SizedBox(
                                    width: 15), //add space between the images

                                SquareTile(
                                  imagePath: 'lib/assets/apple.png',
                                  imgHeight: 55,
                                ),
                              ]),

                          const SizedBox(height: 25),
                        ],
                      ))));
  }
}
