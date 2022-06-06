import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat.dart';
import '../models/message.dart';
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
    final lastMessage = chat.messages.last;
    return ListTile(
      leading: getChatAvatar(chat),
      title: Text(chat.title),
      subtitle: Text(lastMessage is TextMessage ? lastMessage.text : "<Photo>"),
      trailing: Text(
        DateFormat.Hm().format(chat.messages.last.date),
        style: Theme.of(context).textTheme.caption,
      ),
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
