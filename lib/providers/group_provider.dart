import 'package:flutter/material.dart';
import 'package:vsplit/services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupService _groupService = GroupService();

  Future<String> generateJoinCode() async {
    final result = await _groupService.generateJoinCode();
    return result;
  }
}
