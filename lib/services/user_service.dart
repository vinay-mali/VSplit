import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vsplit/models/user_model.dart';

class UserService {
  Future<UserModel> fetchCurrentUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
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
}
