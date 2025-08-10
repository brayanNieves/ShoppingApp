// Implementación minimal; sólo se activa si USE_FIREBASE=true
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// Evita dependencias duras si no hay Firebase en compile-time.
typedef _FirebaseUser = Object?;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthSignInWithGoogleRequested>(_onGoogle);
    on<AuthSignInWithEmailRequested>(_onEmail);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    // En una app real, leeríamos FirebaseAuth.instance.currentUser
    emit(state.copyWith(isAuthenticated: false));
  }

  Future<void> _onGoogle(AuthSignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    try {
      // Placeholder. Documentado en README para implementar con Firebase.
      emit(state.copyWith(isAuthenticated: true, uid: 'demo', email: 'demo@demo.com'));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onEmail(AuthSignInWithEmailRequested event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isAuthenticated: true, uid: 'demo-email', email: event.email));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState());
  }
}
