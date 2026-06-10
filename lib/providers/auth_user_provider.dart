import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/models/user_model.dart';
import 'package:vsplit/services/auth_service.dart';

class AuthUserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<User?> signUp(
    String email,
    String password,
    String username,
    String fullName,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user = await _authService.signUp(email, password);
      if (user != null) {
        final usernameCheck = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username.trim().toLowerCase())
            .get();
        if (usernameCheck.docs.isNotEmpty) {
          await user.delete();
          throw "Username already taken. Try another.";
        }
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          username: username.trim().toLowerCase(),
          fullName: fullName,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      User? user = await _authService.login(email, password);

      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
