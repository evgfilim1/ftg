import 'dart:math';

import 'package:flutter/material.dart';

import '../components/bubbles.dart';
import '../components/chat_info_title.dart';
import '../models/chat.dart';

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
            child: ListView.builder(
              reverse: true,
              itemCount: widget.chat.messages.length,
              itemBuilder: (context, i) {
                final currentMessage = widget.chat.messages[widget.chat.messages.length - i - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ChatMessageBubble(
                    message: currentMessage,
                    status:
                        ChatMessageStatus.values[Random().nextInt(ChatMessageStatus.values.length)],
                    showSender: widget.chat is GroupChat,
                  ),
                );
              },
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
                        hintText: "Type a message...",
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
}
