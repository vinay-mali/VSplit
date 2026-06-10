import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/auth_wrapper.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/firebase_options.dart';
import 'package:vsplit/providers/auth_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthUserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VSplit",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: AuthWrapper(),
    );
  }
}
