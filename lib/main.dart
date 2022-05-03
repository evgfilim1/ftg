import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:intl/intl.dart';

// TODO (2022-05-04): Split the file into multiple files

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f-Telegram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'f-Telegram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ChatType {
  group,
  private,
}

class User {
  static const me = User(id: 1, name: 'Me');

  const User({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  bool operator ==(Object? other) => identical(this, other) || other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Message {
  const Message({
    required this.text,
    required this.date,
    required this.sender,
  });

  final String text;
  final DateTime date;
  final User sender;
}

abstract class Chat {
  const Chat({
    required this.id,
    required this.title,
    required this.type,
    required this.messages,
    this.avatar,
  });

  final int id;
  final String title;
  final ChatType type;
  final List<Message> messages;
  final Widget? avatar;

  void sendMessage(String text) {
    final message = Message(
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

  final List<User> members;
}

class _MyHomePageState extends State<MyHomePage> {
  static final _colors = [
    0xffe17076,
    0xffeda86c,
    0xffa695e7,
    0xff7bc862,
    0xff6ec9cb,
    0xff65aadd,
    0xffee7aae,
  ].map((e) => Color(e)).toList(); // taken from official app
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

  static Widget _getChatIcon(Chat chat) => CircleAvatar(
        backgroundColor: _colors[chat.id % _colors.length],
        child: chat.avatar ??
            Text(
              chat.title[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: _chats
              .map((e) => ListTile(
                    leading: _getChatIcon(e),
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
              title: const Text('Imaginary Settings'),
              onTap: () {
                Navigator.pop(context);
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
        backgroundColor: _MyHomePageState._colors[user.id % _MyHomePageState._colors.length],
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
            _MyHomePageState._getChatIcon(widget.chat), // FIXME
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
