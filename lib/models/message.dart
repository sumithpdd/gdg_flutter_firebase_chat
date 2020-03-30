import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id, senderId, toUserId, text, imageUrl;
  final bool isLiked;
  final bool unread;
  final Timestamp timestamp;
 
  Message({
    this.id,
    this.senderId,
    this.toUserId,
    this.text,
    this.imageUrl,
    this.isLiked,
    this.unread,
    this.timestamp,
  });
 
  factory Message.fromDoc(DocumentSnapshot doc) {
    return Message(
        id: doc.documentID,
        senderId: doc['senderId'],
        toUserId: doc['toUserId'],
        text: doc['text'],
        imageUrl: doc['imageUrl'],
        isLiked: doc['isLiked'],
        unread: doc['unread'],
        timestamp: doc['timestamp']);
  }
}
