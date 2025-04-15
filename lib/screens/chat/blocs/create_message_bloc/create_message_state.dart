part of 'create_message_bloc.dart';

sealed class CreateMessageState extends Equatable {
  const CreateMessageState();
  
  @override
  List<Object> get props => [];
}

final class CreateMessageInitial extends CreateMessageState {}

final class CreateMessageLoading extends CreateMessageState {}
final class CreateMessageSuccess extends CreateMessageState {}
final class CreateMessageFailure extends CreateMessageState {}
