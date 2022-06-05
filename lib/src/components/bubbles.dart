import 'package:flutter/material.dart';
import 'package:ftg/src/utils.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool showSender;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.showSender,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: message.outgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.outgoing && showSender)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: getUserAvatar(message.sender),
          ),
        MessageBubble(message: message, showSender: !message.outgoing && showSender),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool showSender;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.showSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = "${message.text} ";
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: message.outgoing ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        // I hope this is acceptable way to do this...
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: showSender ? 24 : 8, bottom: 20, left: 12, right: 12),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: text,
                    ),
                    TextSpan(
                      text: text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: text,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: text,
                      style: const TextStyle(fontFamily: "monospace"),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: message.outgoing ? Colors.white : Colors.black,
                ),
                maxLines: null,
              ),
            ),
            if (showSender)
              Positioned(
                top: 6,
                left: 12,
                child: Text(
                  message.sender.name,
                  style: TextStyle(
                    color: getColorByID(message.sender.id),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Positioned(
              bottom: 4,
              right: 8,
              child: Row(
                children: [
                  Text(
                    DateFormat.Hm().format(message.date),
                    style: TextStyle(
                      color: (message.outgoing ? Colors.white : Colors.black).withOpacity(0.8),
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                  if (message.outgoing)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.done_all,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
