import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_flutter_firebase_chat/helpers/constants.dart';
import 'package:devfest_flutter_firebase_chat/models/message.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';

class DatabaseService {
  Future<AppUser> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.doc(userId).get();
    return AppUser.fromDoc(userDoc);
  }

  Future<List<AppUser>> searchUsers(String currentUserId, String name) async {
    QuerySnapshot usersSnap =
        await usersRef.where('name', isGreaterThanOrEqualTo: name).get();
    List<AppUser> users = [];
    for (var doc in usersSnap.docs) {
      AppUser user = AppUser.fromDoc(doc);
      if (user.id != currentUserId) {
        users.add(user);
      }
    }
    return users;
  }

  Future<List<AppUser>> getAllUsers(String currentUserId) async {
    QuerySnapshot userSnapshot = await usersRef.get();
    List<AppUser> users = [];
    for (var doc in userSnapshot.docs) {
      AppUser user = AppUser.fromDoc(doc);
      if (user.id != currentUserId) users.add(user);
    }
    return users;
  }

  static void updateUser(AppUser user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  Future<List<Message>> getChatMessages(
      String senderId, String receiverId) async {
    List<Message> messages = [];
    QuerySnapshot messagesSenderQuerySnapshot = await chatsRef
        .where('senderId', isEqualTo: senderId)
        .where('toUserId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .get();

    for (var doc in messagesSenderQuerySnapshot.docs) {
      // ignore: avoid_print
      print(doc.id);
      messages.add(Message.fromDoc(doc));
    }
    QuerySnapshot messagestoQuerySnapshot = await chatsRef
        .where('senderId', isEqualTo: receiverId)
        .where('toUserId', isEqualTo: senderId)
        .orderBy('timestamp', descending: true)
        .get();

    for (var doc in messagestoQuerySnapshot.docs) {
      // ignore: avoid_print
      print(doc.id);
      messages.add(Message.fromDoc(doc));
    }

    Comparator<Message> timestampComparator =
        (a, b) => b.timestamp!.compareTo(a.timestamp!);
    messages.sort(timestampComparator);
    return messages;
  }

  void sendChatMessage(Message message) {
    chatsRef.add({
      'senderId': message.senderId,
      'toUserId': message.toUserId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'isLiked': message.isLiked,
      'unread': message.unread,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}
