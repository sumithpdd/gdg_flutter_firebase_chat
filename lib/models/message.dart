import 'package:gdg_flutter_firebase_chat/models/user.dart';

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: '0',
  name: 'Current User',
  profileImageUrl: 'assets/images/greg.jpg',
); 
final User sumith = User(
  id: '1',
  name: 'sumith',
  profileImageUrl: 'assets/images/greg.jpg',
);
final User martin = User(
  id: '2',
  name: 'martin',
  profileImageUrl: 'assets/images/james.jpg',
);
final User laura = User(
  id: '3',
  name: 'laura',
  profileImageUrl: 'assets/images/john.jpg',
);
final User bilal = User(
  id: '4',
  name: 'bilal',
  profileImageUrl: 'assets/images/olivia.jpg',
);
final User sam = User(
  id: '5',
  name: 'Sam',
  profileImageUrl: 'assets/images/sam.jpg',
);
final User sophia = User(
  id: '6',
  name: 'Sophia',
  profileImageUrl: 'assets/images/sophia.jpg',
);
final User steven = User(
  id: '7',
  name: 'Steven',
  profileImageUrl: 'assets/images/steven.jpg',
);

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: sumith,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: laura,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: martin,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sophia,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: bilal,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sam,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: bilal,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: martin,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: martin,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: martin,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: martin,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];
