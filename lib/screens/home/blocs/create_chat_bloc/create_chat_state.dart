part of 'create_chat_bloc.dart';

sealed class CreateChatState extends Equatable {
  const CreateChatState();
  
  @override
  List<Object> get props => [];
}

final class CreateChatInitial extends CreateChatState {}

final class CreateChatLoading extends CreateChatState {}
final class CreateChatSuccess extends CreateChatState {}
final class ChatAlreadyExists extends CreateChatState {}
final class CreateChatFailure extends CreateChatState {}
