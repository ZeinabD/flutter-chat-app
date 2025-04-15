part of 'get_chat_bloc.dart';

sealed class GetChatState extends Equatable {
  const GetChatState();
  
  @override
  List<Object> get props => [];
}

final class GetChatInitial extends GetChatState {}

final class GetChatEmpty extends GetChatState {}

final class GetChatLoading extends GetChatState {}

final class GetChatFailure extends GetChatState {}

final class GetChatSuccess extends GetChatState {
  final List<MyChat> chats;

  const GetChatSuccess(this.chats);

  @override  
  List<Object> get props => [chats];
}
