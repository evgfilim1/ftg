import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:ftg/utils.dart';
import 'package:intl/intl.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static Widget _getUserIcon(User user) => CircleAvatar(
        backgroundColor: getColorByID(user.id),
        child: Text(
          user.name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      );

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      widget.chat.sendMessage(text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _random = Random();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            getChatAvatar(widget.chat),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.title),
                  Text(
                    widget.chat is GroupChat
                        ? "${(widget.chat as GroupChat).members.length} members"
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widget.chat.messages
                    .map((e) => _buildMessageWidget(e, context, widget.chat is GroupChat))
                    .toList(),
              ),
              reverse: true,
            ),
          ),
          Row(
            children: [
              IconButton(
                padding: const EdgeInsets.symmetric(),
                icon: const Icon(Icons.attach_file),
                onPressed: () {},
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: _sendMessage,
                    autofocus: true,
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.symmetric(),
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Message e, BuildContext context, bool isGroupChat) {
    final _isSelf = e.sender == User.me;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: _isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!_isSelf)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _getUserIcon(e.sender),
            ),
          _buildChatBubble(e, context, isGroupChat),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message e, BuildContext context, bool isGroupChat) {
    final _isSelf = e.sender == User.me;
    final _cs = Theme.of(context).colorScheme;
    return ChatBubble(
      clipper: ChatBubbleClipper1(
        type: _isSelf ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isSelf && isGroupChat)
            Text(
              e.sender.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          Row(
            children: [
              Text(e.text),
              const SizedBox(width: 8),
              Text(
                DateFormat("hh:mm a").format(e.date),
                style: const TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ],
      ),
      backGroundColor: _isSelf ? _cs.secondary : _cs.background,
    );
  }
}