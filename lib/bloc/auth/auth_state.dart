import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? uid;
  final String? email;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.uid,
    this.email,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? uid,
    String? email,
    String? error,
  }) => AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        uid: uid ?? this.uid,
        email: email ?? this.email,
        error: error,
      );

  @override
  List<Object?> get props => [isAuthenticated, uid, email, error];
}
