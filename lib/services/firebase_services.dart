import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> updateUserLocation(Map<String, dynamic> data, context) {
    return users
        .doc(user.uid)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<String> getUserAddress(lat, lon) async {
    final coordinates = new Coordinates(lat.latitude, lon.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine;
  }
  ///
  Future<DocumentSnapshot> getUserData()async{
     DocumentSnapshot doc =await users.doc(user.uid).get();
    return doc;
  }
}
