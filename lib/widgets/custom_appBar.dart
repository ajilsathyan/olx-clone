import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseServices _services = FirebaseServices();
  String userAddress;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _services.users.doc(_services.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          String addressTitle=data['original_address'];
          if (data['original_address'] == null) {
            if (data['state'] == null) {
              GeoPoint latLon = data['location'];
              _services.getUserAddress(latLon.latitude, latLon.longitude);
            }
          }

          return buildAppBar(context, addressTitle);
        }

        return buildAppBar(context,'Loading address');
      },
    );
  }

  AppBar buildAppBar(BuildContext context,data) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, LocationScreen.id);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.location_solid,
                color: Colors.black,
                size: 18,
              ),
              Flexible(
                child: Text(
                 data,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.black,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
