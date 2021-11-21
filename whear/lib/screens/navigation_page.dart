import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';
import 'dart:io';

import 'package:whear/main.dart';
import '/controller/bottomNavigation_controller.dart';
import '/screens/add_page.dart';
import '/screens/notice_page.dart';
import '/screens/profile_page.dart';
import '/screens/search_page.dart';
import '/screens/home_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {

  final BottomNavigationController _controller = Get.put(BottomNavigationController());
  List _pages = [
    // Text('home'),
    // Text('search'),
    // Text('add'),
    // Text('notice'),
    // Text('profile'),
    HomePage(),
    SearchPage(),
    AddPage(),
    NoticePage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: _pages[_controller.curPage.toInt()],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _controller.changeTabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Notice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _controller.curPage.toInt(),
      ),
    ));
  }
}
