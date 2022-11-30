import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/models/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider provider;
  AuthBloc({required this.provider}) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(_initialize);
    on<AuthEventLogin>(_login);
    on<AuthEventLogout>(_logout);
  }

  FutureOr<void> _initialize(
      AuthEventInitialize event, Emitter<AuthState> emit) async {
    await provider.initialize();
    final user = provider.currentUser;
    if (user == null) {
      emit(const AuthStateLoggedOut(exception: null));
    } else {
      emit(AuthStateLoggedIn(user: user));
    }
  }

  FutureOr<void> _login(AuthEventLogin event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;

    try {
      final user = await provider.logIn(
        email: email,
        password: password,
      );
      emit(AuthStateLoggedIn(user: user));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e));
    }
  }

  FutureOr<void> _logout(AuthEventLogout event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoading());
    try {
      final user = await provider.logOut();
      emit(const AuthStateLoggedOut(exception: null));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e));
    }
  }
}
