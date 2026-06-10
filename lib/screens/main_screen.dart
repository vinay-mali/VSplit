import 'package:flutter/material.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/screens/activity_screen.dart';
import 'package:vsplit/screens/home_screen.dart';
import 'package:vsplit/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: AppTheme.darkBg,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_rounded),
            label: "Activity",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
