import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../screens/chat.dart';
import '../utils.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  const ChatList({
    super.key,
    required this.chats,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 60),
      children: chats.map((e) => ChatListTile(chat: e)).toList(growable: false),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final Chat chat;

  const ChatListTile({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getChatAvatar(chat),
      title: Text(chat.title),
      subtitle: Text(chat.messages.last.text),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chat: chat),
          ),
        );
      },
    );
  }
}
