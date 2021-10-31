import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_flutter_firebase_chat/widgets/app_drawer_widget.dart';
import 'package:devfest_flutter_firebase_chat/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/helpers/constants.dart';
import 'package:devfest_flutter_firebase_chat/models/message.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';
import 'package:devfest_flutter_firebase_chat/services/database_service.dart';
import 'package:devfest_flutter_firebase_chat/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final AppUser toUser;

  const ChatScreen(
      {required this.currentUserId, required this.toUser, Key? key})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textMessageController = TextEditingController();
  bool _isComposing = false;
  late DatabaseService _databaseService;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _databaseService = Provider.of<DatabaseService>(context, listen: false);

    _setupMessages();
  }

  _setupMessages() async {
    List<Message> messages = await _databaseService.getChatMessages(
        widget.currentUserId, widget.toUser.id!);
    setState(() {
      _messages = messages;
    });
  }

  _buildMessage(Message message, bool isMe) {
    final Widget msg = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: isMe
            ? const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 80.0,
              )
            : const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: isMe
              ? AppConstants.hexToColor(AppConstants.APP_PRIMARY_TILE_COLOR)
              : AppConstants.hexToColor(
                  AppConstants.APP_BACKGROUND_COLOR_WHITE),
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            message.imageUrl == null
                ? _buildText(isMe, message)
                : _buildImage(context, message),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  timeFormat.format(message.timestamp!.toDate()),
                  style: TextStyle(
                    color: isMe
                        ? AppConstants.hexToColor(
                            AppConstants.APP_PRIMARY_COLOR_GREEN)
                        : AppConstants.hexToColor(
                            AppConstants.APP_BACKGROUND_COLOR_GRAY),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
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

  _buildText(bool isMe, Message message) {
    return Text(
      message.text!,
      style: TextStyle(
        color: isMe
            ? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_BLACK)
            : AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_GRAY),
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  _buildImage(BuildContext context, Message message) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      width: size.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(message.imageUrl!),
          )),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_WHITE),
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            onPressed: () async {
              XFile? imageFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (imageFile != null) {
                String imageUrl =
                    await Provider.of<StorageService>(context, listen: false)
                        .uploadMessageImage(File(imageFile.path));
                _handleSubmitted(null, imageUrl);
              }
            },
            child: Icon(
              Icons.camera_alt,
              color: AppConstants.hexToColor(
                  AppConstants.APP_BACKGROUND_COLOR_GRAY),
              size: 25.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(15.0),
          ),
          Expanded(
            child: TextField(
              controller: _textMessageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintText: 'Type your message...',
                filled: true,
                hintStyle: TextStyle(
                    color: AppConstants.hexToColor(
                        AppConstants.APP_PRIMARY_FONT_COLOR_LIGHT)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color:
                AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION),
            onPressed: _isComposing
                ? () => _handleSubmitted(_textMessageController.text, null)
                : null,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String? text, String? imageUrl) {
    if ((text != null && text.trim().isNotEmpty) || imageUrl != null) {
      if (imageUrl == null) {
        //text message

        setState(() {
          _isComposing = false;
        });
      }
      Message message = Message(
        senderId: widget.currentUserId,
        toUserId: widget.toUser.id,
        imageUrl: imageUrl,
        timestamp: Timestamp.fromDate(DateTime.now()),
        text: text,
        isLiked: true,
        unread: true,
      );
      setState(() {
        _messages.insert(0, message);
      });
      _databaseService.sendChatMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        title: Row(
          children: <Widget>[
            profileImage(widget.toUser),
            const SizedBox(width: 10.0),
            Text(
              widget.toUser.name!,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 10.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(top: 15.0),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = _messages[index];
                  final bool isMe = message.senderId == widget.currentUserId;
                  return _buildMessage(message, isMe);
                },
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
