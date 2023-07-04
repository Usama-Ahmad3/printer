import 'package:flutter/material.dart';
import 'package:printer/view/homeScreens/upload.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'download.dart';

class MyTabBar extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int currentIndex = 0;
  final page = [const UploadScreen(), const Download()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: page[currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SalomonBottomBar(
              curve: Curves.bounceIn,
              items: [
                SalomonBottomBarItem(
                    icon: const Icon(
                      Icons.upload_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Upload',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeIcon: const Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    selectedColor: Colors.indigo,
                    unselectedColor: Colors.grey),
                SalomonBottomBarItem(
                    icon: const Icon(
                      Icons.download_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeIcon: const Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                    ),
                    selectedColor: Colors.indigo,
                    unselectedColor: Colors.grey),
              ],
              selectedColorOpacity: 1,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.grey.shade300,
              currentIndex: currentIndex,
              onTap: (val) {
                setState(() {
                  currentIndex = val;
                });
              },
            ),
          ),
        ));
  }
}
