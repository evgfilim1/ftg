import 'package:flutter/material.dart';
import 'package:ftg/src/utils.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';

enum ChatMessageStatus {
  sending,
  sent,
  read,
  error,
}

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final ChatMessageStatus? status;
  final bool showSender;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.status,
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
        MessageBubble(
          message: message,
          showSender: !message.outgoing && showSender,
          status: status,
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final ChatMessageStatus? status;
  final bool showSender;

  const MessageBubble({
    Key? key,
    required this.message,
    this.status,
    required this.showSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData statusIcon;
    switch (status) {
      case ChatMessageStatus.sending:
      case null:
        statusIcon = Icons.schedule;
        break;
      case ChatMessageStatus.sent:
        statusIcon = Icons.check;
        break;
      case ChatMessageStatus.read:
        statusIcon = Icons.done_all;
        break;
      case ChatMessageStatus.error:
        statusIcon = Icons.error;
        break;
    }
    final Widget content;
    if (message is TextMessage) {
      final text = "${(message as TextMessage).text} ";
      content = Text.rich(
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
      );
    } else if (message is PhotoMessage) {
      final photoMessage = message as PhotoMessage;
      content = Image.network(
        photoMessage.photo,
        loadingBuilder: (context, child, progress) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [const Center(child: CircularProgressIndicator()), child],
          );
        },
        errorBuilder: (context, _, __) => const Center(child: Icon(Icons.error)),
      );
    } else {
      throw UnsupportedError("Unsupported type of message");
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: message.outgoing ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: _MessageContainer(
          showSender: showSender,
          message: message,
          statusIcon: statusIcon,
          status: status,
          child: content,
        ),
      ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final bool showSender;
  final Message message;
  final IconData statusIcon;
  final ChatMessageStatus? status;
  final Widget child;

  const _MessageContainer({
    required this.showSender,
    required this.message,
    required this.statusIcon,
    required this.status,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // I hope this is acceptable way to do this...
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: showSender ? 24 : 8, bottom: 20, left: 12, right: 12),
          child: child,
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
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    statusIcon,
                    color: status != ChatMessageStatus.error ? Colors.white : Colors.redAccent,
                    size: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
