part of 'create_contact_bloc.dart';

sealed class CreateContactEvent extends Equatable {
  const CreateContactEvent();

  @override
  List<Object> get props => [];
}

class CreateContact extends CreateContactEvent{
  final MyContact myContact;

  const CreateContact(this.myContact);
  
  @override
  List<Object> get props => [myContact];
}