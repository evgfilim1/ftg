import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import './chat.dart';
import './login.dart';
import './settings/menu.dart';
import '../components/chat_list.dart';
import '../components/search_chat_field.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      _chats.add(newChat);
      _performSearch();
    });
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    _displayChats.clear();
    if (query.isNotEmpty) {
      _displayChats.addAll(_chats.where((chat) => chat.title.toLowerCase().contains(query)));
    } else {
      _displayChats.addAll(_chats);
    }
    _displayChats.sort((a, b) => b.messages.last.date.compareTo(a.messages.last.date));
  }

  static final savedMessages = PrivateChat(
    id: User.me.id,
    title: 'Saved Messages',
    messages: List<Message>.generate(
      25,
      (i) => TextMessage(
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
          (i) {
            final date = baseDate.add(Duration(minutes: i));
            final sender =
                random.nextInt(3) == 0 ? User.me : members[random.nextInt(members.length)];
            return random.nextBool()
                ? TextMessage(
                    text: generateWordPairs()
                        .take(random.nextInt(3) + 1)
                        .map((e) => e.join(' '))
                        .join(' '),
                    date: date,
                    sender: sender,
                  )
                : PhotoMessage(
                    date: date,
                    sender: sender,
                    photo: "https://picsum.photos/seed/${random.nextInt(2048)}/512?random=$i",
                  );
          },
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
          (i) {
            final date = baseDate.add(Duration(minutes: i));
            final sender = random.nextBool() ? User.me : other;
            return random.nextBool()
                ? TextMessage(
                    text: generateWordPairs()
                        .take(random.nextInt(3) + 1)
                        .map((e) => e.join(' '))
                        .join(' '),
                    date: date,
                    sender: sender,
                  )
                : PhotoMessage(
                    date: date,
                    sender: sender,
                    photo: "https://picsum.photos/seed/${random.nextInt(2048)}/512?random=$i",
                  );
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _chats.add(savedMessages);
    _performSearch();
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
      body: SafeArea(
        child: Stack(
          children: [
            ChatList(chats: _displayChats),
            SearchChatField(controller: _searchController, scaffoldKey: _scaffold),
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
