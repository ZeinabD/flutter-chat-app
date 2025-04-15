import '../entities/message_entity.dart';

class MyMessage{
  String messageId;
  DateTime sentAt;
  String senderId;
  String receiverId;
  String content;

  MyMessage({
    required this.messageId,
    required this.sentAt,
    required this.senderId,
    required this.content,
    required this.receiverId,
  });

  static final empty = MyMessage(messageId: '', sentAt: DateTime.now(), senderId: '', receiverId: '', content: '');

  static MyMessage fromEntity(MyMessageEntity entity){
    return MyMessage(
      messageId: entity.messageId,
      sentAt: entity.sentAt, 
      senderId: entity.senderId, 
      receiverId: entity.receiverId,
      content: entity.content, 
    );
  }

  MyMessageEntity toEntity(){
    return MyMessageEntity(
      messageId: messageId,
      sentAt: sentAt, 
      senderId: senderId, 
      receiverId: receiverId,
      content: content, 
    );
  }
}