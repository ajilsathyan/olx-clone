import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/Authentication/phone_auth_screen.dart';
import 'package:olx_clone/services/phone_Auth_services.dart';

class OTPScreen extends StatefulWidget {
  static const String id = 'otp-screen';
  final String number, verificationId;

  OTPScreen({this.number, this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

var text1 = TextEditingController();
var text2 = TextEditingController();
var text3 = TextEditingController();
var text4 = TextEditingController();
var text5 = TextEditingController();
var text6 = TextEditingController();
PhoneAuthServices services = PhoneAuthServices();
String error = "";

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> verifyPhoneNumber(BuildContext context, String otp) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: widget.verificationId, smsCode: otp);
        //Need to otp validate or not
        final User user = (await auth.signInWithCredential(credential)).user;

        if (user != null) {
          // Data is storing
          services.addUser(context, user.uid);
        } else {
          if (mounted) {
            setState(() {
              error = "Error ";
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            error = "Error${e.toString()}";
          });
        }
      }
    }

    // if input value ==1 then it trigger to next input field
    var node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: null,
        automaticallyImplyLeading: false,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
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
              height: 12,
            ),
            Text(
              "Welcome Back",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: "We sent a 6-digit code to ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                              text: "${widget.number}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PhoneAuthentication();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    controller: text1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: text2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: text3,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: text4,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: text5,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: text6,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (text1.text.length == 1) {
                          if (text2.text.length == 1) {
                            if (text3.text.length == 1) {
                              if (text4.text.length == 1) {
                                if (text5.text.length == 1) {
                                  String otp =
                                      "${text1.text}${text2.text}${text3.text}${text4.text}${text5.text}${text6.text}";

                                  verifyPhoneNumber(context, otp);
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
