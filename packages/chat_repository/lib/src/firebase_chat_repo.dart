import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../chat_repository.dart';

class FirebaseChatRepo implements ChatRepo{
  final chatsCollection = FirebaseFirestore.instance.collection('chats');

  @override
  Future<void> createChat(MyChat chat) async{
    try{
      await chatsCollection
        .doc(chat.chatId)
        .set(chat.toEntity().toDocument());
    }catch(e){
      print('Error "createChat": $e');
      rethrow;
    }
  }

  @override
  Stream<List<MyChat>> getChats(String userId) {
    return chatsCollection
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MyChat.fromEntity(ChatEntity.fromDocument(doc.data())))
        .toList());
  }

  @override
  Stream<List<MyMessage>> getMessages(String chatId) {
    return chatsCollection
          .doc(chatId)
          .collection('messages')
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => MyMessage.fromEntity(MyMessageEntity.fromDocument(doc.data())))
          .toList());
  }
  
  @override
  Future<void> addMessage(String chatId, MyMessage message) async {
    message.messageId = const Uuid().v1();
    message.sentAt = DateTime.now();
    await chatsCollection.doc(chatId)
          .collection('messages')
          .doc(message.messageId)
          .set(message.toEntity().toDocument());
  }
  

  @override
  Future<bool> existChat(String contactId, String userId) async {
    final chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();
  
    for (var chat in chatQuery.docs) {
      final participants = List<String>.from(chat['participants']);
      if (participants.contains(contactId)) {
        return true;
      }
    }
  
    return false;
  }
  
  @override
  Future<MyMessage?> getLastMessage(String chatId) async {
    try{
      QuerySnapshot querySnapshot = await chatsCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(1)
        .get();

      if(querySnapshot.docs.isNotEmpty){
        return MyMessage.fromEntity(MyMessageEntity.fromDocument(querySnapshot.docs.first as Map<String, dynamic>));
      }else{
        return null;
      }
    }catch(e){
      print("Error getting last message: $e");
      rethrow;
    }
  }

}