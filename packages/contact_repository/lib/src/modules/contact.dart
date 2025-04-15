import 'package:contact_repository/src/entities/contact_entity.dart';

class MyContact{
  String userId;
  String contactId;
  String name;
  String email;
  String picture;

  MyContact({
    required this.userId,
    required this.contactId,
    required this.name,
    required this.email,
    required this.picture,
  });

  static final empty = MyContact(userId: '', contactId: '', email: '', name: '', picture: '');

  MyContactEntity toEntity(){
    return MyContactEntity(
      userId: userId,
      contactId: contactId, 
      name: name, 
      email: email, 
      picture: picture
    );
  }

  static MyContact fromEntity(MyContactEntity entity){
    return MyContact(
      userId: entity.userId,
      contactId: entity.contactId, 
      name: entity.name, 
      email: entity.email, 
      picture: entity.picture
    );
  }
  
  @override
  String toString(){
    return 'MyContact: $userId, $contactId, $email, $name, $picture';
  }
}