import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;

  AuthRepositoryImpl({required this.auth});

  UserEntity? _map(User? u) =>
      u == null
          ? null
          : UserEntity(
            uid: u.uid,
            email: u.email,
            displayName: u.displayName,
            photoUrl: u.photoURL,
          );

  @override
  Stream<UserEntity?> watchUser() => auth.authStateChanges().map(_map);

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async => auth.signOut();
}
