import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/login_screen.dart';

class EmailPasswordResetScreen extends StatefulWidget {
  static const String id = 'email-pass-reset-screen';

  @override
  _EmailPasswordResetScreenState createState() =>
      _EmailPasswordResetScreenState();
}

class _EmailPasswordResetScreenState extends State<EmailPasswordResetScreen> {
  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),    
          title: Text(
            "Reset Password",
            style: TextStyle(color: Colors.black),
          )),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red.shade200,
                  child: Icon(
                    CupertinoIcons.person_alt_circle,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Forgot\n Password?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "We will send a link to reset your password ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,  
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(emailController.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),


                      suffixIcon: Icon(Icons.email_outlined),
                      labelText: "email",
                      hintText: "xyz1999@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: emailController.text)
                            .then(
                              (value) => Navigator.popAndPushNamed(
                                  context, LoginScreen.id),
                            );
                      }
                    },
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
