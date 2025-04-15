part of 'create_contact_bloc.dart';

sealed class CreateContactState extends Equatable {
  const CreateContactState();
  
  @override
  List<Object> get props => [];
}

final class CreateContactInitial extends CreateContactState {}

final class CreateContactLoading extends CreateContactState {}
final class CreateContactSuccess extends CreateContactState {}
final class CreateContactFailure extends CreateContactState {}