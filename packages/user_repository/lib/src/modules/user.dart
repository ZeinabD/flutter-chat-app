import 'package:user_repository/user_repository.dart';

class MyUser{
  String userId;
  String email;
  String name;
  String picture;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.picture
  });

  static final empty = MyUser(userId: '', email: '', name: '', picture: '');

  MyUserEntity toEntity(){
    return MyUserEntity(
      userId: userId, 
      email: email, 
      name: name, 
      picture: picture
    );
  }

  static MyUser fromEntity(MyUserEntity entity){
    return MyUser(
      userId: entity.userId, 
      email: entity.email, 
      name: entity.name, 
      picture: entity.picture
    );
  }

  @override
  String toString(){
    return 'MyUser: $userId, $email, $name, $picture';
  }
}