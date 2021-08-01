import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/category/category_list_screen.dart';
import 'package:olx_clone/screens/category/sub_category_screen.dart';
import 'package:olx_clone/services/firebase_services.dart';
import 'package:olx_clone/widgets/custom_progress_bar.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _services.categories.orderBy('sortId', descending: false).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: buildCustomProgressIndicator(context));
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Categories"),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CategoryListScreen.id);
                    },
                    child: Row(
                      children: [
                        Text(
                          "See all",
                          style: TextStyle(color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: Colors.black,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, i) {
                      var doc = snapshot.data.docs[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SubCategoryScreen.id,
                                arguments: doc);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: doc['image'],
                                  placeholder: (context, url) =>
                                      buildCustomProgressIndicator(context),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Text(
                                  doc['catName'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
