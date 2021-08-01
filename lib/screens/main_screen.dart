import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/account_screen.dart';
import 'package:olx_clone/screens/chat_screen.dart';
import 'package:olx_clone/screens/home_screen.dart';
import 'package:olx_clone/screens/my_ads_screen.dart';
import 'package:olx_clone/screens/sellerItems/Seller_category_List_Screen.dart';


class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = HomeScreen();
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _index==2?Colors.pink:Colors.blue,
        onPressed: () {
          setState(() {
            _index = 2;
            _currentScreen=SellerCategoryListsScreen();
          });
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      _index = 0;
                      _currentScreen = HomeScreen();
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _index == 0 ? Icons.home : Icons.home_outlined,
                        color: _index == 0 ? primaryColor : Colors.black,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                            fontWeight:_index==0?FontWeight.bold:FontWeight.normal,
                            color: _index == 0 ? primaryColor : Colors.black),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      _index = 1;
                      _currentScreen = ChatScreen();
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _index == 1 ? CupertinoIcons.chat_bubble_fill :CupertinoIcons.chat_bubble,
                        color: _index == 1 ? primaryColor : Colors.black,
                      ),
                      Text(
                        "Chats",
                        style: TextStyle(
                          fontWeight:_index==1?FontWeight.bold:FontWeight.normal,
                            color: _index == 1 ? primaryColor : Colors.black),
                      )
                    ],
                  ),
                ),
             SizedBox(width: 80,),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      _index = 3;
                      _currentScreen = MyAdsScreen();
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _index == 3 ? CupertinoIcons.heart_fill:CupertinoIcons.heart,
                        color: _index == 3 ? primaryColor : Colors.black,
                      ),
                      Text(
                        "My Ads",
                        style: TextStyle(
                            fontWeight:_index==3?FontWeight.bold:FontWeight.normal,
                            color: _index == 3 ? primaryColor : Colors.black),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _index = 4;
                          _currentScreen = AccountScreen();
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            _index == 4 ? CupertinoIcons.person_fill : CupertinoIcons.person,
                            color: _index == 4 ? primaryColor : Colors.black,
                          ),
                          Text(
                            "Account",
                            style: TextStyle(
                                fontWeight:_index==4?FontWeight.bold:FontWeight.normal,
                                color: _index == 4 ? primaryColor : Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
