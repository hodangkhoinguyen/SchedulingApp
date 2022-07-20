import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// Initial screen the sends user to sign-in or to select screen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to the Scheduler App.",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: size.height * 0.15),
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser == null
                      ? Navigator.pushNamed(context, "/sign-in")
                      : Navigator.pushReplacementNamed(context, "/select");
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                child: const Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
