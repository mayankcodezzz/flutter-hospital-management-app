//this will contain three object icons home, treatment ,profile
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healmeup/Screens/profile/profile.dart';

import 'package:healmeup/adminscreen/hospitalsUpdate.dart';
import 'package:healmeup/adminscreen/mainscreenadmin.dart';

import 'Screens/home/home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _SelectedIndex=0;
  static final List<Widget>_widgetOptions =<Widget>[
    AdminMainScreen(),
    ProfileScreen()
  ];
  void _onItemTapped(int index){
    setState(() {
      _SelectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: _widgetOptions[_SelectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _SelectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "home"),
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
              label: "profile"),
        ],

      ),
    );
  }
}
