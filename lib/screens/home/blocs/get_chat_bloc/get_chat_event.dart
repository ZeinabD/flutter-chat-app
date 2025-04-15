part of 'get_chat_bloc.dart';

sealed class GetChatEvent extends Equatable {
  const GetChatEvent();

  @override
  List<Object> get props => [];
}

class GetChat extends GetChatEvent{
  final String userId;

  const GetChat(this.userId);

  @override
  List<Object> get props => [userId];
}
