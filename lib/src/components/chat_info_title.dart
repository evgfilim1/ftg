import 'dart:math';

import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../screens/chat_info.dart';
import '../utils.dart';

class ChatInfoHeader extends StatelessWidget {
  final Chat chat;
  final bool interactive;

  const ChatInfoHeader({
    super.key,
    required this.chat,
    required this.interactive,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return InkWell(
      onTap: interactive
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatInfoScreen(chat: chat)))
          : null,
      child: Row(
        children: [
          getChatAvatar(chat),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.title),
                Text(
                  chat is GroupChat
                      ? "${(chat as GroupChat).members.length} members"
                      : (random.nextBool() ? "online" : "last seen just now"),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
