import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/provider/category_provider.dart';
import 'package:olx_clone/screens/category/sub_category_screen.dart';
import 'package:olx_clone/screens/forms/seller_car_form.dart';
import 'package:olx_clone/screens/sellerItems/Seller_sub_category_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';
import 'package:olx_clone/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';

class SellerCategoryListsScreen extends StatelessWidget {
  static const String id = 'seller-category-list-screen';
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    var _categoryProvider=Provider.of<CategoryProvider>(context);
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          title: Text(
            "Choose Category",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          shape: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _services.categories.orderBy('sortId',descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, i) {
                      var doc = snapshot.data.docs[i];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                                _categoryProvider.getCategory(doc['catName']);
                                _categoryProvider.getSnapShot(doc);
                              if(doc['subCat']==null){
                               return  Navigator.pushNamed(context, SellerCarFormScreen.id);
                              }
                              Navigator.pushNamed(
                                  context, SellerSubCategoryScreen.id,arguments: doc);
                            },
                            leading: CachedNetworkImage(
                              height: 45,
                              imageUrl: doc['image'],
                              placeholder: (context, url) =>
                              Container( width:30,height:30,child: FittedBox(child: buildCustomProgressIndicator(context))),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(
                              doc['catName'],
                              style: TextStyle(fontSize: 15),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ));
                    }),
              ),
            );
          },
        ));
  }
}
