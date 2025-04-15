import '../modules/message.dart';
import 'message_entity.dart';

class ChatEntity {
  String chatId;
  List<String> participants;
  List<MyMessage>? messages;
  MyMessage? lastMessage;

  ChatEntity({
    required this.chatId,
    required this.participants,
    this.lastMessage,
    this.messages,
  });

  Map<String, Object> toDocument (){
    return {
      'chatId': chatId,
      'participants': participants.toList(),
      'lastMessage': lastMessage!.toEntity().toDocument(),
      'messages': messages!.map((msg) => msg.toEntity().toDocument()).toList() 
    };
  }

  static ChatEntity fromDocument(Map<String, dynamic> doc){
    return ChatEntity(
      chatId: doc['chatId'], 
      lastMessage: MyMessage.fromEntity(MyMessageEntity.fromDocument(doc['lastMessage'])), 
      participants: List<String>.from(doc['participants']), 
      messages: List.from(doc['messages'])
                    .map((msg) => MyMessage.fromEntity(MyMessageEntity.fromDocument(msg)))
                    .toList(), 
    );
  }
}