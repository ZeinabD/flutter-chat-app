import 'package:chat_repository/chat_repository.dart';

class MyChat {
  String chatId;
  List<String> participants;
  List<MyMessage>? messages;
  MyMessage? lastMessage;

  MyChat({
    required this.chatId,
    required this.participants,
    this.messages,
    this.lastMessage,
  });

  static final empty = MyChat(chatId: '', participants: [], lastMessage: MyMessage.empty, messages: null);

  static MyChat fromEntity(ChatEntity entity){
    return MyChat(
      chatId: entity.chatId, 
      participants: entity.participants, 
      messages: entity.messages ?? [], 
      lastMessage: entity.lastMessage, 
    );
  }

  ChatEntity toEntity(){
    return ChatEntity(
      chatId: chatId, 
      participants: participants, 
      lastMessage: lastMessage,
      messages: messages ?? [], 
    );
  }
}