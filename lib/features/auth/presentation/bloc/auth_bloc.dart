import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthGooglePressed extends AuthEvent {}

class AuthEmailSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEmailSignIn(this.email, this.password);
}

class AuthEmailSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthEmailSignUp(this.email, this.password);
}

class AuthSignOut extends AuthEvent {}

class _AuthUserChanged extends AuthEvent {
  final UserEntity? user;

  _AuthUserChanged(this.user);
}

abstract class AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription? _sub;

  AuthBloc({required this.authRepository}) : super(AuthLoading()) {
    on<AuthStarted>(_onStarted);
    on<AuthEmailSignIn>(_onEmailIn);
    on<AuthEmailSignUp>(_onEmailUp);
    on<AuthSignOut>(_onOut);
    on<_AuthUserChanged>(_onChanged);
  }

  Future<void> _onStarted(AuthStarted e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _sub?.cancel();
    _sub = authRepository.watchUser().listen((u) {
      return add(_AuthUserChanged(u));
    }, onError: (e) => emit(AuthFailure(e.toString())));
  }

  Future<void> _onEmailIn(AuthEmailSignIn e, Emitter<AuthState> emit) async {
    try {
      await authRepository.signInWithEmail(e.email, e.password);
    } catch (err) {
      emit(AuthFailure(err.toString()));
    }
  }

  Future<void> _onEmailUp(AuthEmailSignUp e, Emitter<AuthState> emit) async {
    try {
      await authRepository.signUpWithEmail(e.email, e.password);
    } catch (err) {
      emit(AuthFailure(err.toString()));
    }
  }

  Future<void> _onOut(AuthSignOut e, Emitter<AuthState> emit) async {
    try {
      await authRepository.signOut();
    } catch (err) {
      emit(AuthFailure(err.toString()));
    }
  }

  void _onChanged(_AuthUserChanged e, Emitter<AuthState> emit) {
    if (e.user != null) {
      emit(AuthAuthenticated(e.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
