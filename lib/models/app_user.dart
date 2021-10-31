import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? id;
  final String? name;
  final String? profileImageUrl, email, bio, token;
  // {} named parameters
  AppUser(
      {this.id,
      this.name,
      this.profileImageUrl,
      this.email,
      this.bio,
      this.token});

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    return AppUser(
        id: doc.id,
        name: doc['name'],
        profileImageUrl: doc['profileImageUrl'],
        email: doc['email'],
        bio: doc['bio'],
        token: doc['token']);
  }
}
