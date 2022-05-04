import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ftg/screens/chat_info.dart';

import '../models/chat.dart';
import '../utils.dart';

class ChatInfoHeader extends StatelessWidget {
  final Chat chat;
  final bool interactive;

  const ChatInfoHeader({
    Key? key,
    required this.chat,
    required this.interactive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _random = Random();

    return InkWell(
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
                      : (_random.nextBool() ? "online" : "last seen just now"),
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
      onTap: interactive
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatInfoScreen(chat: chat)))
          : null,
    );
  }
}
