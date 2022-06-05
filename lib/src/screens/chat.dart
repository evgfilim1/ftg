import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:intl/intl.dart';

import '../components/chat_info_title.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../utils.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({
    super.key,
    required this.chat,
  });

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ChatInfoHeader(
          chat: widget.chat,
          interactive: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: widget.chat.messages
                    .map((e) => _buildMessageWidget(e, context, widget.chat is GroupChat))
                    .toList(),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.secondaryHeaderColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
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
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Message e, BuildContext context, bool isGroupChat) {
    final isSelf = e.sender == User.me;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSelf && isGroupChat)
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
    final isSelf = e.sender == User.me;
    final cs = Theme.of(context).colorScheme;
    return ChatBubble(
      clipper: ChatBubbleClipper1(
        type: isSelf ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      backGroundColor: isSelf ? cs.background : cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSelf && isGroupChat)
            Text(
              e.sender.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColorByID(e.sender.id),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
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
          ),
        ],
      ),
    );
  }
}
