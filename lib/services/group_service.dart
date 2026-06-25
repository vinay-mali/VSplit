import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/models/user_model.dart';

class GroupService {
  Future<String> generateJoinCode() async {
    const uuid = Uuid();
    String code;
    bool exists = true;
    do {
      code = uuid.v4().substring(0, 6).toUpperCase();
      final result = await FirebaseFirestore.instance
          .collection('groups')
          .where('joinCode', isEqualTo: code)
          .get();
      exists = result.docs.isNotEmpty;
    } while (exists);

    return code;
  }

  Future<void> createGroup(GroupModel groupModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupModel.groupID)
          .set(groupModel.toMap());
    } catch (e) {
      throw "Unable to create group. Try again.";
    }
  }

  Stream<QuerySnapshot> getGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> joinGroups(String joinCode) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final result = await FirebaseFirestore.instance
          .collection('groups')
          .where('joinCode', isEqualTo: joinCode.trim().toUpperCase())
          .get();
      if (result.docs.isEmpty) {
        throw "Invalid Code. No group found.";
      }

      final groupDoc = result.docs.first;

      final List members = groupDoc['members'];
      if (members.contains(currentUserUid)) {
        throw "You are already in this group.";
      }

      await groupDoc.reference.update({
        'members': FieldValue.arrayUnion([currentUserUid]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (user.exists) {
        return UserModel.fromMap(user.data() as Map<String, dynamic>);
      } else {
        throw "User not found";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupID) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .delete();
    } catch (e) {
      throw "Unable to delete group. Try again.";
    }
  }

  Future<void> removeGroup(String groupID) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final group = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .get();
      if (group.exists) {
        await group.reference.update({
          "members": FieldValue.arrayRemove([currentUserUid]),
        });
      }
    } catch (e) {
      throw "Unable to remove group";
    }
  }
}
