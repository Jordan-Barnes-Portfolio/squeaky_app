// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neatfreak/components/my_button.dart';
import 'package:neatfreak/components/my_text_field.dart';
import 'package:neatfreak/pages/app_startup_page.dart';
import 'package:neatfreak/pages/forgot_password_page.dart';
import 'package:neatfreak/services/authentication_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// ignore: must_be_immutable
class _LoginPageState extends State<LoginPage> {
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
            const SizedBox(height: 45),

            //logo
            const Image(
                image: AssetImage('lib/assets/logo.png'),
                height: 200,
                width: 300),

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
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 15, color: Colors.black),
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
                        builder: (context) => const AppStartupPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member? Tap here to '),
                  Text('register', style: TextStyle(color: Colors.blue[500]))
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ))));
  }
}
