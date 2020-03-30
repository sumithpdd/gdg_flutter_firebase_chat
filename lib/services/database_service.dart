import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:gdg_flutter_firebase_chat/helpers/constants.dart';
import 'package:gdg_flutter_firebase_chat/models/user.dart';

class DataBaseService {
  Future<User> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return User.fromDoc(userDoc);
  }

  Future<List<User>> getAllUsers(String currentUserId) async {
    QuerySnapshot userSnapshot = await usersRef.getDocuments();
    List<User> users = [];
    userSnapshot.documents.forEach((doc) {
      User user = User.fromDoc(doc);
      if (user.id != currentUserId) users.add(user);
    });
    return users;
  }
} 
