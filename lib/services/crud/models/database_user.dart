import 'package:my_notes/services/crud/constants/note_service_constants.dart';

class DatabaseUser {
  DatabaseUser({required this.id, required this.email});
  final int id;
  final String email;

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'DatabaseUser(id: $id, email: $email)';

  @override
  bool operator ==(covariant DatabaseUser other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
