import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:vsplit/models/group_model.dart';

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
          .doc()
          .set(groupModel.toMap());
    } catch (e) {
      throw "Unable to create group. Try again.";
    }
  }

  Stream<QuerySnapshot> getGroups() {
      return FirebaseFirestore.instance
          .collection('groups')
          .where(
            'members',
            arrayContains: FirebaseAuth.instance.currentUser!.uid,
          )
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
}
