import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/models/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider provider;
  AuthBloc({required this.provider})
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>(_initialize);
    on<AuthEventLogin>(_login);
    on<AuthEventLogout>(_logout);
    on<AuthEventSendEmailVerification>(_sendEmailVerification);
    on<AuthEventRegister>(_register);
  }

  FutureOr<void> _initialize(
      AuthEventInitialize event, Emitter<AuthState> emit) async {
    await provider.initialize();
    final user = provider.currentUser;
    if (user == null) {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ),
      );
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification(isLoading: false));
    } else {
      emit(AuthStateLoggedIn(
        user: user,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _login(AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(
      const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while I log you in',
      ),
    );
    final email = event.email;
    final password = event.password;
    try {
      final user = await provider.logIn(
        email: email,
        password: password,
      );

      if (!user.isEmailVerified) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    } on Exception catch (e) {
      emit(
        AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ),
      );
    }
  }

  FutureOr<void> _logout(AuthEventLogout event, Emitter<AuthState> emit) async {
    try {
      await provider.logOut();
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ),
      );
    }
  }

  FutureOr<void> _sendEmailVerification(
      AuthEventSendEmailVerification event, Emitter<AuthState> emit) async {
    await provider.sendEmailVerification();
    emit(state);
  }

  FutureOr<void> _register(
      AuthEventRegister event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;
    try {
      await provider.createUser(
        email: email,
        password: password,
      );
      await provider.sendEmailVerification();
      emit(const AuthStateNeedsVerification(isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateRegistering(
        exception: e,
        isLoading: false,
      ));
    }
  }
}
