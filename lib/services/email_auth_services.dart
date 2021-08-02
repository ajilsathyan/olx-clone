import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';

class EmailAuthServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // need to check the user exists or not
  FirebaseServices _services =FirebaseServices();

  Future<DocumentSnapshot> getAdminCredentials(
      {email, password, isLog, context}) async {

    DocumentSnapshot _result = await users.doc(_services.user.uid).get();

    /// Direct Login
    if (isLog) {
      /// Email Login
      emailLogin(email, password, context);
    }

    ///  Registration using email and password
    else {
      if (_result.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already an account exists with this email'),
          ),
        );
      } else {
        /// Email Registration
        emailRegister(email, password, context);
      }
    }

    return _result;
  }

  /// Email Login
  emailLogin(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.uid != null) {
       
        Navigator.pushNamedAndRemoveUntil(context, LocationScreen.id, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user'),
          ),
        );
      }
    }
  }

  /// Registration using Email and password
  emailRegister(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.uid != null) {
        ///login success
        return users.doc(userCredential.user.uid).set({
          'uid': userCredential.user.uid,
          'mobile': userCredential.user.phoneNumber,
          'email': userCredential.user.email,
          'username':null,
        }).then((value) async {
          /// email verification entered email is user's or others

          await userCredential.user.sendEmailVerification().then((value) {
            // after completion of email verification
              Navigator.pushNamedAndRemoveUntil(context, LocationScreen.id, (route) => false);
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for this email.'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
