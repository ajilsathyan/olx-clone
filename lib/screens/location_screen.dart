import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:olx_clone/screens/home_screen.dart';
import 'package:olx_clone/screens/main_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _loading = false;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  var locationInputController = TextEditingController();
  String _loadedAddress;

  ///
  FirebaseServices _services = FirebaseServices();

  ///
  Future<LocationData> getLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return _locationData = await location.getLocation();
        }
      }

      _locationData = await location.getLocation();
      final coordinates =
          new Coordinates(_locationData.latitude, _locationData.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        _loadedAddress = first.addressLine;
        countryValue = first.countryName;
      });

      return _locationData;
    } catch (e) {
      print(e);
    }
    return _locationData;
  }

  String countryValue;
  String stateValue;
  String cityValue;
  String manualAddress;

  @override
  void initState() {
    super.initState();
    checkUserAddressExists();
  }

  Future<void> checkUserAddressExists() async {
    _services.users
        .doc(_services.user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot['original_address'] != null) {
          setState(() {
            _loading = true;
          });
          Timer(Duration(seconds: 2), () {
            Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.id, (route) => false);
            setState(() {
              _loading = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      loadingText: "Please Wait",
      progressIndicatorColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );

    Color primaryColor = Theme.of(context).primaryColor;

    bottomsheetScreen(context) {
      getLocation().then((value) {
        if (value != null) {
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      title: Text(
                        "Location",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: primaryColor,
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.streetAddress,
                        controller: locationInputController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            hintText: "Search city,area or neighbourhood",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    ListTile(
                        onTap: () {
                          progressDialog.show();
                          getLocation().then(
                            (value) {
                              if (value != null) {
                                _services.updateUserData({
                                  "location":
                                      GeoPoint(value.latitude, value.longitude),
                                  'original_address': _loadedAddress
                                }, context).then(
                                  (value) {
                                    progressDialog.dismiss();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return MainScreen();
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                        horizontalTitleGap: 0.0,
                        title: Text("Use Current Location",
                            style: TextStyle(color: primaryColor)),
                        subtitle: Text(
                            value == null
                                ? "Fetching Location"
                                : _loadedAddress,
                            style: TextStyle(color: Colors.grey)),
                        leading: Icon(
                          Icons.my_location,
                          color: primaryColor,
                        )),
                    Container(
                      padding: EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Text("CHOOSE CITY",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        dropdownDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            manualAddress =
                                '$cityValue,$stateValue,$countryValue';
                          });
                        },
                      ),
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                        ),
                        onPressed: () {
                          _services.updateUserData({
                            "address": manualAddress,
                            "location":
                                GeoPoint(value.latitude, value.longitude),
                            'state': stateValue,
                            "city": cityValue,
                            "country": countryValue,
                            'original_address': _loadedAddress
                          }, context).then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return MainScreen();
                                  },
                                ),
                              ));
                        },
                        child: Text("Save Your Location",
                            style: TextStyle(color: Colors.white))),
                  ],
                );
              });
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/sellorbuy.jpg"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Where do want \n to Buy/Sell products",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "To Enjoy all that we need to offer you\n"
                "We need to know where to look for them",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ))
                          : ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                              ),
                              icon: Icon(CupertinoIcons.location_fill),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  "Around me",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _loading = true;
                                });

                                getLocation().then(
                                  (value) {
                                    _services.updateUserData({
                                      "location": GeoPoint(
                                          value.latitude, value.longitude),
                                      'state': stateValue,
                                      "city": cityValue,
                                      "country": countryValue,
                                      'original_address': _loadedAddress
                                    }, context).then(
                                      (value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return HomeScreen();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  bottomsheetScreen(context);
                },
                child: Text(
                  "Set Location Manually",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
