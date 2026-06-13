import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupService _groupService = GroupService();

  Future<String> generateJoinCode() async {
    final result = await _groupService.generateJoinCode();
    return result;
  }

  Future<void> createGroup(String groupName) async {
    try {
      final String groupID = FirebaseFirestore.instance
          .collection('groups')
          .doc()
          .id;
      final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final String joinCode = await _groupService.generateJoinCode();

      final GroupModel groupModel = GroupModel(
        groupID: groupID,
        name: groupName,
        createdBy: currentUserUid,
        joinCode: joinCode,
        adminUid: currentUserUid,
        members: [currentUserUid],
      );
      await _groupService.createGroup(groupModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinGroups(String joinCode) async {
    try {
      await _groupService.joinGroups(joinCode);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getGroups() {
    return _groupService.getGroups();
  }
}
