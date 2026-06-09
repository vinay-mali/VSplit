import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime? dateCreated;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.dateCreated,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      dateCreated: (json['dateCreated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'dateCreated': FieldValue.serverTimestamp(),
    };
  }
}
