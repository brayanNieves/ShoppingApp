import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}
class AuthSignInWithGoogleRequested extends AuthEvent {}
class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInWithEmailRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}
class AuthSignOutRequested extends AuthEvent {}
