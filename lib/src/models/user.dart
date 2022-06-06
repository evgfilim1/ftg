class User {
  static const me = User(id: 1, name: 'Me');

  final int id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object? other) => identical(this, other) || other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
