import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUserRepo implements UserRepo{
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if(firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await usersCollection
          .doc(firebaseUser.uid)
          .get()
          .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
      }
    });
  }

  @override
  Future<void> logOut() async {
    try{
      await _firebaseAuth.signOut();
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try{
      await usersCollection
        .doc(myUser.userId)
        .set(myUser.toEntity().toDocument());
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);
      myUser.userId = user.user!.uid;
      return myUser;      
    }catch(e){
      log(e.toString() as num);
      rethrow;
    }
  }
  
  @override
  Future<MyUser> getMyUser(String userId) async {
    try{
      return usersCollection.doc(userId).get().then((value) =>
        MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!))
      );
    }catch(e){
      print('Error in getMyUser: $e');
      rethrow;
    }
  }
  
  @override
  Future<String> uploadPicture(String userId, String file) async {
    try{
      File imageFile = File(file);
      Reference firebaseStoreRef = FirebaseStorage
        .instance 
        .ref()
        .child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    }catch(e){
      print(e.toString());
      rethrow;
    }
  }  
}