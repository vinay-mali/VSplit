import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupID;
  final String name;
  final String createdBy;
  final String joinCode;
  final String adminUid;
  final DateTime? createdAt;
  final List<String> members;

  GroupModel({
    required this.groupID,
    required this.name,
    required this.createdBy,
    required this.joinCode,
    required this.adminUid,
    this.createdAt,
    required this.members,
  });

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      groupID: json['groupID'],
      name: json['name'],
      createdBy: json['createdBy'],
      joinCode: json['joinCode'],
      adminUid: json['adminUid'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      members: List<String>.from(json['members'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'name': name,
      'createdBy': createdBy,
      'joinCode': joinCode,
      'adminUid': adminUid,
      'createdAt': FieldValue.serverTimestamp(),
      'members': members,
    };
  }
}
