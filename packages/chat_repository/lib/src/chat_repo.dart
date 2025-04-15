import '../chat_repository.dart';

abstract class ChatRepo {
  Stream<List<MyMessage>> getMessages(String chatId);

  Future<void> addMessage(String chatId, MyMessage message);

  Stream<List<MyChat>> getChats(String userId);

  Future<void> createChat(MyChat chat);

  Future<bool> existChat(String contactId, String userId);

  Future<MyMessage?> getLastMessage(String chatId);
}