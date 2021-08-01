import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/Authentication/otp_screen.dart';
import 'package:olx_clone/screens/location_screen.dart';

class PhoneAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User user = FirebaseAuth.instance.currentUser;

  // Uploading User Data to the FireStore
  Future<void> addUser(context, userId) async {
    // We need to check that he is logged in same number before adding the data to the fireStore
    //If he using the Same number we need to skip adding Add user data
    // check User Data in fireStore or not
    final QuerySnapshot result =
        await users.where('uid', isEqualTo: userId).get();
    List<DocumentSnapshot> document = result.docs; //List of user data

    if (document.length > 0) {
      // User Data Exits and We need to skip AddUser Data to FireStore again
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else if (document.length == 0) {
      // User Data Doesn't Exits and Add to AddUser to the FireStore
      await users.doc(userId).set({
        'uid': user.uid, // User ID
        'mobile': user.phoneNumber, // mobile Number
        'email': user.email,
      }).then((value) {
        // After Saving Data to the firesBase it will return a screen to the User
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  /// Phone Verification Method
  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    // phoneVerificationCompleted
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    // Verification  failed
    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print("err${e.code}");
    };

    // Otp Code Sending
    final PhoneCodeSent phoneCodeSent =
        (String verificationId, int resendToken) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return OTPScreen(
              number: number,
              verificationId: verificationId,
            );
          },
        ),
      );
    };
// Must Use Cloud.Google.com ==> Console=> Search Project=>API$ Services=>
// + Enable Api& Services => Search => Android Device Verification
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        timeout: const Duration(seconds: 80),
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
