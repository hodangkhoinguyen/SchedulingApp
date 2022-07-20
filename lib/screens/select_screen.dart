import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/services/FirebaseService.dart';

// Screen for selecting whether the user will be a tutor or student

class SelectScreen extends StatelessWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("I'm a...",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: size.height * 0.1),
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/tutor");
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                child: const Text("Tutor"),
              ),
            ),
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/student");
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                child: const Text("Student"),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                FirebaseService().signOutFromGoogle();
                Navigator.pushReplacementNamed(context, "/");
              },
              child: Text("Sign Out"),
              style: OutlinedButton.styleFrom(primary: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
