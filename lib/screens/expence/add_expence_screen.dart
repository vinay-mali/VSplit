import 'package:flutter/material.dart';

class AddExpenceScreen extends StatefulWidget {
  const AddExpenceScreen({super.key});
  @override
  State<AddExpenceScreen> createState() => _AddExpenceScreenState();
}

class _AddExpenceScreenState extends State<AddExpenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expence")),
      body: SafeArea(child: Column(
        children: [
          
        ],
      )),
      );
  }
}
