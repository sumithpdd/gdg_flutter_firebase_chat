import 'package:flutter/material.dart';
import 'package:gdg_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:gdg_flutter_firebase_chat/models/message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textMessageController = TextEditingController();
  bool _isComposing = false;

  final List<Message> _messages = messages;

  _buildMessage(Message message, bool isMe) {
    final Widget msg = Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        margin: isMe
            ? EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 80.0,
              )
            : EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: isMe
              ? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION)
              : AppConstants.hexToColor(
                  AppConstants.APP_BACKGROUND_COLOR_WHITE),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white60 : Colors.blueGrey,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.time,
                  style: TextStyle(
                    color: isMe ? Colors.white60 : Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Row(
      children: <Widget>[msg],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {},
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(15.0),
          ),
          Expanded(
            child: TextField(
              controller: _textMessageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintText: 'Type your message...',
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: _isComposing
                ? () => _handleSubmitted(_textMessageController.text)
                : null,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textMessageController.clear();

    setState(() {
      _isComposing = false;
    });
    Message message = Message(
      sender: currentUser,
      time: '6:30 PM',
      text: text,
      isLiked: true,
      unread: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message message = _messages[index];
                    final bool isMe = message.sender.id == currentUser.id;

                    return _buildMessage(message, isMe);
                  },
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
