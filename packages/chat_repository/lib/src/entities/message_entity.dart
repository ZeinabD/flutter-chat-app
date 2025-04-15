import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessageEntity{
  String messageId;
  DateTime sentAt;
  String senderId;
  String receiverId;
  String content;

  MyMessageEntity({
    required this.messageId,
    required this.sentAt,
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  Map<String, Object> toDocument (){
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sentAt': sentAt,
    };
  }

  static MyMessageEntity fromDocument(Map<String, dynamic> doc){
    return MyMessageEntity(
      messageId: doc['messageId'],
      sentAt: (doc['sentAt'] as Timestamp).toDate(), 
      senderId: doc['senderId'], 
      receiverId: doc['receiverId'], 
      content: doc['content'], 
    );
  }
}