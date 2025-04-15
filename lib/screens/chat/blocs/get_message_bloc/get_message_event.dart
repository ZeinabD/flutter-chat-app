part of 'get_message_bloc.dart';

sealed class GetMessageEvent extends Equatable {
  const GetMessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessage extends GetMessageEvent{
  final String chatId;

  const GetMessage(this.chatId);

  @override
  List<Object> get props => [chatId];
}
