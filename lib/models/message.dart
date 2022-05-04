import './user.dart';

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
