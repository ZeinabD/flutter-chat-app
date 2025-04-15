class MyContactEntity{
  String userId;
  String contactId;
  String email;
  String name;
  String picture;

  MyContactEntity({
    required this.userId,
    required this.contactId,
    required this.email,
    required this.name,
    required this.picture,
  });

  Map<String, Object?> toDocument(){
    return{
      'userId': userId,
      'contactId': contactId,
      'email': email,
      'name': name,
      'picture': picture
    };
  }

  static MyContactEntity fromDocument(Map<String, dynamic> doc){
    return MyContactEntity(
      userId: doc['userId'],
      contactId: doc['contactId'], 
      email: doc['email'], 
      name: doc['name'], 
      picture: doc['picture']
    );
  }
}