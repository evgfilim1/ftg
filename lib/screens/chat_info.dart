import 'package:flutter/material.dart';
import 'package:ftg/components/chat_info_title.dart';
import 'package:ftg/utils.dart';

import '../models/chat.dart';

class ChatInfoScreen extends StatefulWidget {
  const ChatInfoScreen({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatInfoHeader(
          chat: widget.chat,
          interactive: false,
        ),
      ),
      body: widget.chat is GroupChat
          ? ListView(
              children: (widget.chat as GroupChat)
                  .members
                  .map((e) => ListTile(
                        leading: getUserAvatar(e),
                        title: Text(e.name),
                        onTap: () {
                          final _messenger = ScaffoldMessenger.of(context);
                          _messenger.clearSnackBars();
                          _messenger.showSnackBar(SnackBar(
                            content: Text("Clicked on ${e.name} (${e.id})"),
                            duration: const Duration(seconds: 1),
                          ));
                        },
                      ))
                  .toList(),
            )
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text("ID"),
                  subtitle: Text(widget.chat.id.toString()),
                )
              ],
            ),
    );
  }
}
