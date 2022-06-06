import 'package:flutter/material.dart';

import '../components/chat_info_title.dart';
import '../models/chat.dart';
import '../utils.dart';

class ChatInfoScreen extends StatefulWidget {
  final Chat chat;

  const ChatInfoScreen({
    super.key,
    required this.chat,
  });

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
          ? ListView.builder(
              itemCount: (widget.chat as GroupChat).members.length,
              itemBuilder: (context, i) {
                final currentMember = (widget.chat as GroupChat).members[i];
                return ListTile(
                  leading: getUserAvatar(currentMember),
                  title: Text(currentMember.name),
                  onTap: () {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.clearSnackBars();
                    messenger.showSnackBar(SnackBar(
                      content: Text("Clicked on ${currentMember.name} (${currentMember.id})"),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                );
              },
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
