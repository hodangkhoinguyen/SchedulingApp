import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/services/FirebaseService.dart';

// Screen for handling user sign in via Google

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Welcome back.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: size.height * 0.15),
          SizedBox(
            width: size.width * 0.8,
            child: GoogleSignIn(),
          ),
        ]),
      ),
    );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

// State for google sign in to prompt login then send user to select screen on complete

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                FirebaseService service = FirebaseService();
                try {
                  service.doSignIn(context, () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/select", (route) => false);
                  });
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                if (!mounted) {}
                setState(() {
                  isLoading = false;
                });
              },
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              child: const Text("Sign in with Google"),
            ),
          )
        : const CircularProgressIndicator();
  }

  // used in case of firebase error

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
