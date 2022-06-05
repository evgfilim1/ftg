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
  final _scaffold = GlobalKey<ScaffoldState>();
  final _displayChats = <Chat>[];
  final _searchController = TextEditingController();

  void _write() {
    setState(() {
      final newChat = _generateChat();
      final query = _searchController.text.toLowerCase();
      _chats.add(newChat);
      if (query.isEmpty || newChat.title.toLowerCase().contains(query)) {
        _displayChats.add(newChat);
      }
    });
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    _displayChats.clear();
    _displayChats.addAll(_chats.where((chat) => chat.title.toLowerCase().contains(query)));
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
    final random = Random();
    final baseDate = DateTime.now().subtract(const Duration(days: 1));
    if (random.nextBool()) {
      final members = List<User>.generate(
        random.nextInt(2047) + 1,
        (i) => User(
          id: random.nextInt(1 << 16),
          name: generateWordPairs().first.asPascalCase,
        ),
      );
      return GroupChat(
        id: random.nextInt(1 << 32),
        title: generateWordPairs().first.join(' '),
        messages: List<Message>.generate(
          random.nextInt(20) + 5,
          (i) => Message(
            text: generateWordPairs().take(random.nextInt(3) + 1).map((e) => e.join(' ')).join(' '),
            date: baseDate.add(Duration(minutes: i)),
            sender: random.nextInt(3) == 0 ? User.me : members[random.nextInt(members.length)],
          ),
        ),
        members: members,
      );
    } else {
      final other = User(
        id: random.nextInt(1 << 16),
        name: generateWordPairs().first.asPascalCase,
      );
      return PrivateChat(
        id: other.id,
        title: other.name,
        messages: List<Message>.generate(
          random.nextInt(14) + 1,
          (i) => Message(
            text: generateWordPairs().take(random.nextInt(3) + 1).map((e) => e.join(' ')).join(' '),
            date: baseDate.add(Duration(minutes: i)),
            sender: random.nextBool() ? User.me : other,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _chats.add(savedMessages);
    _displayChats.addAll(_chats);
    _searchController.addListener(() => setState(() => _performSearch()));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Center(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(top: 60),
              children: _displayChats
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
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.all(6),
                    splashRadius: 16,
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      child: Icon(Icons.account_circle),
                    ),
                    onPressed: () {
                      _scaffold.currentState!.openDrawer();
                    },
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search",
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
          ],
        ),
      ),
      drawer: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 60, bottom: 8),
        child: Drawer(
          width: MediaQuery.of(context).size.width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                child: Center(
                  child: Text("f-Telegram", style: TextStyle(fontSize: 24)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text("Saved Messages+"),
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
                title: const Text("Useless Settings"),
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
                title: const Text("Logout"),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _write,
        tooltip: "Write a message",
        child: const Icon(Icons.edit),
      ),
    );
  }
}
