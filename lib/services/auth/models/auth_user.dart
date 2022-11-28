import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser(
      {required this.id, required this.isEmailVerified, required this.email});
  final bool isEmailVerified;
  final String email;
  final String id;

  factory AuthUser.fromFirebase(User user) => AuthUser(
      isEmailVerified: user.emailVerified, email: user.email!, id: user.uid);
}
