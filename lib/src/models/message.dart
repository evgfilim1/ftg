import './user.dart';

abstract class Message {
  final DateTime date;
  final User sender;

  const Message({
    required this.date,
    required this.sender,
  });
}

class TextMessage extends Message {
  final String text;

  const TextMessage({
    required super.date,
    required super.sender,
    required this.text,
  });
}

class PhotoMessage extends Message {
  final String photo;

  const PhotoMessage({
    required super.date,
    required super.sender,
    required this.photo,
  });
}
