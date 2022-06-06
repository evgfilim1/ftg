import 'package:flutter/widgets.dart';

import './message.dart';
import './user.dart';

enum ChatType {
  group,
  private,
}

abstract class Chat {
  final int id;
  final String title;
  final ChatType type;
  final List<Message> messages;
  final Widget? avatar;

  const Chat({
    required this.id,
    required this.title,
    required this.type,
    required this.messages,
    this.avatar,
  });

  void sendMessage(String text) {
    final message = TextMessage(
      text: text,
      date: DateTime.now(),
      sender: User.me,
    );
    messages.add(message);
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) || other is Chat && id == other.id && type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

class PrivateChat extends Chat {
  const PrivateChat({
    required int id,
    required String title,
    required List<Message> messages,
    Widget? avatar,
  }) : super(
          id: id,
          title: title,
          type: ChatType.private,
          messages: messages,
          avatar: avatar,
        );
}

class GroupChat extends Chat {
  final List<User> members;

  const GroupChat({
    required int id,
    required String title,
    required List<Message> messages,
    Widget? avatar,
    required this.members,
  }) : super(
          id: id,
          title: title,
          type: ChatType.group,
          messages: messages,
          avatar: avatar,
        );
}
