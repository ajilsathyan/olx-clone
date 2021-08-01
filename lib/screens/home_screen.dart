import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/widgets/banner_widget.dart';
import 'package:olx_clone/widgets/cateogry_widget.dart';

import 'package:olx_clone/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentLocation = 'india';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0,top: 8,left: 8,right: 8),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          suffixIcon: Icon(Icons.search),
                          labelText: 'Find Cars, Mobiles and many more...',
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            BannerWidget(),
            Container( 
              height:170,
              child: CategoryWidget())
          ],
        ),
      ),
    );
  }
}
