import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdg_flutter_firebase_chat/helpers/constants.dart';
import 'package:gdg_flutter_firebase_chat/models/message.dart';
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

  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
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
        .getDocuments();

    messagesSenderQuerySnapshot.documents.forEach((doc) {
      print(doc.documentID);
      messages.add(Message.fromDoc(doc));
    });
    QuerySnapshot messagestoQuerySnapshot = await chatsRef
        .where('senderId', isEqualTo: receiverId)
        .where('toUserId', isEqualTo: senderId)
        .orderBy('timestamp', descending: true)
        .getDocuments();

    messagestoQuerySnapshot.documents.forEach((doc) {
      print(doc.documentID);
      messages.add(Message.fromDoc(doc));
    });

    Comparator<Message> timestampComparator =
            (b, a) => a.timestamp.compareTo(b.timestamp);

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
