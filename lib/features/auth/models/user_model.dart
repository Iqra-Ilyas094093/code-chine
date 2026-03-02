import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? businessName;
  final String? phone;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.businessName,
    this.phone,
    required this.createdAt,
  });

  // Convert UserModel → Map to save into Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'businessName': businessName ?? '',
      'phone': phone ?? '',
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Convert Firestore document snapshot → UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      businessName: map['businessName'],
      phone: map['phone'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}