import 'package:user_repository/user_repository.dart';

abstract class UserRepo {
  Stream<MyUser?> get user; 

  Future<void> logOut();

  Future<void> signIn(String email, String password);

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<MyUser> getMyUser(String userId);

  Future<void> setUserData(MyUser myUser);

  Future<String> uploadPicture(String userId, String file);
}