import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SellerReviewScreen extends StatefulWidget {
  static const String id = 'seller-review-screen';

  @override
  _SellerReviewScreenState createState() => _SellerReviewScreenState();
}

class _SellerReviewScreenState extends State<SellerReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+91');
  var _emailController = TextEditingController();

  validateDetails() {
    if (_formKey.currentState.validate()) {
      print('validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Review your selling item',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Icon(
                          CupertinoIcons.person_alt,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.length < 4) {
                            return "Enter Your full name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Your name',
                          errorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Contact Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter country code";
                          }
                          if (value.length <= 2) {
                            return '+91';
                          }
                          return null;
                        },
                        maxLength: 3,
                        controller: _countryCodeController,
                        decoration: InputDecoration(
                          hintText: "+91",
                          errorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value.length < 10) {
                            return "Enter your 10 digit phone number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                          ),
                          hintText: "9999999999",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: primaryColor,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(_emailController.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    labelText: 'e-mail',
                    helperText: "xyz299@gmail.com",
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: primaryColor,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            validateDetails();
          },
          child: Text("Submit"),
        ),
      ),
    );
  }
}
