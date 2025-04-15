part of 'get_contact_bloc.dart';

sealed class GetContactState extends Equatable {
  const GetContactState();
  
  @override
  List<Object> get props => [];
}

final class GetContactInitial extends GetContactState {}

final class GetContactLoading extends GetContactState {}
final class GetContactSuccess extends GetContactState {
  final List<MyContact> contacts;

  const GetContactSuccess(this.contacts);

  @override
  List<Object> get props => [contacts];
}
final class GetContactFailure extends GetContactState {}
