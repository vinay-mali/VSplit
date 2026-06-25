import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/models/user_model.dart';
import 'package:vsplit/services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupService _groupService = GroupService();
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  bool _isRemoving = false;
  bool get isRemoving => _isRemoving;
  bool _isCreating = false;
  bool get isCreating => _isCreating;
  bool _isJoining = false;
  bool get isJoining => _isJoining;

  Future<String> generateJoinCode() async {
    final result = await _groupService.generateJoinCode();
    return result;
  }

  Future<void> createGroup(
    String groupName,
    String currency,
    String description,
  ) async {
    try {
      _isCreating = true;
      notifyListeners();
      final String groupID = FirebaseFirestore.instance
          .collection('groups')
          .doc()
          .id;
      final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final String joinCode = await _groupService.generateJoinCode();
      final currentUserModel = await _groupService.getUserById(currentUserUid);

      final GroupModel groupModel = GroupModel(
        groupID: groupID,
        name: groupName,
        createdBy: currentUserModel.fullName,
        joinCode: joinCode,
        adminUid: currentUserUid,
        members: [currentUserUid],
        currency: currency,
        description: description,
      );
      await _groupService.createGroup(groupModel);
    } catch (e) {
      rethrow;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> joinGroups(String joinCode) async {
    try {
      _isJoining = true;
      notifyListeners();
      await _groupService.joinGroups(joinCode);
    } catch (e) {
      rethrow;
    } finally {
      _isJoining = false;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getGroups() {
    return _groupService.getGroups();
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final user = await _groupService.getUserById(userId);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupID) async {
    try {
      _isDeleting = true;
      notifyListeners();
      await _groupService.deleteGroup(groupID);
    } catch (e) {
      rethrow;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<void> removeGroup(String groupID) async {
    try {
      _isRemoving = true;
      notifyListeners();
      await _groupService.removeGroup(groupID);
    } catch (e) {
      rethrow;
    } finally {
      _isRemoving = false;
      notifyListeners();
    }
  }
}
