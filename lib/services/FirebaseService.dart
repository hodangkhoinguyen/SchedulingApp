import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Class to handle Firebase Authentication

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> doSignIn(
      BuildContext context, VoidCallback onSuccess) async {
    UserCredential? credential = await _signInWithGoogle();
    if (credential != null) {
      onSuccess.call();
    }

    return credential;
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? gsAccount = await _googleSignIn.signIn();

      // did the user cancel / the request fail?
      if (gsAccount != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleSignInAuthentication =
            await gsAccount.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Once signed in, return the UserCredential
        return await _auth.signInWithCredential(credential);
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    } on PlatformException catch (e) {
      if (e.code != "sign_in_canceled") {
        rethrow;
      }
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
