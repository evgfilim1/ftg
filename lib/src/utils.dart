import 'package:flutter/material.dart';

import './models/chat.dart';
import './models/message.dart';
import './models/user.dart';

const _colors = [
  Color(0xffe17076),
  Color(0xffeda86c),
  Color(0xffa695e7),
  Color(0xff7bc862),
  Color(0xff6ec9cb),
  Color(0xff65aadd),
  Color(0xffee7aae),
]; // taken from official app

Color getColorByID(int id) => _colors[id % _colors.length];

Widget getChatAvatar(Chat chat) => CircleAvatar(
      backgroundColor: getColorByID(chat.id),
      child: chat.avatar ??
          Text(
            chat.title[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
    );

Widget getUserAvatar(User user) => CircleAvatar(
      backgroundColor: getColorByID(user.id),
      child: Text(
        user.name[0].toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );

extension MessageExtension on Message {
  bool get outgoing => sender == User.me;
}
