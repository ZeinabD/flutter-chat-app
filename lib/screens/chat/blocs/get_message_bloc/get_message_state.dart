part of 'get_message_bloc.dart';

sealed class GetMessageState extends Equatable {
  const GetMessageState();
  
  @override
  List<Object> get props => [];
}

final class GetMessageInitial extends GetMessageState {}

final class GetMessageEmpty extends GetMessageState {}
final class GetMessageLoading extends GetMessageState {}
final class GetMessageFailure extends GetMessageState {}
final class GetMessageSuccess extends GetMessageState {
  final List<MyMessage> messages;

  const GetMessageSuccess(this.messages);
  
  @override
  List<Object> get props => [messages];
}
