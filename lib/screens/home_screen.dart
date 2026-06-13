import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/screens/create_join_group_screen.dart';
import 'package:vsplit/widgets/app_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool fabOptions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(children: [
          
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (fabOptions)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FloatingActionButton.extended(
                heroTag: "create_group_tag",
                backgroundColor: AppTheme.primaryColor,
                icon: Icon(Icons.add, color: Colors.white),
                label: AppText(text: "Create Group", textColor: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateJoinGroupScreen(mode: 'create'),
                    ),
                  );
                },
              ).animate().fadeIn(duration: 350.ms),
            ),
          if (fabOptions)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FloatingActionButton.extended(
                heroTag: "join_group_tag",
                backgroundColor: AppTheme.primaryColor,
                icon: Icon(Icons.wechat_rounded, color: Colors.white),
                label: AppText(text: "Join Group", textColor: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateJoinGroupScreen(mode: 'join'),
                    ),
                  );
                },
              ).animate().fadeIn(duration: 150.ms),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FloatingActionButton(
              heroTag: "main_tag",
              backgroundColor: AppTheme.primaryColor,
              child: Icon(
                fabOptions ? Icons.keyboard_arrow_down_outlined : Icons.add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  fabOptions = !fabOptions;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
