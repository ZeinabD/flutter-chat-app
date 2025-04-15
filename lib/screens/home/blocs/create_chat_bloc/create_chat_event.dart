part of 'create_chat_bloc.dart';

sealed class CreateChatEvent extends Equatable {
  const CreateChatEvent();

  @override
  List<Object> get props => [];
}

class CreateChat extends CreateChatEvent{
  final MyChat myChat;

  const CreateChat(this.myChat);

  @override
  List<Object> get props => [myChat];
}
