import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:olx_clone/constants/constant_input_text_field_decorations.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/screens/main_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';
import 'package:provider/provider.dart';

class SellerReviewScreen extends StatefulWidget {
  static const String id = 'seller-review-screen';

  @override
  _SellerReviewScreenState createState() => _SellerReviewScreenState();
}

class _SellerReviewScreenState extends State<SellerReviewScreen> {
  FirebaseServices services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+91');
  var _emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var _catprovider = Provider.of<CategoryProvider>(context);

    validateDetails() {
      String mobileNumber =
          "${_countryCodeController.text}${_phoneController.text}";
      if (_formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> data = {

          'email': _emailController.text,
          'mobile': mobileNumber,
        };
        services
            .updateUserDataForSellingItems(
                context: context, catprovider: _catprovider, data: data,userName: _nameController.text)
            .then((value) {
              setState(() {
                isLoading=false;
              });
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _catprovider.clearDataFields();
               Navigator.pushNamedAndRemoveUntil(context, MainScreen.id,(route) => false);
              });

        });
      }
    }

    showDialogConfirmation(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Text(
                      "Are you sure, you want to save below product",
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.network(_catprovider.listUrls[0]),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_catprovider.sellerCarFormData['brand']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "Price: ${_catprovider.sellerCarFormData['price']}")
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.green),
                          onPressed: () {
                            Navigator.pop(context);
                            validateDetails();
                          },
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

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
              padding: const EdgeInsets.only(
                  top: 20, left: 25, right: 25, bottom: 0),
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
                          decoration: inputDecorationForTextField(
                              context: context, labelText: 'Your name'),
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
                          decoration: inputDecorationForTextField(
                              context: context, hintText: "+91"),
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
                          decoration: inputDecorationForTextField(
                              context: context, hintText: '9999999999'),
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
                    decoration: inputDecorationForTextField(
                      context: context,
                      labelText: 'e-mail',
                      helperText: "xyz299@gmail.com",
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
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor)),
            onPressed: () {
              showDialogConfirmation(context);
            },
            child: isLoading
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text("Confirm"),
          ),
        ));
  }
}
