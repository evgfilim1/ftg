import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import './chat.dart';
import './login.dart';
import './settings/menu.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _chats = List<Chat>.generate(4, (i) => _generateChat());
  static final _baseDate = DateTime.now().subtract(const Duration(days: 1));

  void _write() {
    setState(() {
      _chats.add(_generateChat());
    });
  }

  static final savedMessages = PrivateChat(
    id: User.me.id,
    title: 'Saved Messages',
    messages: List<Message>.generate(
      25,
      (i) => Message(
        text: generateWordPairs().take(Random().nextInt(3) + 1).map((e) => e.join(' ')).join(' '),
        date: _baseDate.add(Duration(minutes: i)),
        sender: User.me,
      ),
    ),
    avatar: const Icon(
      Icons.bookmark,
      color: Colors.white,
    ),
  );

  static Chat _generateChat() {
    final _random = Random();
    final _baseDate = DateTime.now().subtract(const Duration(days: 1));
    if (_random.nextBool()) {
      final _members = List<User>.generate(
        _random.nextInt(2047) + 1,
        (i) => User(
          id: _random.nextInt(1 << 16),
          name: generateWordPairs().first.asPascalCase,
        ),
      );
      return GroupChat(
        id: _random.nextInt(1 << 32),
        title: generateWordPairs().first.join(' '),
        messages: List<Message>.generate(
          _random.nextInt(20) + 5,
          (i) => Message(
            text:
                generateWordPairs().take(_random.nextInt(3) + 1).map((e) => e.join(' ')).join(' '),
            date: _baseDate.add(Duration(minutes: i)),
            sender: _random.nextInt(3) == 0 ? User.me : _members[_random.nextInt(_members.length)],
          ),
        ),
        members: _members,
      );
    } else {
      final _other = User(
        id: _random.nextInt(1 << 16),
        name: generateWordPairs().first.asPascalCase,
      );
      return PrivateChat(
        id: _other.id,
        title: _other.name,
        messages: List<Message>.generate(
          _random.nextInt(14) + 1,
          (i) => Message(
            text:
                generateWordPairs().take(_random.nextInt(3) + 1).map((e) => e.join(' ')).join(' '),
            date: _baseDate.add(Duration(minutes: i)),
            sender: _random.nextBool() ? User.me : _other,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("f-Telegram"),
      ),
      body: Center(
        child: ListView(
          children: _chats
              .map((e) => ListTile(
                    leading: getChatAvatar(e),
                    title: Text(e.title),
                    subtitle: Text(e.messages.last.text),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chat: e),
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Center(
                child: Text("Let's imagine this is a header"),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved Messages+'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chat: savedMessages),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Useless Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _write,
        tooltip: 'Write a message',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
