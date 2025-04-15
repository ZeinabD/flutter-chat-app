class MyUserEntity{
  String userId;
  String email;
  String name;
  String picture;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.picture
  });

  static MyUserEntity fromDocument(Map<String, dynamic> doc){
    return MyUserEntity(
      userId: doc['userId'] ?? '', 
      email: doc['email'] ?? '', 
      name: doc['name'] ?? '', 
      picture: doc['picture'] ?? ''
    );
  }

  Map<String, Object?> toDocument(){
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'picture': picture
    };
  }
}