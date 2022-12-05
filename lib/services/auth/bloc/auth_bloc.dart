import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
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
    on<AuthEventForgotPassword>(_forgotPassword);
    on<AuthEventShouldRegister>(_navigateToRegister);
    on<AuthEventLogOut>(_navigateToLogin);
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

  FutureOr<void> _forgotPassword(
      AuthEventForgotPassword event, Emitter<AuthState> emit) async {
    emit(const AuthStateForgotPassword(
      exception: null,
      hasSentEmail: false,
      isLoading: false,
    ));
    final email = event.email;
    if (email == null) {
      return; // user just wants to go to forgot-password screen
    }

    // user wants to actually send a forgot-password email
    emit(const AuthStateForgotPassword(
      exception: null,
      hasSentEmail: false,
      isLoading: true,
    ));

    bool didSendEmail;
    Exception? exception;
    try {
      await provider.sendPasswordReset(toEmail: email);
      didSendEmail = true;
      exception = null;
    } on Exception catch (e) {
      didSendEmail = false;
      exception = e;
    }

    emit(AuthStateForgotPassword(
      exception: exception,
      hasSentEmail: didSendEmail,
      isLoading: false,
    ));
  }

  FutureOr<void> _navigateToRegister(
      AuthEventShouldRegister event, Emitter<AuthState> emit) {
    emit(const AuthStateRegistering(
      exception: null,
      isLoading: false,
    ));
  }

  FutureOr<void> _navigateToLogin(
      AuthEventLogOut event, Emitter<AuthState> emit) async {
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
}
