import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:olx_clone/services/phone_Auth_services.dart';

class PhoneAuthentication extends StatefulWidget {
  static const String id = 'phone-auth-screen';
  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  var phoneNumberController = TextEditingController();
  var countryCodeController = TextEditingController(text: "+91");
  bool validate = false;
  bool circularIndicator = false;

  PhoneAuthServices _phoneAuthServices = PhoneAuthServices();
  @override
  Widget build(BuildContext context) {
    //Create an instance of ProgressDialog
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      loadingText: "Please Wait",
      progressIndicatorColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
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
              "Enter Phone Number",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We will send confirmation code to your phone",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    enabled: false,
                    maxLength: 3,
                    controller: countryCodeController,
                    decoration: InputDecoration(labelText: "Country"),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validate = true;
                        });
                      }
                      if (value.length < 10) {
                        setState(() {
                          validate = false;
                        });
                      }
                    },
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    maxLength: 10,
                    decoration: InputDecoration(
                        labelText: "Number",
                        hintText: "9764763552",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: validate
                      ? MaterialStateProperty.all(
                          Theme.of(context).primaryColor)
                      : MaterialStateProperty.all(Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
              onPressed: () {
                progressDialog.show();

                String number =
                    "${countryCodeController.text}${phoneNumberController.text}";

                _phoneAuthServices.verifyPhoneNumber(context, number);
              },
            ),
          ),
        ),
      ),
    );
  }
}
