import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerReviewScreen extends StatefulWidget {
  static const String id = 'seller-review-screen';

  @override
  _SellerReviewScreenState createState() => _SellerReviewScreenState();
}

class _SellerReviewScreenState extends State<SellerReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
            child: Column(
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
                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
