import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/providers/auth_user_provider.dart';
import 'package:vsplit/providers/group_provider.dart';
import 'package:vsplit/screens/group/create_join_group_screen.dart';
import 'package:vsplit/screens/group/group_detail_screen.dart';
import 'package:vsplit/widgets/app_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> _groupStream;
  bool fabOptions = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthUserProvider>().fetchCurrentUser();
    _groupStream = context.read<GroupProvider>().getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _groupStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: AppText(
                text: "Something went wrong",
                textColor: Colors.white,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 100, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        AppText(
                          text: "No Groups yet.",
                          textColor: Colors.white,
                        ),
                        AppText(
                          text: "Tap (+) icon to create or join group.",
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final group = GroupModel.fromMap(
                snapshot.data!.docs[index].data() as Map<String, dynamic>,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 1,
                ),
                child: Card(
                  color: const Color.fromARGB(255, 74, 72, 72),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GroupDetailScreen(group: group),
                          ),
                        );
                      },
                      title: AppText(
                        text: snapshot.data!.docs[index]["name"],
                        textFontSize: 18,
                        textFontWeight: FontWeight.w600,
                      ),
                      subtitle: AppText(
                        text: group.createdAt != null
                            ? "Created: ${DateFormat('dd MMM yyyy , hh:mm a').format(group.createdAt!)}"
                            : "",
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
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
