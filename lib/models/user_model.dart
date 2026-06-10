import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String fullName;
  final DateTime? dateCreated;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.fullName,
    this.dateCreated,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      dateCreated: (json['dateCreated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'fullName' : fullName,
      'dateCreated': FieldValue.serverTimestamp(),
    };
  }
}
