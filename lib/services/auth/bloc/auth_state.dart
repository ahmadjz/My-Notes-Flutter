// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState(); // we create construct to use const with its children
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
  });
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
  });
}

class AuthStateLogoutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogoutFailure({
    required this.exception,
  });
}
