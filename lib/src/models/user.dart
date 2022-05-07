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
