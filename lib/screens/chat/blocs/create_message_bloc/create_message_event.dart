part of 'create_message_bloc.dart';

sealed class CreateMessageEvent extends Equatable {
  const CreateMessageEvent();

  @override
  List<Object> get props => [];
}

class CreateMessage extends CreateMessageEvent{
  final String chatId;
  final MyMessage message;

  const CreateMessage(this.chatId, this.message);

  @override
  List<Object> get props => [chatId, message];
}
