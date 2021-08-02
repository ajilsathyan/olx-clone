import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<void> updateUserData(Map<String, dynamic> data, context) {
    return users.doc(user.uid).update(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Details Updated successfully"),
        ),
      );
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update"),
          ),
        ));
  }

  Future<String> getUserAddress(lat, lon) async {
    final coordinates = new Coordinates(lat.latitude, lon.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine;
  }

  ///
  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user.uid).get();
    return doc;
  }

  Future<void> updateUserDataForSellingItems(
      {Map<String, dynamic> data, context, catprovider}) {
    return users.doc(user.uid).update({'contact_details': data}).then((value) {
      saveSellerProductToDataBase(
          context: context, sellerCarFormData: catprovider.sellerCarFormData);
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update"),
          ),
        ));
  }

  Future<void> saveSellerProductToDataBase({context, sellerCarFormData}) {
    return products
        .doc(user.uid).collection('products')
        .add(sellerCarFormData)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("items have been added to DataBase"),
              ),
            ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed!!")),
            ));
  }
}
