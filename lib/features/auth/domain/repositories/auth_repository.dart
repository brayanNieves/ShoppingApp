import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> watchUser();

  Future<void> signInWithEmail(String email, String password);

  Future<void> signUpWithEmail(String email, String password);

  Future<void> signOut();
}
