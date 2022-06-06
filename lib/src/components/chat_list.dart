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
    return ListView.builder(
      padding: const EdgeInsets.only(top: 60),
      itemCount: chats.length,
      itemBuilder: (context, i) {
        final currentChat = chats[i];
        return ChatListTile(chat: currentChat);
      },
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
