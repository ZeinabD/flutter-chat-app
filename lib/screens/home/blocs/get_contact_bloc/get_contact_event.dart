part of 'get_contact_bloc.dart';

sealed class GetContactEvent extends Equatable {
  const GetContactEvent();

  @override
  List<Object> get props => [];
}

class GetContact extends GetContactEvent{
  final String userId;

  const GetContact(this.userId);

  @override
  List<Object> get props => [userId];
}
