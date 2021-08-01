import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:olx_clone/screens/Authentication/email_auth_screen.dart';
import 'package:olx_clone/screens/Authentication/phone_auth_screen.dart';
import 'package:olx_clone/services/google_auth_services.dart';
import 'package:olx_clone/services/phone_Auth_services.dart';

class AuthUI extends StatelessWidget {
  final GoogleAuthServices services = GoogleAuthServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ))),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthentication.id);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_iphone_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Login with phone",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SignInButton(
              Buttons.Google,
              text: "Login with Google",
              onPressed: () async {
                User user = await services.signInWithGoogle(context: context);
                if (user != null) {
                  PhoneAuthServices phoneAuthServices = PhoneAuthServices();
                  phoneAuthServices.addUser(context, user);
                }
              },
            ),
            SignInButton(
              Buttons.FacebookNew,
              text: "Login with FaceBook",
              onPressed: () {},
            ),
            Text(
              "OR",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, EmailAuthScreen.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Login with email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
